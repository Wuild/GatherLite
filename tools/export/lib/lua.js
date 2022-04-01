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

module.exports = {
    is_numeric,
    addcslashes,
    Objects2Lua,
}