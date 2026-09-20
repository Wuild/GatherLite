"""Download fish icons and remove edge-connected black backgrounds, preserving pixel art.

Requires Pillow. Source JPEGs remain unchanged; outputs are 64x64 RGBA TGA files.
"""
import argparse
from collections import deque
import hashlib
import json
from pathlib import Path
from urllib.request import Request, urlopen
from PIL import Image, ImageDraw

ROOT=Path(__file__).resolve().parents[1]
SOURCE="https://wow.zamimg.com/images/wow/icons/large/"

def cutout(image, threshold=30, name=None):
    image=image.convert("RGB")
    width,height=image.size
    pixels=image.load()
    background=set()
    queue=deque()
    for x in range(width):
        queue.extend(((x,0),(x,height-1)))
    for y in range(height):
        queue.extend(((0,y),(width-1,y)))
    while queue:
        x,y=queue.popleft()
        if not (0<=x<width and 0<=y<height) or (x,y) in background:
            continue
        if max(pixels[x,y])>threshold:
            continue
        background.add((x,y))
        queue.extend(((x-1,y),(x+1,y),(x,y-1),(x,y+1)))
    result=image.convert("RGBA")
    output=result.load()
    for y in range(height):
        for x in range(width):
            r,g,b=pixels[x,y]
            if (x,y) in background:
                output[x,y]=(0,0,0,0)
            elif any((x+dx,y+dy) in background for dx,dy in ((-1,0),(1,0),(0,-1),(0,1))):
                # Feather only the dark JPEG fringe directly touching removed background.
                alpha=min(255,max(0,round((max(r,g,b)-threshold)*255/(70-threshold))))
                if 0<alpha<255:
                    # Original edge pixels were composited over black; remove that matte.
                    output[x,y]=(min(255,round(r*255/alpha)),min(255,round(g*255/alpha)),
                                 min(255,round(b*255/alpha)),alpha)
    if name=="inv_misc_fish_12":
        # Lightning Eel has a blue glow instead of a black backdrop. This traced
        # silhouette preserves the fish's original pixels and removes that glow.
        if (width,height)!=(56,56):
            raise ValueError("Lightning Eel silhouette expects the original 56x56 source")
        outline=[(0,18),(4,14),(6,14),(9,17),(13,20),(13,14),(10,12),
                 (9,9),(11,6),(16,3),(21,3),(26,6),(33,6),(40,8),
                 (48,10),(56,13),(56,56),(38,56),(34,53),(28,52),
                 (24,49),(22,43),(20,39),(15,36),(11,33),(8,29),
                 (5,24),(2,22),(0,20)]
        mask=Image.new("L",(width*4,height*4),0)
        ImageDraw.Draw(mask).polygon([(x*4,y*4) for x,y in outline],fill=255)
        mask=mask.resize((width,height),Image.Resampling.LANCZOS)
        result=image.convert("RGBA")
        result.putalpha(mask)
    # WoW textures require power-of-two dimensions. Pad rather than redraw the icon.
    if width>64 or height>64:
        raise ValueError(f"Unexpected source icon size: {image.size}")
    canvas=Image.new("RGBA",(64,64),(0,0,0,0))
    canvas.paste(result,((64-width)//2,(64-height)//2))
    return canvas

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-dir",type=Path,default=ROOT/".wowhead-cache/fish-icons")
    args=parser.parse_args()
    state=json.loads((ROOT/"tools/wowhead/fish.json").read_text())
    names=sorted({r["icon"] for r in state["items"].values()})
    args.source_dir.mkdir(parents=True,exist_ok=True)
    destination=ROOT/"icons/Fish"
    destination.mkdir(parents=True,exist_ok=True)
    manifest={}
    for name in names:
        path=args.source_dir/(name+".jpg")
        url=SOURCE+name+".jpg"
        if not path.exists():
            with urlopen(Request(url,headers={"User-Agent":"GatherLite-IconImporter/1.0"}),timeout=30) as response:
                data=response.read()
            path.write_bytes(data)
        with Image.open(path) as source:
            image=cutout(source,name=name)
        image.save(destination/(name+".tga"))
        alpha=image.getchannel("A")
        histogram=alpha.histogram()
        if not histogram[0] or not histogram[255]:
            raise ValueError(f"Missing transparent or opaque pixels in {name}")
        manifest[name]={"source":url,"sha256":hashlib.sha256(path.read_bytes()).hexdigest()}
        print(f"{name}: {histogram[0]} transparent pixels, {sum(histogram[1:255])} softened edges")
    (ROOT/"tools/wowhead/fish-icons.json").write_text(json.dumps(manifest,indent=2)+"\n",encoding="utf-8")

if __name__=="__main__":
    main()
