HITMARKER = HITMARKER or {}

if (CLIENT) then
    // For custom sound, add them in the sound/phx folder and modify the actual path.
    // (you also need to define a new font in the CLIENT condition just below)
    HITMARKER.hitSound = "phx/hitmarker.wav"
    // Set the actual font for the damage info, see surface.CreateFont() below for more information.
    HITMARKER.font = "font-60"
    // Delay before marker disappears.
    HITMARKER.hitMarkerDisplayTime = 0.1
    // Delay before damage text info disappears.
    HITMARKER.damageDisplayTime = 0.5
    // Color for each damage level (0 > 50, 51 > 100, 101 > 150, 151 > 250, 251+).
    HITMARKER.damageColor = {
        Color(150, 150, 150, 255),
        Color(4, 177, 251, 255),
        Color(251, 255, 10, 255),
        Color(255, 125, 5, 255),
        Color(255, 5, 5, 255)
    }
    // Size of the hitmarker.
    HITMARKER.size = 20
    // Thickness of the hitmarker.
    HITMARKER.thickness = 5
    // Change this does nothing but keep it at 0, the table key is initalized to avoid non-existent key call.
    HITMARKER.damage = 0
    // Dont change this, this key is initialized to avoid unnecessary calculations.
    HITMARKER.center = Vector( ScrW() / 2, ScrH() / 2, 0 )

    // if you want to add your own font, you can use the following as a template. To add font put the .ttf file in the resource/fonts folder.
    // (Dont forget to add a resource.AddFile() in the sv_hitmarker.lua file)
    surface.CreateFont( "font-60", {
        font = "Ninja Note", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
        extended = false,
        size = 40,
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

// Add all neccessary files in the condition below.
if (SERVER) then
    resource.AddFile("resource/fonts/njnaruto.ttf")
    resource.AddFile("resource/fonts/ninjanote.ttf")
    resource.AddFile("sound/phx/hitmarker.wav")
    resource.AddFile("sound/phx/test.wav")
end