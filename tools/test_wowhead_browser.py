"""Offline tests for the optional browser transport and its importer boundary."""
import io
import json
from pathlib import Path
import sys
import tempfile
from types import ModuleType
import unittest
from unittest.mock import MagicMock, patch
from urllib.error import HTTPError

import update_forever_wowhead as importer
from wowhead_browser import BrowserFetcher


class BrowserError(Exception):
    pass


class BrowserTimeout(BrowserError):
    pass


class BrowserTests(unittest.TestCase):
    def setUp(self):
        self.api = ModuleType('playwright.sync_api')
        self.api.Error = BrowserError
        self.api.TimeoutError = BrowserTimeout
        self.api.sync_playwright = MagicMock()
        self.runtime = self.api.sync_playwright.return_value.start.return_value
        self.browser = self.runtime.chromium.launch.return_value
        self.page = self.browser.new_page.return_value
        self.page.goto.return_value.status = 200
        self.page.content.return_value = '<html>browser document</html>'
        self.page.url = importer.SOURCE + 'object=1731'
        modules = patch.dict(sys.modules, {'playwright': ModuleType('playwright'),
                                          'playwright.sync_api': self.api})
        modules.start()
        self.addCleanup(modules.stop)

    def test_one_browser_reused_and_closed(self):
        with BrowserFetcher() as fetch:
            self.api.sync_playwright.assert_not_called()
            for _ in range(2):
                self.assertEqual(fetch(self.page.url), ('<html>browser document</html>', self.page.url))
        self.runtime.chromium.launch.assert_called_once_with(headless=True, channel='chromium')
        self.browser.new_page.assert_called_once()
        self.browser.close.assert_called_once()
        self.runtime.stop.assert_called_once()

    def test_http_errors_preserve_retry_after_and_close(self):
        for code in (403, 429, 503):
            self.page.goto.return_value.status = code
            self.page.goto.return_value.all_headers.return_value = {'retry-after': '1200'}
            with self.subTest(code=code), BrowserFetcher() as fetch:
                with self.assertRaises(HTTPError) as error:
                    fetch(self.page.url)
                self.assertEqual(error.exception.code, code)
                self.assertEqual(error.exception.headers.get('Retry-After'), '1200')
                error.exception.close()
        self.page.content.assert_not_called()

    def test_graphical_mode_minimizes_and_waits_for_document(self):
        self.page.goto.return_value.status = 202
        with BrowserFetcher(headless=False) as fetch:
            fetch(self.page.url)
        self.runtime.chromium.launch.assert_called_once_with(
            headless=False, channel='chromium', args=['--start-minimized'])
        self.page.wait_for_function.assert_called_once()

    def test_intermediate_document_timeout_is_not_returned(self):
        self.page.goto.return_value.status = 202
        self.page.wait_for_function.side_effect = BrowserTimeout('no data')
        with self.assertRaises(TimeoutError), BrowserFetcher() as fetch:
            fetch(self.page.url)
        self.page.content.assert_not_called()

    def test_timeout_is_retryable_and_closes_browser(self):
        self.page.goto.side_effect = BrowserTimeout('timeout')
        with self.assertRaises(TimeoutError), BrowserFetcher() as fetch:
            fetch(self.page.url)
        self.browser.close.assert_called_once()
        self.runtime.stop.assert_called_once()

    def test_launch_failure_stops_runtime(self):
        self.runtime.chromium.launch.side_effect = BrowserError('missing browser')
        with self.assertRaisesRegex(OSError, 'install chromium'), BrowserFetcher() as fetch:
            fetch(self.page.url)
        self.runtime.stop.assert_called_once()

    def test_no_response_is_rejected(self):
        self.page.goto.return_value = None
        with self.assertRaisesRegex(OSError, 'no document response'), BrowserFetcher() as fetch:
            fetch(self.page.url)


class TransportBoundaryTests(unittest.TestCase):
    def setUp(self):
        temp = tempfile.TemporaryDirectory()
        self.addCleanup(temp.cleanup)
        self.cache = Path(temp.name)
        self.url = importer.SOURCE + 'object=1731'
        self.html = ('<link rel="canonical" href="' + self.url + '">'
                     '<script>var g_mapperData = {"12":[{"uiMapId":1429,"coords":[[20,30]]}]};</script>')

    def test_browser_document_validated_cached_and_reused(self):
        fetch = MagicMock(return_value=(self.html, self.url))
        with patch.object(importer.time, 'sleep'):
            for _ in range(2):
                self.assertEqual(importer.fetch_page(1731, self.cache, False, False, 10, [0], fetch), self.html)
        fetch.assert_called_once_with(self.url)

    def test_invalid_response_does_not_replace_good_cache(self):
        path = self.cache / '1731.html'
        path.write_text(self.html)
        for html, url in [('challenge', self.url),
                          (self.html.replace('g_mapperData', 'otherData'), self.url),
                          (self.html, self.url.replace('/forever/', '/classic/'))]:
            with self.subTest(url=url, html=html), patch.object(importer.time, 'sleep'):
                with self.assertRaises(importer.ImportError):
                    importer.fetch_page(1731, self.cache, False, True, 10, [0], lambda _: (html, url))
            self.assertEqual(path.read_text(), self.html)

    def test_listing_validation_and_partial_cache_resume(self):
        def document(category, obj, kind):
            data = [{'id': 'objects', 'data': [{'id': obj, 'name': 'Node', 'skill': 1, 'type': kind}]}]
            return ('<link rel="canonical" href="' + importer.SOURCE + 'objects/' + category + '">'
                    '<script id="data.page.listPage.listviews">' + json.dumps(data) + '</script>')
        ore = document('mineral-veins', 1731, -4)
        herb = document('herbs', 1617, -3)
        (self.cache / 'mineral-veins.html').write_text(ore)
        fetch = MagicMock(return_value=(herb, importer.SOURCE + 'objects/herbs'))
        with patch.object(importer.time, 'sleep'), patch('sys.stdout', new_callable=io.StringIO):
            ids, _ = importer.discover_objects({1731: ('mining', 1731), 1617: ('herbalism', 1617)},
                                              self.cache, False, False, 10, [0], fetch)
        self.assertEqual(ids, {1731, 1617})
        fetch.assert_called_once_with(importer.SOURCE + 'objects/herbs')

    def test_offline_browser_flag_needs_no_optional_dependency(self):
        (self.cache / '1731.html').write_text(self.html)
        with patch.dict(sys.modules, {'wowhead_browser': None}), patch('sys.stdout', new_callable=io.StringIO):
            self.assertEqual(importer.main(['--browser', '--offline', '--objects', '1731', '--dry-run',
                                           '--cache-dir', str(self.cache)]), 0)

    def test_online_command_uses_selected_browser_and_closes_it(self):
        fetch = MagicMock(return_value=(self.html, self.url))
        with patch('wowhead_browser.BrowserFetcher') as browser, patch('sys.stdout', new_callable=io.StringIO):
            browser.return_value.__enter__.return_value = fetch
            result = importer.main(['--browser', '--browser-headed', '--objects', '1731',
                                    '--dry-run', '--cache-dir', str(self.cache)])
        self.assertEqual(result, 0)
        browser.assert_called_once_with(headless=False)
        fetch.assert_called_once_with(self.url)
        browser.return_value.__exit__.assert_called_once()


if __name__ == '__main__':
    unittest.main()
