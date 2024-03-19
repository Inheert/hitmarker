HITMARKER = HITMARKER or {}

if (CLIENT) then
    // Size of the hitmarker.
    HITMARKER.size = 20

    // Thickness of the hitmarker.
    HITMARKER.thickness = 5

    // Delay before marker disappears, this work on alpha color (when alpha == 0 the hook is removed).
    HITMARKER.hitMarkerAlphaDecay = 10

    // Delay before damage text info disappears, this work on alpha color (when alpha == 0 the hook is removed).
    HITMARKER.damageAlphaDecay = 5

    // Distance max to display damage
    HITMARKER.damageMaxDistance = 1500

    // Color for each damage level (0 > 50, 51 > 100, 101 > 150, 151 > 250, 251+).
    HITMARKER.damageColor = {
        Color(150, 150, 150, 255),
        Color(4, 177, 251, 255),
        Color(251, 255, 10, 255),
        Color(255, 125, 5, 255),
        Color(255, 5, 5, 255)
    }

    // For custom sound, add them in the sound/phx folder and modify the actual path.
    HITMARKER.hitSound = "phx/hitmarker.wav"

    // Set the actual font for the damage info, see HITMARKER.fonts below for more information.
    HITMARKER.font = "ninja"

    // To add a new font just add it in this table, you can adjust the key as you want but the value must be the same as the font name in the font viewer.
    // You also need to add the file in the SERVER condition at the end of this file.
    HITMARKER.fonts = {
        ninja = "Ninja Note"
    }

    // Used to define all font sizes, this key is scalable, for example if you have 3 values in it (20, 40, 60) so the damage display will work like this:
    // if distance is in 1/3 maxDistance then damage text size = 60
    // if distance is in 2/3 maxDistance then damage text size = 40
    // if distance is in 3/3 maxDistance then damage text size = 20
    // Fraction adapts to table size
    HITMARKER.fontSizes = {80, 60, 40, 20}

    // Just to avoid useless calculation
    HITMARKER.fontSizesCount = #HITMARKER.fontSizes

    // This is used to create all neccessary fonts
    for k, v in pairs(HITMARKER.fonts) do
        for _, j in ipairs(HITMARKER.fontSizes) do
            surface.CreateFont( k .. j, {
                font = v, --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
                extended = false,
                size = j,
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

    // Change this does nothing but keep it at 0, the table key is initalized to avoid non-existent key call.
    HITMARKER.damage = 0

    // Dont change this, this key is initialized to avoid unnecessary calculations.
    HITMARKER.center = Vector( ScrW() / 2, ScrH() / 2, 0 )
end

// Add all neccessary files in the condition below.
if (SERVER) then
    resource.AddFile("resource/fonts/njnaruto.ttf")
    resource.AddFile("resource/fonts/ninjanote.ttf")
    resource.AddFile("sound/phx/hitmarker.wav")
    resource.AddFile("sound/phx/test.wav")
end