// Receive server message
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

// This function is responsible for displaying damage numbers on the screen with dynamic positioning and fading effects based on distance. 
// It calculates the position of the damage display relative to the target position and adjusts the font size according to the distance. 
// Finally, it gradually reduces the alpha value of the color to simulate fading out over time.
local function DamageDisplay(data, damageSettings)
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
    local underColor = Color(damageSettings.secondLayerColor.r, damageSettings.secondLayerColor.g, damageSettings.secondLayerColor.b, damageSettings.secondLayerColor.a)
    
    local fontSize = GetFontSizeFromDistance(damageSettings.fontSize, data.distance)

    local damageFont = HITMARKER.font .. fontSize
    local fontOverlay = HITMARKER.font .. "under" .. fontSize

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

    hook.Add("HUDPaint", hookName, function()
        local pos = data.targetPos
        local screenPos = pos:ToScreen()

        if (!screenPos.visible) then return end

        local x = screenPos.x 
        local y = screenPos.y

        x = x + xOffset * (1 - data.distance / HITMARKER.maxRangeDisplay)
        y = y + yOffset * (1 - data.distance / HITMARKER.maxRangeDisplay)

        yOffset = yOffset - 0.5
        xOffset = xOffset  + 0.5
    
        local newAlpha = math.Clamp(color.a - HITMARKER.decay, 0, 255)
        color.a = newAlpha
        underColor.a = newAlpha

        if (HITMARKER.fonts[HITMARKER.font .. "under"] != nil) then
            draw.SimpleText(tostring(data.damage), fontOverlay, x, y, underColor, 1, 1)  
        end

        draw.SimpleText(tostring(data.damage), damageFont, x, y, color, 1, 1)

        if (color.a <= 0) then
            hook.Remove("HUDPaint", hookName)
        end
    end)
end

// This function, GetDamageSettings, retrieves the appropriate damage settings based on the provided damage value
local function GetDamageSettings(damage)
    for k, v in ipairs(HITMARKER.damageConfigs) do
        if (k == HITMARKER.confElementCount) then
            return (v)
        end
        if (damage >= v["range"][1] && damage <= v["range"][2]) then
            return (v)
        end
    end
end

// Used to generate a random id for each DrawHUD damage hook
local function RandomString(length)
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

// This function calculates the font size based on the given size and the distance from the target
local function GetFontSizeFromDistance(size, distance)
    return (math.Round(math.Clamp(size * (1 - distance / HITMARKER.maxRangeDisplay), HITMARKER.fontSizeRange[1], HITMARKER.fontSizeRange[2]), 0))
end