const axios = require("axios");
const Three = require("three");
const fs = require("fs");
const path = require("path");
const jsdom = require("jsdom");
const {VirtualConsole} = require("jsdom");
const {JSDOM} = jsdom;

const {CheckIDS, ConvertMapID2UIMapID, MapID2Instance} = require("./lib/zones")
const {Objects2Lua} = require("./lib/lua");

function node(type, object, incoming) {
    let data = [];
    for (let id in incoming) {
        for (let coord in incoming[id][0]["coords"]) {
            let mapId = ConvertMapID2UIMapID(id);
            if (mapId)
                data.push({
                    type: type,
                    object: CheckIDS(object),
                    predefined: true,
                    loot: [],
                    coins: "0",
                    mapID: mapId,
                    posX: parseFloat((incoming[id][0]["coords"][coord][0] / 100).toFixed(3)),
                    posY: parseFloat((incoming[id][0]["coords"][coord][1] / 100).toFixed(3)),
                    instance: MapID2Instance(id)
                });
            
        }
    }
    return data;
}

function GetData(data, type, site = "wowhead") {
    return new Promise(resolve => {
        let jobs = [];
        for (let i = 0; i < data[type].length; i++) {
            let url;

            switch (site) {
                default:
                    url = `https://tbc.wowhead.com/object=${data[type][i]}`;
                    break;

                case "twinstar":
                    url = `https://vanilla-twinhead.twinstar.cz/?object=${data[type][i]}`;
                    break;
            }

            jobs.push(axios.get(url).then(res => {
                return new Promise(pr => {

                    const dom = new JSDOM(res.data);
                    dom.window.document.querySelectorAll("script").forEach(link => {
                        if (link.innerHTML.match(/g_mapperData/i)) {
                            let test = new JSDOM("<script>" + link.innerHTML + "</script>", {
                                runScripts: "dangerously", virtualConsole: new VirtualConsole().sendTo(
                                    // options.console || console,
                                    {
                                        log: () => {

                                        },
                                        error: () => {

                                        }
                                    }
                                ),
                            });
                            let t = "containers";
                            if (type === "ores") {
                                t = "mining";
                            } else if (type === "herbs") {
                                t = "herbalism";
                            } else if (type === "fishing") {
                                t = "fishing";
                            }

                            let d = node(t, data[type][i], test.window.g_mapperData);
                            pr(d);
                        }
                    });
                    pr([]);
                });
            }));
        }

        Promise.all(jobs).then((rows) => {
            resolve(rows);
        }).catch((err) => {
            console.error(err);
            resolve(rows);
        });
    });
}


function CheckDistance(x, y, mapID, object, rows, unique) {
    let a = new Three.Vector2(x, y);
    for (let i = 0; i < rows.length; i++) {
        if (rows[i].mapID === mapID) {

            if (unique) {
                if (object === rows[i].object && a.distanceTo(new Three.Vector2(rows[i].posX, rows[i].posY)) < 0.0065) {
                    return true;
                }
            } else {
                if (a.distanceTo(new Three.Vector2(rows[i].posX, rows[i].posY)) < 0.0065) {
                    return true;
                }
            }
        }
    }
    return false;
}


function getExpansion(exp = "vanilla", data = {}) {
    let objects = [];
    for (const type in data) {
        objects.push(new Promise(res => {
            console.log("Downloading", type)

            GetData(data, type, type === "fishing" ? "twinstar" : undefined).then(rows => {

                let nodes = [];

                for (const arr in rows) {
                    // nodes = nodes.concat(rows[arr]);

                    for (let i = 0; i < rows[arr].length; i++) {
                        // console.log(rows[arr][i]);
                        let row = rows[arr][i];
                        if (row !== undefined) {
                            row.type = type;
                            nodes.push(row)
                            if (!CheckDistance(row.posX, row.posY, row.mapID, row.object, nodes, type !== "fishing")) {
                                nodes.push(row)
                            }
                        }
                    }
                }

                let out = "";
                switch (type) {
                    case "containers":
                        out = Objects2Lua({GatherLite_localContainerNodes: nodes});
                        break;
                    case "mining":
                        out = Objects2Lua({GatherLite_localOreNodes: nodes});
                        break;

                    case "herbalism":
                        out = Objects2Lua({GatherLite_localHerbNodes: nodes});
                        break;

                    case "fishing":
                        out = Objects2Lua({GatherLite_localFishingNodes: nodes});
                        break;
                }

                if (!fs.existsSync(path.resolve(__dirname, '..', '..', 'scripts', 'db')))
                    fs.mkdirSync(path.resolve(__dirname, '..', '..', 'scripts', 'db'));

                fs.writeFileSync(path.resolve(__dirname, '..', '..', 'scripts', 'db', `${type}.lua`), out, {
                    encoding: 'utf8',
                    flag: 'w'
                });
                console.log(type, "data complete")
                res();
            })
        }));
    }

    Promise.all(objects).then(() => {
        console.log("All data downloaded!")
    })
}

const vanilla = require("./objects");


getExpansion("vanilla", vanilla)