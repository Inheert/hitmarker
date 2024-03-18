AddCSLuaFile("autorun/client/cl_hitmarker.lua")
include("autorun/sh_hitmarker.lua")

resource.AddFile("resource/fonts/njnaruto.ttf")
resource.AddFile("resource/fonts/ninjanote.ttf")
resource.AddFile("sound/phx/hitmarker.wav")
resource.AddFile("sound/phx/test.wav")

util.AddNetworkString("ShareDamageToAttacker")

hook.Add("EntityTakeDamage", "SendDamageInfoToAttacker", function(target, dmgInfo)
    local attacker = dmgInfo:GetAttacker()
    local damage = dmgInfo:GetDamage()

    if (not IsValid(attacker) || type(damage) != "number") then return end

    net.Start("ShareDamageToAttacker")
    net.WriteString(tostring(damage))
    net.Send(attacker)
end)