AddCSLuaFile("autorun/client/cl_hitmarker.lua")
include("autorun/sh_hitmarker.lua")

util.AddNetworkString("ShareDamageToAttacker")

hook.Add("EntityTakeDamage", "SendDamageInfoToAttacker", function(target, dmgInfo)
    local attacker = dmgInfo:GetAttacker()
    local damage = dmgInfo:GetDamage()

    if (not IsValid(attacker) || type(damage) != "number" || not attacker:IsPlayer()) then return end

    net.Start("ShareDamageToAttacker")
    net.WriteString(tostring(damage))
    net.Send(attacker)
end)