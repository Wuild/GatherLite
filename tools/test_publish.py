"""Local publisher tests use mocked HTTP; no credentials or live uploads."""

from contextlib import redirect_stdout, redirect_stderr
from email.parser import BytesParser
from email.policy import default
from io import StringIO
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch, MagicMock
from urllib.error import HTTPError, URLError

import publish
from package_forever import prepare_package


class PublishTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.env = self.root / ".env"

    def test_literal_dotenv_values(self):
        for line in ("CURSEFORGE_TOKEN=abc123", "export CURSEFORGE_TOKEN='abc123' # comment",
                     'CURSEFORGE_TOKEN = "abc123"', "CURSEFORGE_TOKEN=abc123 # comment"):
            with self.subTest(line=line):
                self.env.write_text("# comment\nOTHER=value\n" + line, encoding="utf-8-sig")
                self.assertEqual(publish.read_token(self.env), "abc123")
        self.env.write_text("CURSEFORGE_TOKEN='literal$VARIABLE'", encoding="utf-8")
        self.assertEqual(publish.read_token(self.env), "literal$VARIABLE")

    def test_invalid_token_file_never_echoes_token(self):
        for content in ("", "CURSEFORGE_TOKEN=", 'CURSEFORGE_TOKEN="secret-unclosed',
                        "CURSEFORGE_TOKEN=secret value", "CURSEFORGE_TOKEN=a\nCURSEFORGE_TOKEN=b"):
            self.env.write_text(content, encoding="utf-8")
            with self.assertRaises(publish.PublishError) as error:
                publish.read_token(self.env)
            self.assertNotIn("secret", str(error.exception))
        self.env.unlink()
        with self.assertRaises(publish.PublishError):
            publish.read_token(self.env)

    def test_exact_game_version(self):
        self.assertEqual(publish.resolve_game_version([
            {"name": "1.60.10", "id": 5}, {"name": "1.60.1", "id": 42}]), 42)
        for response in ({}, [], [{"name": "1.60.1", "id": True}],
                         [{"name": "1.60.1", "id": "42"}],
                         [{"name": "1.60.1", "id": 0}],
                         [{"name": "1.60.1", "id": 1}, {"name": "1.60.1", "id": 2}]):
            with self.subTest(response=response), self.assertRaises(publish.PublishError):
                publish.resolve_game_version(response)

    def test_config_settings_and_defaults(self):
        self.assertEqual(publish.read_game_versions(self.env), ["1.60.1"])
        self.assertEqual(publish.read_project_id(self.env), 334918)
        self.env.write_text('CURSEFORGE_GAME_VERSION="1.60.2" # patch\nCURSEFORGE_PROJECT_ID=12345', encoding="utf-8")
        self.assertEqual(publish.read_game_versions(self.env), ["1.60.2"])
        self.assertEqual(publish.read_project_id(self.env), 12345)
        self.assertEqual(publish.resolve_game_version([
            {"name": "1.60.1", "id": 1}, {"name": "1.60.2", "id": 2}], "1.60.2"), 2)
        for content in ("CURSEFORGE_GAME_VERSION=", "CURSEFORGE_GAME_VERSION=invalid",
                        "CURSEFORGE_PROJECT_ID=0", "CURSEFORGE_PROJECT_ID=-1",
                        "CURSEFORGE_PROJECT_ID=abc", "CURSEFORGE_PROJECT_ID=1\nCURSEFORGE_PROJECT_ID=2"):
            self.env.write_text(content, encoding="utf-8")
            with self.assertRaises(publish.PublishError):
                publish.read_game_versions(self.env)
                publish.read_project_id(self.env)

    def test_configured_preview_and_upload(self):
        self.env.write_text("CURSEFORGE_GAME_VERSION=1.60.2\nCURSEFORGE_PROJECT_ID=12345\nCURSEFORGE_TOKEN=private-token", encoding="utf-8")
        output = StringIO()
        with patch("publish.api_json") as api, patch("publish.build_package") as build, redirect_stdout(output):
            self.assertEqual(publish.main(["--version", "8.0.1", "--env-file", str(self.env), "--dry-run"]), 0)
            api.assert_not_called()
            build.assert_not_called()
        self.assertIn("project 12345; WoW 1.60.2", output.getvalue())
        self.assertIn("for WoW Forever 1.60.2.", output.getvalue())
        archive = self.root / "release.fixture"
        archive.write_bytes(b"fixture")
        with patch("publish.api_json", side_effect=[[{"name": "1.60.2", "id": 99}], {"id": 456}]) as api, \
                patch("publish.build_package", return_value=(archive, "8.0.1", "notes", 1)), redirect_stdout(StringIO()):
            self.assertEqual(publish.main(["--version", "8.0.1", "--env-file", str(self.env)]), 0)
        self.assertEqual(api.call_args.args[0], "/projects/12345/upload-file")
        self.assertIn(b'"gameVersions": [99]', api.call_args.args[2])

    def test_multiple_game_versions_trim_and_deduplicate(self):
        self.env.write_text('CURSEFORGE_GAME_VERSION="1.60.1, 1.60.2,1.60.1"', encoding="utf-8")
        self.assertEqual(publish.read_game_versions(self.env), ["1.60.1", "1.60.2"])
        for value in ("1.60.1,", ",1.60.1", "1.60.1,,1.60.2", "1.60.1,invalid"):
            self.env.write_text("CURSEFORGE_GAME_VERSION=" + value, encoding="utf-8")
            with self.subTest(value=value), self.assertRaises(publish.PublishError):
                publish.read_game_versions(self.env)

    def test_multiple_versions_preview_and_single_upload(self):
        self.env.write_text("CURSEFORGE_GAME_VERSION=1.60.1, 1.60.2\nCURSEFORGE_TOKEN=private-token", encoding="utf-8")
        output = StringIO()
        with patch("publish.api_json") as api, patch("publish.build_package") as build, redirect_stdout(output):
            self.assertEqual(publish.main(["--version", "8.0.1", "--env-file", str(self.env), "--dry-run"]), 0)
            api.assert_not_called()
            build.assert_not_called()
        self.assertIn("WoW 1.60.1, 1.60.2", output.getvalue())
        archive = self.root / "release.fixture"
        archive.write_bytes(b"fixture")
        with patch("publish.api_json", side_effect=[[
                {"name": "1.60.1", "id": 42}, {"name": "1.60.2", "id": 99}], {"id": 456}]) as api, \
                patch("publish.build_package", return_value=(archive, "8.0.1", "notes", 1)), redirect_stdout(StringIO()):
            self.assertEqual(publish.main(["--version", "8.0.1", "--env-file", str(self.env)]), 0)
        self.assertEqual(api.call_count, 2)
        self.assertIn(b'"gameVersions": [42, 99]', api.call_args.args[2])

    def test_missing_second_version_prevents_build_and_upload(self):
        self.env.write_text("CURSEFORGE_GAME_VERSION=1.60.1,1.60.2\nCURSEFORGE_TOKEN=private-token", encoding="utf-8")
        with patch("publish.api_json", return_value=[{"name": "1.60.1", "id": 42}]) as api, \
                patch("publish.build_package") as build, redirect_stdout(StringIO()), redirect_stderr(StringIO()):
            self.assertEqual(publish.main(["--version", "8.0.1", "--env-file", str(self.env)]), 1)
        self.assertEqual(api.call_count, 1)
        build.assert_not_called()

    def test_multipart_preserves_metadata_and_file_bytes(self):
        archive = self.root / "release.fixture"
        data = b"PK\x00\xff\r\nBinary data"
        archive.write_bytes(data)
        metadata = {"changelog": "Herbs — updated\nSecond line", "gameVersions": [42]}
        body, content_type = publish.multipart(archive, metadata)
        message = BytesParser(policy=default).parsebytes(
            f"Content-Type: {content_type}\r\nMIME-Version: 1.0\r\n\r\n".encode() + body)
        parts = list(message.iter_parts())
        self.assertEqual(len(parts), 2)
        import json
        self.assertEqual(json.loads(parts[0].get_payload(decode=True)), metadata)
        self.assertEqual(parts[1].get_payload(decode=True), data)
        self.assertEqual(parts[1].get_filename(), archive.name)

    def test_http_uses_header_token_and_no_redirect_handler(self):
        response = MagicMock()
        response.__enter__.return_value.read.return_value = b'{"id": 123}'
        with patch("publish.build_opener") as opener:
            opener.return_value.open.return_value = response
            self.assertEqual(publish.api_json("/game/versions", "private-token"), {"id": 123})
            request = opener.return_value.open.call_args.args[0]
            self.assertEqual(request.get_header("X-api-token"), "private-token")
            self.assertNotIn("private-token", request.full_url)
            self.assertIsInstance(opener.call_args.args[0], publish.NoRedirects)

    def test_api_errors_do_not_echo_credentials(self):
        for error in (HTTPError(publish.API, 403, "private-token", {}, None),
                      URLError("private-token")):
            with patch("publish.build_opener") as opener:
                opener.return_value.open.side_effect = error
                with self.assertRaises(publish.PublishError) as caught:
                    publish.api_json("/game/versions", "private-token")
                self.assertNotIn("private-token", str(caught.exception))
                self.assertEqual(opener.return_value.open.call_count, 1)

    def test_redirect_is_refused(self):
        with self.assertRaises(HTTPError):
            publish.NoRedirects().redirect_request(
                publish.Request(publish.API), None, 302, "redirect", {}, "https://example.com")

    def test_dry_run_never_builds_reads_credentials_or_calls_api(self):
        with patch("publish.read_token") as token, patch("publish.api_json") as api, \
                patch("publish.build_package") as build, redirect_stdout(StringIO()):
            self.assertEqual(publish.main(["--version", "8.0.1", "--dry-run", "--env-file", str(self.env)]), 0)
            token.assert_not_called()
            api.assert_not_called()
            build.assert_not_called()

    def test_package_only_builds_without_token_or_network(self):
        output = StringIO()
        with patch("publish.read_token") as token, patch("publish.api_json") as api, \
                patch("publish.build_package", return_value=(self.root / "GatherLite-8.0.1.zip", "8.0.1", "notes", 1)) as build, \
                redirect_stdout(output):
            self.assertEqual(publish.main(["--version", "8.0.1", "--package-only", "--env-file", str(self.env)]), 0)
        token.assert_not_called()
        api.assert_not_called()
        build.assert_called_once()
        self.assertIn("Package created:", output.getvalue())
        self.assertIn(".zip.sha256", output.getvalue())

    def test_package_only_and_dry_run_are_mutually_exclusive(self):
        with redirect_stderr(StringIO()), self.assertRaises(SystemExit):
            publish.main(["--version", "8.0.1", "--package-only", "--dry-run"])

    def test_real_payload_excludes_env_and_publishing_tools(self):
        payload, version, notes = prepare_package(publish.ROOT, "8.0.1")
        self.assertIn("GatherLite.toc", payload)
        self.assertIn(f"## Version: {version}", payload["GatherLite.toc"].decode())
        self.assertTrue(notes)
        self.assertFalse(any(".env" in p or p.startswith("tools/") for p in payload))

    def test_version_lookup_failure_prevents_build_and_upload(self):
        with patch("publish.read_token", return_value="private-token"), \
                patch("publish.api_json", return_value=[]) as api, \
                patch("publish.build_package") as build, \
                redirect_stdout(StringIO()), redirect_stderr(StringIO()):
            self.assertEqual(publish.main(["--version", "8.0.1", "--env-file", str(self.env)]), 1)
            self.assertEqual(api.call_count, 1)
            build.assert_not_called()

    def test_complete_publish_flow_with_mock_api(self):
        self.env.write_text("CURSEFORGE_TOKEN=private-token", encoding="utf-8")
        archive = self.root / "release.fixture"
        archive.write_bytes(b"test archive")
        output = StringIO()
        with patch("publish.api_json", side_effect=[
                [{"name": "1.60.1", "id": 42}], {"id": 12345}]) as api, \
                patch("publish.build_package", return_value=(archive, "8.0.1", "Release notes", 1)), \
                redirect_stdout(output):
            self.assertEqual(publish.main(["--version", "8.0.1", "--env-file", str(self.env)]), 0)
        self.assertEqual(api.call_count, 2)
        path, token, body, content_type = api.call_args.args
        self.assertEqual(path, "/projects/334918/upload-file")
        self.assertEqual(token, "private-token")
        self.assertIn(b'"gameVersions": [42]', body)
        self.assertIn(b'"releaseType": "release"', body)
        self.assertNotIn(b"private-token", body)
        self.assertIn("/gatherlite/files/12345", output.getvalue())
        self.assertNotIn("private-token", output.getvalue())

    def test_uncertain_upload_is_not_retried(self):
        archive = self.root / "release.fixture"
        archive.write_bytes(b"test archive")
        for response in ({}, {"id": True}, {"id": 0}, {"id": "123"}):
            with patch("publish.api_json", return_value=response) as api:
                with self.assertRaisesRegex(publish.PublishError, "Check the author dashboard"):
                    publish.upload(archive, "8.0.1", "notes", [42], "private-token")
                self.assertEqual(api.call_count, 1)
        with patch("publish.api_json", side_effect=publish.PublishError("Timeout")) as api:
            with self.assertRaisesRegex(publish.PublishError, "may have been accepted"):
                publish.upload(archive, "8.0.1", "notes", [42], "private-token")
            self.assertEqual(api.call_count, 1)


if __name__ == "__main__":
    unittest.main()
