const axios = require("axios");
const Three = require("three");
const fs = require("fs");
const path = require("path");
const jsdom = require("jsdom");
const {VirtualConsole} = require("jsdom");
const {JSDOM} = jsdom;
const _ = require("lodash");

const {CheckIDS, ConvertMapID2UIMapID, MapID2Instance} = require("./lib/zones")
const {Objects2Lua} = require("./lib/lua");

const expansions = {
    "vanilla": require("./data/vanilla"),
    "wotlk": require("./data/wotlk")
};

function createDirectories(pathStr) {
    let directoriesPath = path.resolve(pathStr);

    if (!fs.existsSync(directoriesPath)) {
        fs.mkdirSync(directoriesPath, {recursive: true});
        console.log(`Directory is created: ${directoriesPath}`);
    }
}

function IsNodeInRange(x, y, nodeX, nodeY) {

    let a = new Three.Vector2(x, y);
    let distance = a.distanceTo(new Three.Vector2(nodeX, nodeY));

    // console.log(distance)

    return distance < 0.0065

    // let distance = ((((x - nodeX) ^ 2) + ((y - nodeY) ^ 2)) ^ 0.5);
    // return distance < 0.01
}

function findExistingNode(list, type, mapID, x, y) {

    let nodes = _.filter(list, function (node) {
        return node.mapID === mapID && type === node.object;
    });

    for (let i = 0; i < nodes.length; i++) {
        let node = nodes[i];
        if (IsNodeInRange(x, y, node.posX, node.posY)) {
            return true;
        }
    }
    return false;
}

function node(type, object, incoming) {
    let data = [];
    for (let id in incoming) {
        if (incoming[id][0])
            for (let coord in incoming[id][0]["coords"]) {
                let mapId = ConvertMapID2UIMapID(id);
                let x = parseFloat((incoming[id][0]["coords"][coord][0] / 100).toFixed(3));
                let y = parseFloat((incoming[id][0]["coords"][coord][1] / 100).toFixed(3));
                let objectID = CheckIDS(object);

                if (mapId && !findExistingNode(data, objectID, mapId, x, y))
                    data.push({
                        type: type,
                        object: objectID,
                        predefined: true,
                        loot: [],
                        coins: "0",
                        mapID: mapId,
                        posX: x,
                        posY: y,
                        instance: MapID2Instance(id)
                    });

            }
    }
    return data;
}

var sprintf = require('sprintf-js').vsprintf;

function GetData(baseUrl, data, type) {
    return new Promise((resolve, reject) => {
        let jobs = [];
        for (let i = 0; i < data.length; i++) {
            // url = exp === "wotlk" ? `https://www.wowhead.com/wotlk/object=${data[i]}` : `https://tbc.wowhead.com/object=${data[i]}`;
            // url = `https://wotlkdb.com/?object=${data[i]}`;
            // url = `https://www.wowhead.com/wotlk/object=${data[i]}`;

            let url = sprintf(baseUrl, data[i])

            if (type === "fishing")
                url = `https://wotlk-twinhead.twinstar.cz/?object=${data[i]}`;

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

                            // console.log(data[i])

                            let d = node(t, data[i], test.window.g_mapperData);
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
            reject(err);
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

function getTypeData(type, data) {
    let promises = [];

    promises.push(new Promise((resolve) => {
        GetData(data.href, data.nodes[type], type, type === "fishing" ? "twinstar" : undefined).then(rows => {
            let nodes = [];
            for (const arr in rows) {
                for (let i = 0; i < rows[arr].length; i++) {
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

            resolve(nodes);
        });
    }));


    return Promise.all(promises);
}


function writeDBFile(name, data) {


    if (!fs.existsSync(path.resolve(__dirname, '..', '..', 'plugins', 'database', 'data')))
        fs.mkdirSync(path.resolve(__dirname, '..', '..', 'plugins', 'database', 'data'));

    fs.writeFileSync(path.resolve(__dirname, '..', '..', 'plugins', 'database', 'data', `${name}.lua`), data, {
        encoding: 'utf8',
        flag: 'w'
    });
}

_.forEach(expansions, function (data, key) {
    console.log(key);

    let p = (path.resolve(__dirname, '..', '..', 'plugins', 'database', 'data'));

    createDirectories(p)

    let name;
    let out = "";

    name = "mining";
    getTypeData(name, data).then((nodes) => {
        console.log(name, "done!")
        out += Objects2Lua({GatherLite_PluginsDatabaseMining: nodes.flat()});
        return out;
    }).then(() => {
        name = "herbalism";
        return getTypeData(name, data).then((nodes) => {
            console.log(name, "done!")
            out += Objects2Lua({GatherLite_PluginsDatabaseHerbalism: nodes.flat()});
            return out;
        });
    }).then(() => {
        name = "containers";
        return getTypeData(name, data).then((nodes) => {
            console.log(name, "done!")
            out += Objects2Lua({GatherLite_PluginsDatabaseContainers: nodes.flat()});
            return out;
        });
    }).then(() => {
        name = "fishing";
        return getTypeData(name, data).then((nodes) => {
            console.log(name, "done!")
            out += Objects2Lua({GatherLite_PluginsDatabaseFishing: nodes.flat()});
            return out;
        });
    }).then(() => {
        fs.writeFileSync(path.resolve(p, `${key}.lua`), out, {
            encoding: 'utf8',
            flag: 'w'
        });
    })
});