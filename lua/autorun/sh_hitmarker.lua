HITMARKER = HITMARKER or {}

if (CLIENT) then
    // Set the min/max for font size.
    HITMARKER.fontSizeRange = {40, 100}

    // Config damage texts by range of damage.
    // The range determine the range of damage to apply font size, color, etc...
    // Color attribute is used to set the text color.
    // secondLayerColor is set for multiple font layer (used as an outline font)
    HITMARKER.damageConfigs = {
        {range = {0, 50}, fontSize = 40, color = Color(150, 150, 150, 255), secondLayerColor = Color(0, 0, 0, 255)},
        {range = {51, 100}, fontSize = 50, color = Color(4, 177, 251, 255), secondLayerColor = Color(0, 0, 0, 255)},
        {range = {101, 150}, fontSize = 60, color = Color(251, 255, 10, 255), secondLayerColor = Color(0, 0, 0, 255)},
        {range = {151, 250}, fontSize = 80, color = Color(255, 125, 5, 255), secondLayerColor = Color(0, 0, 0, 255)},
        {range = {251}, fontSize = 100, color = Color(255, 5, 5, 255), secondLayerColor = Color(0, 0, 0, 255)}
    }

    // Distance max to display damage.
    HITMARKER.maxRangeDisplay = 1500

    // For custom sound, add them in the sound/phx folder and modify the actual path.
    // Don't forget to add the file on the SERVER part at the end of this file.
    HITMARKER.hitSound = "phx/hitmarker.wav"

    // Set the actual font for the damage info, see HITMARKER.fonts below for more information.
    HITMARKER.font = "kablam"

    // To add a new font just add it in this table, you can adjust the key as you want but the value must be the same as the font name in the font viewer.
    // You also need to add the file in the SERVER condition at the end of this file.
    // If you need to add a font with 2 layers then define the second layer like this : fontnameunder.
    // For example: if my font name is kablam then the second layer have to be call kablaunder.
    HITMARKER.fonts = {
        ninja = "Ninja Note",
        badaboom = "BadaBoom BB",
        komica = "Komyca 3D free version",
        komigo = "Komigo 3D",
        kablam = "Ka Blam",
        kablamunder = "Ka Blam Under"
    }

    // Delay before damage text info disappears, this work on alpha color (when alpha == 0 the hook is removed).
    HITMARKER.decay = 1

    // Range of damage positions on x and y axis.
    HITMARKER.damageOffset = {
        x = {100, 200},
        y = {-150, -250}
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
        if (HITMARKER.fonts[HITMARKER.font .. "under"] != nil) then
            surface.CreateFont( HITMARKER.font .. "under" .. i, {
                font = HITMARKER.fonts[HITMARKER.font .. "under"],
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
    end

    surface.CreateFont( HITMARKER.font .. "NOTFOUND", {
        font = HITMARKER.fonts[HITMARKER.font],
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

    // Change this does nothing but keep it at 0, the table key is initalized to avoid non-existent key call.
    HITMARKER.damage = 0

    // Dont change this, this key is initialized to avoid unnecessary calculations.
    HITMARKER.center = Vector( ScrW() / 2, ScrH() / 2, 0 )
    HITMARKER.confElementCount = #HITMARKER.damageConfigs
end

// Add all neccessary files in the condition below.
if (SERVER) then
    resource.AddFile("resource/fonts/njnaruto.ttf")
    resource.AddFile("resource/fonts/komyca.ttf")
    resource.AddFile("resource/fonts/komigo.ttf")
    resource.AddFile("resource/fonts/ninjanote.ttf")
    resource.AddFile("resource/fonts/badabb.ttf")
    resource.AddFile("resource/fonts/kablam.ttf")
    resource.AddFile("resource/fonts/kablamunder.ttf")
    resource.AddFile("sound/phx/hitmarker.wav")
    resource.AddFile("sound/phx/test.wav")
end