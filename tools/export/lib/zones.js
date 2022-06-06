const zoneData = require("./zoneData");

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
    "Arathi Basin": [1461, 947],

    //TBC
    "Eversong Woods": [1941],
    "Ghostlands": [1942],
    "Azuremyst Isle": [1943],
    "Hellfire Peninsula": [1944],
    "Outland": [1945],
    "Zangarmarsh": [1946],
    "The Exodar": [1947],
    "Shadowmoon Valley": [1948],
    "Blade\'s Edge Mountains": [1949],
    "Bloodmyst Isle": [1950],
    "Nagrand": [1951],
    "Terokkar Forest": [1952],
    "Netherstorm": [1953],
    "Silvermoon City": [1954],
    "Shattrath City": [1955],
    "Isle of Quel\'Danas": [1957]
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
    7307: 'Upper Blackrock Spire',

    //TBC
    3430: 'Eversong Woods',
    3433: 'Ghostlands',
    3524: 'Azuremyst Isle',
    3483: 'Hellfire Peninsula',
    3521: 'Zangarmarsh',
    3557: 'The Exodar',
    3520: 'Shadowmoon Valley',
    3522: 'Blade\'s Edge Mountains',
    3525: 'Bloodmyst Isle',
    3518: 'Nagrand',
    3519: 'Terokkar Forest',
    3523: 'Netherstorm',
    3487: 'Silvermoon City',
    3703: 'Shattrath City',
    4080: 'Isle of Quel\'Danas',
};

function MapID2Instance(mapID) {

    for (let i = 0; i < zoneData.zones.length; i++) {
        if (parseInt(zoneData.zones[i].id) === parseInt(mapID)) {
            return "" + zoneData.zones[i].category + "";
        }
    }

    return "nil";
}

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

module.exports = {
    idChanges,
    ZoneData,
    ZoneDataClassic,
    ConvertMapID2UIMapID,
    CheckIDS,
    MapID2Instance
}