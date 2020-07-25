const axios = require("axios");
const Three = require("three");
const fs = require("fs");
const path = require("path");
const jsdom = require("jsdom");
const {VirtualConsole} = require("jsdom");
const {JSDOM} = jsdom;

const idChanges = {
    3724: 1618,
    3725: 1617,
    3726: 1619,
    3727: 1620,
    3729: 1621,
    3730: 1622,

    176642: 142141,
    176639: 176584,
    176640: 176586,
    181109: 1734,
    176638: 176583,
    176637: 142145,
    176645: 2040,
    176641: 176587,
    176643: 324,
    176636: 142142,
    181108: 2047
};

const ObjectIDS = {
    ores: [
        324,
        176643,
        1610,
        1731,
        1732,
        1733,
        1734,
        181109,
        1735,
        2040,
        176645,
        2047,
        181108,
        2653,
        19903,
        73940,
        73941,
        123309,
        123310,
        123848,
        165658,
        175404,
        177388
    ],
    herbs: [
        1617,
        1618,
        1619,
        1620,
        1621,
        1622,
        1623,
        1624,
        1628,
        2041,
        2042,
        2043,
        2044,
        2045,
        2046,
        2866,
        3724,
        3725,
        3726,
        3727,
        3729,
        3730,
        176639,
        142140,
        142141,
        142142,
        176636,
        142143,
        142144,
        142145,
        176637,
        176640,
        176583,
        176584,
        176586,
        176587,
        176641,
        176588,
        176589,
        181166,
        181270,
        181271,
        181275,
        181276,
        181277,
        181278,
        181279,
        181280,
        181281,
        185881,
        189973,
        190169,
        190170,
        190171,
        190172,
        190175,
        190176,
        191019,
        191303,
        202747,
        202748,
        202749,
        202750,
        202751,
        202752,
        176642
    ],
    containers: [
        106319,
        2843,
        106318,
        2849,

        75293,

        2744,
        19018,
        19017,
        177784,

        2850,
        153453,
        153454,
        2855,
        153451,
        2852,
        2857,
        4149,

        74448,
        153464,
        75300,
        153463,
        75299,
        75298,
        153462,
        153461,
        157936
    ],
    fishing: [
        // Firefin
        180902,
        180683,
        180657,
        180752,

        // Blackmouth
        180750,
        180900,
        180682,
        180664,
        180582,

        // Sagefish
        180656,
        180663,

        // Debris
        180655,

        // Wreckage
        180685,
        180662,
        180901,
        180751,
    ]
};

const ZoneData = {
    "Azeroth": [947, 0],
    "Durotar": [1411, 1414],
    "Mulgore": [1412, 1414],
    "The Barrens": [1413, 1414],
    "Kalimdor": [1414, 947],
    "Eastern Kingdoms": [1415, 947],
    "Alterac Mountains": [1416, 1415],
    "Arathi Highlands": [1417, 1415],
    "Badlands": [1418, 1415],
    "Blasted Lands": [1419, 1415],
    "Tirisfal Glades": [1420, 1415],
    "Silverpine Forest": [1421, 1415],
    "Western Plaguelands": [1422, 1415],
    "Eastern Plaguelands": [1423, 1415],
    "Hillsbrad Foothills": [1424, 1415],
    "The Hinterlands": [1425, 1415],
    "Dun Morogh": [1426, 1415],
    "Searing Gorge": [1427, 1415],
    "Burning Steppes": [1428, 1415],
    "Elwynn Forest": [1429, 1415],
    "Deadwind Pass": [1430, 1415],
    "Duskwood": [1431, 1415],
    "Loch Modan": [1432, 1415],
    "Redridge Mountains": [1433, 1415],
    "Stranglethorn Vale": [1434, 1415],
    "Swamp of Sorrows": [1435, 1415],
    "Westfall": [1436, 1415],
    "Wetlands": [1437, 1415],
    "Teldrassil": [1438, 1414],
    "Darkshore": [1439, 1414],
    "Ashenvale": [1440, 1414],
    "Thousand Needles": [1441, 1414],
    "Stonetalon Mountains": [1442, 1414],
    "Desolace": [1443, 1414],
    "Feralas": [1444, 1414],
    "Dustwallow Marsh": [1445, 1414],
    "Tanaris": [1446, 1414],
    "Azshara": [1447, 1414],
    "Felwood": [1448, 1414],
    "Un'Goro Crater": [1449, 1414],
    "Moonglade": [1450, 1414],
    "Silithus": [1451, 1414],
    "Winterspring": [1452, 1414],
    "Stormwind City": [1453, 1415],
    "Orgrimmar": [1454, 1414],
    "Ironforge": [1455, 1415],
    "Thunder Bluff": [1456, 1414],
    "Darnassus": [1457, 1414],
    "Undercity": [1458, 1415],
    "Alterac Valley": [1459, 947],
    "Warsong Gulch": [1460, 947],
    "Arathi Basin": [1461, 947]
};

const ZoneDataClassic = {
    1: 'Dun Morogh',
    3: 'Badlands',
    4: 'Blasted Lands',
    8: 'Swamp of Sorrows',
    10: 'Duskwood',
    11: 'Wetlands',
    12: 'Elwynn Forest',
    14: 'Durotar',
    15: 'Dustwallow Marsh',
    16: 'Azshara',
    17: 'The Barrens',
    28: 'Western Plaguelands',
    33: 'Stranglethorn Vale',
    36: 'Alterac Mountains',
    38: 'Loch Modan',
    40: 'Westfall',
    41: 'Deadwind Pass',
    44: 'Redridge Mountains',
    45: 'Arathi Highlands',
    46: 'Burning Steppes',
    47: 'The Hinterlands',
    51: 'Searing Gorge',
    85: 'Tirisfal Glades',
    130: 'Silverpine Forest',
    139: 'Eastern Plaguelands',
    141: 'Teldrassil',
    148: 'Darkshore',
    209: 'Shadowfang Keep',
    215: 'Mulgore',
    267: 'Hillsbrad Foothills',
    331: 'Ashenvale',
    357: 'Feralas',
    361: 'Felwood',
    400: 'Thousand Needles',
    405: 'Desolace',
    406: 'Stonetalon Mountains',
    440: 'Tanaris',
    490: 'Un\'Goro Crater',
    491: 'Razorfen Kraul',
    493: 'Moonglade',
    618: 'Winterspring',
    717: 'The Stockade',
    718: 'Wailing Caverns',
    719: 'Blackfathom Deeps',
    721: 'Gnomeregan',
    722: 'Razorfen Downs',
    796: 'Scarlet Monastery',
    1176: 'Zul\'Farrak',
    1337: 'Uldaman',
    1377: 'Silithus',
    1417: 'The Temple of Atal\'Hakkar',
    1477: 'The Temple of Atal\'Hakkar',
    1497: 'Undercity',
    1519: 'Stormwind City',
    1537: 'Ironforge',
    1581: 'The Deadmines',
    1583: 'Lower Blackrock Spire',
    1584: 'Blackrock Depths',
    1585: 'Blackrock Depths',
    1637: 'Orgrimmar',
    1638: 'Thunder Bluff',
    1657: 'Darnassus',
    1977: 'Zul\'Gurub',
    2017: 'Stratholme',
    2057: 'Scholomance',
    2100: 'Maraudon',
    2159: 'Onyxia\'s Lair',
    2257: 'Deeprun Tram',
    2437: 'Ragefire Chasm',
    2557: 'Dire Maul',
    2597: 'Alterac Valley',
    2677: 'Blackwing Lair',
    2717: 'Molten Core',
    2917: 'Hall of Legends',
    2918: 'Champions\' Hall',
    3277: 'Warsong Gulch',
    3358: 'Arathi Basin',
    3428: 'Ahn\'Qiraj',
    3429: 'Ruins of Ahn\'Qiraj',
    3456: 'Naxxramas',
    7307: 'Upper Blackrock Spire'
};

function ConvertMapID2UIMapID(old) {
    if (!ZoneDataClassic[old])
        return null;

    let map = ZoneDataClassic[old];

    if (!ZoneData[map])
        return null;

    return ZoneData[map][0];
}

function CheckIDS(id) {
    if (idChanges[id])
        return idChanges[id];

    return id;
}

function node(type, object, incoming) {
    let data = [];
    for (let id in incoming) {
        for (let coord in incoming[id][0]["coords"]) {
            data.push({
                type: type,
                object: CheckIDS(object),
                mapID: ConvertMapID2UIMapID(id),
                posX: parseFloat((incoming[id][0]["coords"][coord][0] / 100).toFixed(3)),
                posY: parseFloat((incoming[id][0]["coords"][coord][1] / 100).toFixed(3)),
            });
        }
    }
    return data;
}

function GetData(type, site = "wowhead") {
    return new Promise(resolve => {
        let jobs = [];
        for (let i = 0; i < ObjectIDS[type].length; i++) {
            let url = `https://classic.wowhead.com/object=${ObjectIDS[type][i]}`;

            if (site === "twinstar") {
                url = `https://vanilla-twinhead.twinstar.cz/?object=${ObjectIDS[type][i]}`;
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

                            let d = node(t, ObjectIDS[type][i], test.window.g_mapperData);
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

function is_numeric(mixedVar) {
    let whitespace = [
        ' ',
        '\n',
        '\r',
        '\t',
        '\f',
        '\x0b',
        '\xa0',
        '\u2000',
        '\u2001',
        '\u2002',
        '\u2003',
        '\u2004',
        '\u2005',
        '\u2006',
        '\u2007',
        '\u2008',
        '\u2009',
        '\u200a',
        '\u200b',
        '\u2028',
        '\u2029',
        '\u3000'
    ].join('')

    // @todo: Break this up using many single conditions with early returns
    return (typeof mixedVar === 'number' ||
        (typeof mixedVar === 'string' &&
            whitespace.indexOf(mixedVar.slice(-1)) === -1)) &&
        mixedVar !== '' &&
        !isNaN(mixedVar)
}

function addcslashes(str, charlist) {
    var target = ''
    var chrs = []
    var i = 0
    var j = 0
    var c = ''
    var next = ''
    var rangeBegin = ''
    var rangeEnd = ''
    var chr = ''
    var begin = 0
    var end = 0
    var octalLength = 0
    var postOctalPos = 0
    var cca = 0
    var escHexGrp = []
    var encoded = ''
    var percentHex = /%([\dA-Fa-f]+)/g

    var _pad = function (n, c) {
        if ((n = n + '').length < c) {
            return new Array(++c - n.length).join('0') + n
        }
        return n
    }

    for (i = 0; i < charlist.length; i++) {
        c = charlist.charAt(i)
        next = charlist.charAt(i + 1)
        if (c === '\\' && next && (/\d/).test(next)) {
            // Octal
            rangeBegin = charlist.slice(i + 1).match(/^\d+/)[0]
            octalLength = rangeBegin.length
            postOctalPos = i + octalLength + 1
            if (charlist.charAt(postOctalPos) + charlist.charAt(postOctalPos + 1) === '..') {
                // Octal begins range
                begin = rangeBegin.charCodeAt(0)
                if ((/\\\d/).test(charlist.charAt(postOctalPos + 2) + charlist.charAt(postOctalPos + 3))) {
                    // Range ends with octal
                    rangeEnd = charlist.slice(postOctalPos + 3).match(/^\d+/)[0]
                    // Skip range end backslash
                    i += 1
                } else if (charlist.charAt(postOctalPos + 2)) {
                    // Range ends with character
                    rangeEnd = charlist.charAt(postOctalPos + 2)
                } else {
                    throw new Error('Range with no end point')
                }
                end = rangeEnd.charCodeAt(0)
                if (end > begin) {
                    // Treat as a range
                    for (j = begin; j <= end; j++) {
                        chrs.push(String.fromCharCode(j))
                    }
                } else {
                    // Supposed to treat period, begin and end as individual characters only, not a range
                    chrs.push('.', rangeBegin, rangeEnd)
                }
                // Skip dots and range end (already skipped range end backslash if present)
                i += rangeEnd.length + 2
            } else {
                // Octal is by itself
                chr = String.fromCharCode(parseInt(rangeBegin, 8))
                chrs.push(chr)
            }
            // Skip range begin
            i += octalLength
        } else if (next + charlist.charAt(i + 2) === '..') {
            // Character begins range
            rangeBegin = c
            begin = rangeBegin.charCodeAt(0)
            if ((/\\\d/).test(charlist.charAt(i + 3) + charlist.charAt(i + 4))) {
                // Range ends with octal
                rangeEnd = charlist.slice(i + 4).match(/^\d+/)[0]
                // Skip range end backslash
                i += 1
            } else if (charlist.charAt(i + 3)) {
                // Range ends with character
                rangeEnd = charlist.charAt(i + 3)
            } else {
                throw new Error('Range with no end point')
            }
            end = rangeEnd.charCodeAt(0)
            if (end > begin) {
                // Treat as a range
                for (j = begin; j <= end; j++) {
                    chrs.push(String.fromCharCode(j))
                }
            } else {
                // Supposed to treat period, begin and end as individual characters only, not a range
                chrs.push('.', rangeBegin, rangeEnd)
            }
            // Skip dots and range end (already skipped range end backslash if present)
            i += rangeEnd.length + 2
        } else {
            // Character is by itself
            chrs.push(c)
        }
    }

    for (i = 0; i < str.length; i++) {
        c = str.charAt(i)
        if (chrs.indexOf(c) !== -1) {
            target += '\\'
            cca = c.charCodeAt(0)
            if (cca < 32 || cca > 126) {
                // Needs special escaping
                switch (c) {
                    case '\n':
                        target += 'n'
                        break
                    case '\t':
                        target += 't'
                        break
                    case '\u000D':
                        target += 'r'
                        break
                    case '\u0007':
                        target += 'a'
                        break
                    case '\v':
                        target += 'v'
                        break
                    case '\b':
                        target += 'b'
                        break
                    case '\f':
                        target += 'f'
                        break
                    default:
                        // target += _pad(cca.toString(8), 3);break; // Sufficient for UTF-16
                        encoded = encodeURIComponent(c)

                        // 3-length-padded UTF-8 octets
                        if ((escHexGrp = percentHex.exec(encoded)) !== null) {
                            // already added a slash above:
                            target += _pad(parseInt(escHexGrp[1], 16).toString(8), 3)
                        }
                        while ((escHexGrp = percentHex.exec(encoded)) !== null) {
                            target += '\\' + _pad(parseInt(escHexGrp[1], 16).toString(8), 3)
                        }
                        break
                }
            } else {
                // Perform regular backslashed escaping
                target += c
            }
        } else {
            // Just add the character unescaped
            target += c
        }
    }

    return target
}

function Objects2Lua(data = [], indent = "", top = false) {
    if (indent === "") {
        top = true;
    }
    let out = "";

    for (const name in data) {
        out += indent;
        let value = data[name];

        if (!value)
            break;

        if (top) {
            out += name;
        } else if (is_numeric(name)) {
            out += '[' + name + ']';
        } else {
            out += '["' + name + '"]';
        }

        out += " = ";

        let type = typeof (value);

        if (is_numeric(value)) {
            type = "number;"
        }

        switch (type) {
            case "object":
                out += '{' + "\n";
                out += Objects2Lua(value, indent + "\t");
                out += indent + '}';
                break;

            case "bigint":
            case "number":
                out += value;
                break;

            case "string":
                out += '"' + addcslashes(value, "\n\"\\") + '"';
                break;

            case "boolean":
                out += value ? "True" : "False";
                break;

            default:
                out += value;
                break;

        }

        if (top) {
            out += "\n";
        } else {
            out += ",\n";
        }
    }
    return out;
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

let objects = [];
for (const type in ObjectIDS) {
    objects.push(new Promise(resolve => {
        console.log("Downloading", type)

        GetData(type, type === "fishing" ? "twinstar" : undefined).then(rows => {
            console.log(type, "data complete")
            let nodes = [];

            for (const arr in rows) {
                // nodes = nodes.concat(rows[arr]);

                for (let i = 0; i < rows[arr].length; i++) {
                    // console.log(rows[arr][i]);
                    let row = rows[arr][i];
                    if (row !== undefined) {
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
                case "ores":
                    out = Objects2Lua({GatherLite_localOreNodes: nodes});
                    break;

                case "herbs":
                    out = Objects2Lua({GatherLite_localHerbNodes: nodes});
                    break;

                case "fishing":
                    out = Objects2Lua({GatherLite_localFishingNodes: nodes});
                    break;
            }

            fs.writeFileSync(path.resolve(__dirname, 'data', type + ".lua"), out, {encoding: 'utf8', flag: 'w'});
            resolve();
        })
    }));
}

Promise.all(objects).then(() => {
    console.log("All data downloaded!")
})