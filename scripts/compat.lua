local _, addon = ...

local API = {}
addon.API = API

function API.IsSecret(value)
    return issecretvalue and issecretvalue(value) or false
end

function API.GetSpellName(spell)
    if API.IsSecret(spell) or spell == nil then
        return nil
    end
    return C_Spell.GetSpellName(spell)
end

function API.GetProfessionLevel(name)
    if API.IsSecret(name) or type(name) ~= "string" then
        return 0
    end
    name = name:lower()

    if C_SkillInfo and C_SkillInfo.GetNumSkillLines and C_SkillInfo.GetSkillLineInfo then
        -- Lookup by ID also works when the profession header is collapsed.
        if C_SkillInfo.GetSkillLineInfoByID then
            for _, id in ipairs({ 182, 186 }) do -- Herbalism, Mining
                local info = C_SkillInfo.GetSkillLineInfoByID(id)
                if info and info.name:lower() == name then
                    return (info.rank or 0) + (info.modifier or 0)
                end
            end
        end
        for i = 1, C_SkillInfo.GetNumSkillLines() do
            local info = C_SkillInfo.GetSkillLineInfo(i)
            if info and not info.isHeader and info.name:lower() == name then
                return (info.rank or 0) + (info.modifier or 0)
            end
        end
    end
    return 0
end
