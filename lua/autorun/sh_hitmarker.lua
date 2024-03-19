HITMARKER = HITMARKER or {}

if (CLIENT) then
    // Set the min/max for font size.
    HITMARKER.fontSizeRange = {20, 100}

    // Config damage texts by range of damage
    HITMARKER.damageConfigs = {
        {range = {0, 50}, fontSize = 20, color = Color(150, 150, 150, 255)},
        {range = {51, 100}, fontSize = 30, color = Color(4, 177, 251, 255)},
        {range = {101, 150}, fontSize = 50, color = Color(251, 255, 10, 255)},
        {range = {151, 250}, fontSize = 70, color = Color(255, 125, 5, 255)},
        {range = {251}, fontSize = 100, color = Color(255, 5, 5, 255)}
    }

    // Distance max to display damage.
    HITMARKER.maxRangeDisplay = 1500

    // For custom sound, add them in the sound/phx folder and modify the actual path.
    // Don't forget to add the file on the SERVER part at the end of this file.
    HITMARKER.hitSound = "phx/hitmarker.wav"

    // Set the actual font for the damage info, see HITMARKER.fonts below for more information.
    HITMARKER.font = "badaboom"

    // To add a new font just add it in this table, you can adjust the key as you want but the value must be the same as the font name in the font viewer.
    // You also need to add the file in the SERVER condition at the end of this file.
    HITMARKER.fonts = {
        ninja = "Ninja Note",
        badaboom = "BadaBoom BB"
    }

    // Delay before damage text info disappears, this work on alpha color (when alpha == 0 the hook is removed).
    HITMARKER.decay = 2

    // Range of damage positions on x and y axis.
    HITMARKER.damageOffset = {
        x = {-80, 80},
        y = {-50, 50}
    }

    // Check if the fontSize key in HITMARKER.damageConfigs within HITMARKER.fontSizeRange
    for k,v in ipairs(HITMARKER.damageConfigs) do
        HITMARKER.damageConfigs[k]["fontSize"] = math.Clamp(HITMARKER.damageConfigs[k]["fontSize"], HITMARKER.fontSizeRange[1], HITMARKER.fontSizeRange[2])
    end

    // Define all necessary fonts in the given range (HITMARKER.fontSizeRange)
    for i = HITMARKER.fontSizeRange[1], HITMARKER.fontSizeRange[2], 1 do
        surface.CreateFont( HITMARKER.font .. i, {
            font = HITMARKER.fonts[HITMARKER.font], --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
            extended = false,
            size = i,
            weight = 500,
            blursize = 0,
            scanlines = 0,
            antialias = true,
            underline = false,
            italic = false,
            strikeout = false,
            symbol = false,
            rotary = false,
            shadow = false,
            additive = false,
            outline = false,
        })
    end

    surface.CreateFont( HITMARKER.font .. "NOTFOUND", {
        font = HITMARKER.fonts[HITMARKER.font], --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
        extended = false,
        size = 0,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    })

    HITMARKER.confElementCount = #HITMARKER.damageConfigs

    // Change this does nothing but keep it at 0, the table key is initalized to avoid non-existent key call.
    HITMARKER.damage = 0

    // Dont change this, this key is initialized to avoid unnecessary calculations.
    HITMARKER.center = Vector( ScrW() / 2, ScrH() / 2, 0 )
end

// Add all neccessary files in the condition below.
if (SERVER) then
    resource.AddFile("resource/fonts/njnaruto.ttf")
    resource.AddFile("resource/fonts/ninjanote.ttf")
    resource.AddFile("resource/fonts/badabb.ttf")
    resource.AddFile("sound/phx/hitmarker.wav")
    resource.AddFile("sound/phx/test.wav")
end