local MAJOR, MINOR = "Semver", 9
assert(LibStub, MAJOR .. " requires LibStub")

local Semver = LibStub:NewLibrary(MAJOR, MINOR)

local table_insert = table.insert
local table_concat = table.concat
local math_max = math.max

-- Utility split function
local function split(str, pat)
    local t = {}
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)

    while s do
        if s ~= 1 or cap ~= "" then
            table_insert(t, cap)
        end

        last_end = e + 1
        s, e, cap = str:find(fpat, last_end)
    end

    if last_end <= #str then
        cap = str:sub(last_end)
        table_insert(t, cap)
    end

    return t
end

local mt_version, _set

_set = function(v1, v2, strict)
    return setmetatable({
        ok = {},
        nok = {},
        strict = strict,
    }, mt_set):allowed(v1, v2)
end

mt_version = {
    __index = {
        semver = function(self, v)
            if self[1] == 0 then
                self.semver = function(self2, v2)
                    if getmetatable(v2) ~= mt_version then
                        local parsed, err = Semver.parse(v2, self2.strict)
                        if not parsed then return nil, err end
                        v2 = parsed
                    end
                    return self2 == v2
                end
            elseif self[4] then
                self.semver = function()
                    return nil, "Version has too many elements (semver max 3)"
                end
            else
                local semver_set = _set(self, self[1] + 1, self.strict):disallowed(self[1] + 1)
                self.semver = function(_, v2)
                    return semver_set:matches(v2)
                end
            end
            return self:semver(v)
        end
    },
    __eq = function(a, b)
        local l = math_max(#a, #b)
        for i = 1, l do
            if (a[i] or 0) ~= (b[i] or 0) then
                return false
            end
        end
        return true
    end,
    __lt = function(a, b)
        if getmetatable(a) ~= mt_version or getmetatable(b) ~= mt_version then
            local t = getmetatable(a) ~= mt_version and type(a) or type(b)
            error("cannot compare a 'version' to a '" .. t .. "'", 2)
        end
        local l = math_max(#a, #b)
        for i = 1, l do
            if (a[i] or 0) < (b[i] or 0) then
                return true
            end
            if (a[i] or 0) > (b[i] or 0) then
                return false
            end
        end
        return false
    end,
    __tostring = function(self)
        return table_concat(self, ".")
    end,
}

Semver.parse = function(v, strict)
    v = tostring(v)
    if strict then
        -- edge case: do not allow trailing dot
        if v:sub(-1, -1) == "." then
            return nil, "Not a valid version element: '" .. tostring(v) .. "'"
        end
    else
        local m = v:match("(%d[%d%.]*)")
        if not m then
            return nil, "Not a valid version element: '" .. tostring(v) .. "'"
        end
        v = m
    end
    local t = split(v, "%.")
    for i, s in ipairs(t) do
        local n = tonumber(s)
        if not n then
            return nil, "Not a valid version element: '" .. tostring(v) .. "'"
        end
        t[i] = n
    end
    t.strict = strict
    return setmetatable(t, mt_version)
end