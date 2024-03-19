hook.Add("HUDShouldDraw", "HideDefaultCursor", function(name)
    if (name == "CHudCrosshair") then
        return (true)
    end
end)

net.Receive("ShareDamageToAttacker", function()
    if (not IsValid(LocalPlayer())) then return end

    local data = net.ReadTable()
    data.damage = math.Round(data.damage, 0)
    data.targetPos.z = data.targetPos.z
    data.distance = LocalPlayer():GetPos():Distance(data.targetPos)
    if (data.damage < 0) then return end

    local damageSettings = GetDamageSettings(data.damage)

    surface.PlaySound(HITMARKER.hitSound)

    if (data.distance < HITMARKER.maxRangeDisplay) then
        DamageDisplay(data, damageSettings)
    end
end)

function DamageDisplay(data, damageSettings)
    local randomId = RandomString(10)
    local hookName = "HITMARKERDamage" .. randomId

    local xOffset = 0
    local yOffset = 0

    local xOffsetHitMarker = 0
    local yOffsetHitMarker = 0
    local xOffsetDamage = 0
    local yOffsetDamage = 0

    local rotation = 45

    local color = Color(damageSettings.color.r, damageSettings.color.g, damageSettings.color.b, damageSettings.color.a)

    if (HITMARKER.damageOffset["x"][1] != HITMARKER.damageOffset["x"][2]) then
        xOffset = math.random(HITMARKER.damageOffset["x"][1], HITMARKER.damageOffset["x"][2])
    else
        xOffset = HITMARKER.damageOffset["x"][1]
    end

    if (HITMARKER.damageOffset["y"][1] != HITMARKER.damageOffset["y"][2]) then
        yOffset = math.random(HITMARKER.damageOffset["y"][1], HITMARKER.damageOffset["y"][2])
    else
        yOffset = HITMARKER.damageOffset["y"][1]
    end

    local damageFont = HITMARKER.font .. GetFontSizeFromDistance(damageSettings.fontSize, data.distance)

    hook.Add("HUDPaint", hookName, function()
        local pos = data.targetPos
        local screenPos = pos:ToScreen()

        if (!screenPos.visible) then return end

        local x = screenPos.x 
        local y = screenPos.y

        x = x + xOffset * (1 - data.distance / HITMARKER.maxRangeDisplay)
        y = y + yOffset * (1 - data.distance / HITMARKER.maxRangeDisplay)

        yOffset = yOffset - 0.5

        color.a = math.Clamp(color.a - HITMARKER.decay, 0, 255)

        draw.SimpleText(tostring(data.damage), damageFont, x, y, color, 1, 1)

        if (color.a <= 0) then
            hook.Remove("HUDPaint", hookName)
        end
    end)
end

function GetDamageSettings(damage)
    for k, v in ipairs(HITMARKER.damageConfigs) do
        if (k == HITMARKER.confElementCount) then
            return (v)
        end
        if (damage >= v["range"][1] && damage <= v["range"][2]) then
            return (v)
        end
    end
end

function RandomString(length)
    local charset = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890"
    math.randomseed(os.clock())
    local ret = {}
    local r
    for i = 1, length do
        r = math.random(1, #charset)
        table.insert(ret, charset:sub(r, r))
    end
    return (table.concat(ret))
end

function GetFontSizeFromDistance(size, distance)
    return (math.Round(math.Clamp(size * (1 - distance / HITMARKER.maxRangeDisplay), HITMARKER.fontSizeRange[1], HITMARKER.fontSizeRange[2]), 0))
end