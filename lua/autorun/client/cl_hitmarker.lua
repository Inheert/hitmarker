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
    hook.Add("HUDPaint", hookName, function()
        local center = HITMARKER.center
        local size = HITMARKER.size
    
        surface.SetDrawColor(color)
        surface.DrawLine(center.x + size, center.y + size, center.x - size, center.y - size)
        surface.DrawLine(center.x + size, center.y - size, center.x - size, center.y + size)
    end)

    timer.Simple(HITMARKER.hitMarkerDisplayTime, function()
        hook.Remove("HUDPaint", hookName)
    end)
end

function DamageDisplay(damage, color)
    local randomId = RandomString(10)
    local hookName = "HITMARKERDamage" .. randomId
    hook.Add("HUDPaint", hookName, function()
        local center = HITMARKER.center
        draw.SimpleText(tostring(damage), HITMARKER.font, center.x + 50, center.y, color, 0, 0)
    end)

    timer.Simple(HITMARKER.damageDisplayTime, function()
        hook.Remove("HUDPaint", hookName)
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
    return table.concat(ret)
end
