import json
import unittest
from update_fish_wowhead import parse_page, render, validate_url, ImportError

def page(heading="Fishing Locations", coords=None, canonical="https://www.wowhead.com/forever/item=6291"):
    if coords is None: coords=[[25,40],[25,40]]
    mapper={"12":[{"uiMapId":1429,"coords":coords}]}
    return f'''<link rel="canonical" href="{canonical}"><h2>{heading}</h2>
<script>WH.Gatherer.addData(3,16,{{"6291":{{"name_enus":"Raw Brilliant Smallfish","icon":"inv_misc_fish_08"}}}});
var g_mapperData = {json.dumps(mapper)};
new Listview({{id: 'fished-in', data: [{{"id":12,"name":"Elwynn Forest"}}]}});
</script>'''

class FishImportTests(unittest.TestCase):
    def test_catches_use_ui_map_ids_and_deduplicate(self):
        result=parse_page(page(),6291)
        self.assertEqual(result["maps"],{"1429":[250000,400000]})
        self.assertEqual(result["zones"],[{"areaID":12,"name":"Elwynn Forest"}])

    def test_vendor_coordinates_never_become_catches(self):
        result=parse_page(page("Vendor Locations"),6291)
        self.assertEqual(result["maps"],{})
        self.assertEqual(result["areaMaps"],{"12":1429})
        self.assertIn("[1429]={}",render({"6291":result}))

    def test_invalid_coordinates(self):
        for coords in [[[101,20]],[[True,20]],[[20]],[[float("nan"),20]]]:
            with self.subTest(coords=coords), self.assertRaises(ImportError):
                parse_page(page(coords=coords),6291)

    def test_wrong_client_or_item(self):
        for url in ["https://www.wowhead.com/classic/item=6291","https://www.wowhead.com/forever/item=6289",
                    "https://example.com/forever/item=6291"]:
            with self.subTest(url=url),self.assertRaises(ImportError):
                parse_page(page(canonical=url),6291)

    def test_vendor_page_without_fishing_data_rejected(self):
        with self.assertRaises(ImportError):
            parse_page(page("Vendor Locations").replace("fished-in","sold-by"),6291)

    def test_packaged_catalog_matches_source_state(self):
        from pathlib import Path
        root=Path(__file__).resolve().parents[1]
        state=json.loads((root/"tools/wowhead/fish.json").read_text())
        self.assertEqual((root/"plugins/fishing/data.lua").read_text(),render(state["items"]))
        self.assertEqual(len(state["items"]),25)
        for item,record in state["items"].items():
            validate_url(record["source"],int(item))
            for coords in record["maps"].values():
                self.assertEqual(len(coords)%2,0)
                self.assertTrue(all(type(v)==int and 0<=v<=1000000 for v in coords))

    def test_bundled_fish_icons_are_transparent_tga(self):
        from pathlib import Path
        import struct
        root=Path(__file__).resolve().parents[1]
        state=json.loads((root/"tools/wowhead/fish.json").read_text())
        manifest=json.loads((root/"tools/wowhead/fish-icons.json").read_text())
        for icon in {record["icon"] for record in state["items"].values()}:
            with self.subTest(icon=icon):
                data=(root/"icons/Fish"/(icon+".tga")).read_bytes()
                self.assertEqual(data[2],2, "expected uncompressed true-color TGA")
                self.assertEqual(struct.unpack_from("<HH",data,12),(64,64))
                self.assertEqual(data[16],32)
                self.assertEqual(data[17]&15,8, "alpha channel not declared")
                start=18+data[0]
                alpha=data[start+3:start+64*64*4:4]
                self.assertEqual(len(alpha),4096)
                self.assertIn(0,alpha)
                self.assertIn(255,alpha)
                self.assertTrue(any(0<a<255 for a in alpha), "missing antialiased edges")
                self.assertTrue(all(a==0 for a in alpha[:64]+alpha[-64:]), "opaque outer border")
                self.assertEqual(manifest[icon]["source"],
                    "https://wow.zamimg.com/images/wow/icons/large/"+icon+".jpg")
