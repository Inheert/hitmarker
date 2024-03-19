hook.Add("HUDShouldDraw", "HideDefaultCursor", function(name)
    if (name == "CHudCrosshair") then
        return (false)
    end
end)

net.Receive("ShareDamageToAttacker", function()
    local damage = net.ReadString()
    damage = math.Round(tonumber(damage), 0)

    if (not IsValid(LocalPlayer()) || damage < 0) then return end

    local color = GetHitMarkerColor(damage)
    surface.PlaySound(HITMARKER.hitSound)
    HitMarkerDisplay(damage, color)
    DamageDisplay(damage, color)
end)

function HitMarkerDisplay(damage, color)
    local randomId = RandomString(10)
    local hookName = "HITMARKERHit" .. randomId
    color = Color(color.r, color.g, color.b, color.a)

    hook.Add("HUDPaint", hookName, function()
        local rotation = 45

        color.a = math.Clamp(color.a - HITMARKER.hitMarkerAlphaDecay, 0, 255)
        surface.SetDrawColor(color)
        surface.DrawTexturedRectRotated(HITMARKER.center.x, HITMARKER.center.y, HITMARKER.size, HITMARKER.thickness, rotation)
        surface.DrawTexturedRectRotated(HITMARKER.center.x, HITMARKER.center.y, HITMARKER.size, HITMARKER.thickness, -rotation)
    end)

    if (color.a == 0) then
        hook.Remove("HUDPaint", hookName)
    end
end

function DamageDisplay(damage, color)
    local randomId = RandomString(10)
    local hookName = "HITMARKERDamage" .. randomId
    local xOffset = math.random(-80, 80)
    local yOffset = math.random(-50, 50)
    color = Color(color.r, color.g, color.b, color.a)

    hook.Add("HUDPaint", hookName, function()
        local center = HITMARKER.center

        color.a = math.Clamp(color.a - HITMARKER.damageAlphaDecay, 0, 255)

        draw.SimpleText(tostring(damage), HITMARKER.font, center.x + xOffset, center.y + yOffset, color, 0, 0)

        if (color.a == 0) then
            hook.Remove("HUDPaint", hookName)
        end
    end)
end

function GetHitMarkerColor(damage)
    if (type(damage) != "number") then return end

    if (damage >= 0 && damage <= 50) then
        return (HITMARKER.damageColor[1])
    elseif (damage >= 51 && damage <= 100) then
        return (HITMARKER.damageColor[2])
    elseif (damage >= 101 && damage <= 150) then
        return (HITMARKER.damageColor[3])
    elseif (damage >= 151 && damage <= 250) then
        return (HITMARKER.damageColor[4])
    elseif (damage >= 251) then
        return (HITMARKER.damageColor[5])
    end
    return (Color(0, 0, 0, 255))
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
