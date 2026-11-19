"""Graphical browser transport; validation and caching belong to the importer."""
from email.message import Message
from urllib.error import HTTPError


class BrowserFetcher:
    """Reuse one ordinary, isolated Chromium session without identity overrides."""

    def __init__(self):
        self._runtime = None
        self._browser = None
        self._page = None

    def __enter__(self):
        # Start lazily: offline runs and cache hits must need no browser installation.
        return self

    def __exit__(self, *args):
        try:
            if self._browser is not None:
                self._browser.close()
        finally:
            if self._runtime is not None:
                self._runtime.stop()
            self._runtime = self._browser = self._page = None

    def _minimize_window(self):
        # Chromium's launch flag can be ignored for Playwright's new window.
        # Minimize the actual page window before sending it to Wowhead.
        session = self._page.context.new_cdp_session(self._page)
        try:
            window = session.send("Browser.getWindowForTarget")
            session.send("Browser.setWindowBounds", {
                "windowId": window["windowId"],
                "bounds": {"windowState": "minimized"},
            })
        finally:
            session.detach()

    def __call__(self, url):
        try:
            from playwright.sync_api import Error, TimeoutError as BrowserTimeout, sync_playwright
        except ModuleNotFoundError:
            raise OSError("Browser fetching requires Playwright: python -m pip install -r tools/requirements-browser.txt; "
                          "python -m playwright install chromium") from None
        try:
            if self._page is None:
                self._runtime = sync_playwright().start()
                self._browser = self._runtime.chromium.launch(
                    headless=False, channel="chromium", args=["--start-minimized"])
                self._page = self._browser.new_page()
                self._minimize_window()
            response = self._page.goto(url, wait_until="domcontentloaded", timeout=30000)
            if response is None:
                raise OSError("Browser navigation returned no document response")
            if response.status >= 400:
                # Preserve status and Retry-After for the maintenance retry policy.
                headers = Message()
                for key, value in response.all_headers().items():
                    headers[key] = value
                raise HTTPError(url, response.status, "Browser request refused",
                                headers, None)
            # Ordinary navigation may initially return 202 before page scripts
            # finish loading the document. Never cache that intermediate page.
            self._page.wait_for_function("""() =>
                document.querySelector('link[rel="canonical"]') &&
                (document.getElementById('data.page.listPage.listviews') ||
                 Array.from(document.scripts).some(script =>
                    /\\bg_mapperData\\s*=|WH\\.Gatherer\\.addData\\(/.test(script.textContent)))
                """, timeout=30000)
            return self._page.content(), self._page.url
        except BrowserTimeout:
            raise TimeoutError("Browser navigation timed out") from None
        except Error:
            raise OSError("Browser navigation failed; check Chromium installation with "
                          "python -m playwright install chromium") from None
