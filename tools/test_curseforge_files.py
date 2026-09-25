"""Read API preflight tests. No live credentials or uploads."""
import io
import json
from pathlib import Path
import tempfile
import unittest
from contextlib import redirect_stderr
from unittest.mock import MagicMock, patch
from urllib.error import HTTPError
import curseforge_files as cf
from publish import PublishError


def item(file_id=10, version='8.0.3'):
    return dict(id=file_id,modId=334918,displayName='GatherLite '+version,fileName='GatherLite-'+version+'.zip')


def page(data,index=0,total=None):
    return {'data':data,'pagination':{'index':index,'resultCount':len(data),'totalCount':len(data) if total is None else total}}


class ReadFilesTests(unittest.TestCase):
    def test_read_key_header_and_documented_endpoint(self):
        response=MagicMock()
        response.__enter__.return_value.read.return_value=json.dumps(page([item()])).encode()
        with patch.object(cf,'build_opener') as opener:
            opener.return_value.open.return_value=response
            cf.request_page(334918,'private-read-key',0)
        request=opener.return_value.open.call_args.args[0]
        self.assertEqual(request.full_url,'https://api.curseforge.com/v1/mods/334918/files?index=0&pageSize=50')
        self.assertEqual(request.get_header('X-api-key'),'private-read-key')
        self.assertIsNone(request.get_header('X-api-token'))
        self.assertNotIn('private-read-key',request.full_url)
        self.assertIsInstance(opener.call_args.args[0],cf.NoRedirects)

    def test_all_pages_are_required(self):
        with patch.object(cf,'request_page',side_effect=[page([item()],0,2),page([item(11,'8.0.9')],1,2)]) as get:
            files=cf.list_files(334918,'key')
        self.assertEqual(get.call_count,2)
        self.assertEqual(cf.next_patch(files,{},334918),('8.0.9','8.0.10'))

    def test_incomplete_duplicate_wrong_project_and_changing_pages_fail(self):
        wrong=item(); wrong['modId']=1
        cases=[{'data':[]},page([wrong]),page([item(),item()]),page([],0,2),page([item()],1,1)]
        for response in cases:
            with self.subTest(response=response),patch.object(cf,'request_page',return_value=response),self.assertRaises(PublishError):
                cf.list_files(334918,'key')
        with patch.object(cf,'request_page',side_effect=[page([item()],0,2),page([item(11)],1,3)]),self.assertRaises(PublishError):
            cf.list_files(334918,'key')

    def test_numeric_version_and_successful_record(self):
        watcher={'last_successful_publish':{'project_id':334918,'file_id':10,'version':'8.0.3'}}
        self.assertEqual(cf.next_patch([item(),item(11,'8.0.10')],watcher,334918),('8.0.10','8.0.11'))
        with self.assertRaises(PublishError): cf.next_patch([item(11,'8.0.10')],watcher,334918)

    def test_pending_unknown_and_conflicting_versions_block(self):
        with self.assertRaises(PublishError): cf.next_patch([item()],{'pending_upload':{'version':'8.0.4'}},334918)
        with self.assertRaises(PublishError): cf.next_patch([],{},334918)
        with self.assertRaises(PublishError): cf.next_patch([item(version='unknown')],{},334918)
        conflict=item(); conflict['fileName']='GatherLite-8.0.4.zip'
        with self.assertRaises(PublishError): cf.next_patch([conflict],{},334918)

    def test_403_is_not_retried_and_error_is_sanitized(self):
        with patch.object(cf,'build_opener') as opener,patch.object(cf.time,'sleep') as sleep:
            opener.return_value.open.side_effect=HTTPError(cf.API,403,'private-read-key',{},None)
            with self.assertRaises(PublishError) as caught: cf.request_page(334918,'private-read-key',0)
            self.assertNotIn('private-read-key',str(caught.exception))
            self.assertEqual(opener.return_value.open.call_count,1)
            sleep.assert_not_called()

    def test_429_honors_retry_after(self):
        response=MagicMock(); response.__enter__.return_value.read.return_value=b'{}'
        with patch.object(cf,'build_opener') as opener,patch.object(cf.time,'sleep') as sleep,redirect_stderr(io.StringIO()):
            opener.return_value.open.side_effect=[HTTPError(cf.API,429,'rate limit',{'Retry-After':'90'},None),response]
            cf.request_page(334918,'key',0)
            self.assertEqual(sum(call.args[0] for call in sleep.call_args_list),90)
            self.assertEqual(opener.return_value.open.call_count,2)

    def test_missing_read_key_never_falls_back_to_upload_token(self):
        with tempfile.TemporaryDirectory() as directory:
            root=Path(directory); env=root/'.env'; out=root/'result.json'
            env.write_text('CURSEFORGE_TOKEN=private-upload-token\n')
            with patch.object(cf,'list_files') as lookup,redirect_stderr(io.StringIO()) as stderr:
                result=cf.main(['--env-file',str(env),'--watcher-state',str(root/'state.json'),'--output',str(out)])
            self.assertEqual(result,1); lookup.assert_not_called(); self.assertFalse(out.exists())
            self.assertIn('CURSEFORGE_API_KEY',stderr.getvalue())
            self.assertNotIn('private-upload-token',stderr.getvalue())


if __name__=='__main__': unittest.main()
