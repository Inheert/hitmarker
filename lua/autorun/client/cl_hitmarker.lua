hook.Add("HUDShouldDraw", "HideDefaultCursor", function(name)
    if (name == "CHudCrosshair") then
        return (false)
    end
end)

net.Receive("ShareDamageToAttacker", function()
    if (not IsValid(LocalPlayer())) then return end

    local data = net.ReadTable()
    local distance = LocalPlayer():GetPos():Distance(data.targetPos)
    data.damage = math.Round(data.damage, 0)
    data.targetPos.z = data.targetPos.z + 70

    if (data.damage < 0) then return end

    local color = GetHitMarkerColor(data.damage)

    surface.PlaySound(HITMARKER.hitSound)
    HitMarkerDisplay(data.damage, color)

    if (distance < HITMARKER.damageMaxDistance) then
        DamageDisplay(data, color, distance)
    end
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

function DamageDisplay(data, color, distance)
    local randomId = RandomString(10)
    local hookName = "HITMARKERDamage" .. randomId
    local pos = data.targetPos
    local screenPos = pos:ToScreen()
    local xOffset = math.random(-80, 80)
    local yOffset = math.random(-50, 50)
    local font = HITMARKER.font .. GetFontSize(distance)

    color = Color(color.r, color.g, color.b, color.a)
    
    hook.Add("HUDPaint", hookName, function()
        local center = HITMARKER.center

        color.a = math.Clamp(color.a - HITMARKER.damageAlphaDecay, 0, 255)
        yOffset = yOffset - 1

        if screenPos.visible then
            local text = "Bonjour, monde!"

            local x = screenPos.x 
            local y = screenPos.y 
            
            draw.SimpleText(tostring(data.damage), font, x + xOffset, y + yOffset, color, 0, 0, fontSize)
        end

        if (color.a <= 0) then
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

function GetFontSize(distance)
    local i = 1
    splitDistance = HITMARKER.damageMaxDistance / HITMARKER.fontSizesCount
    while (i <= HITMARKER.fontSizesCount) do
        if (distance <= splitDistance) then
            return (HITMARKER.fontSizes[i])
        else
            splitDistance = splitDistance + HITMARKER.damageMaxDistance / HITMARKER.fontSizesCount
            i = i + 1
        end
    end
    return ("")
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

hook.Add("HUDPaint", "DrawMapText", function()
end)