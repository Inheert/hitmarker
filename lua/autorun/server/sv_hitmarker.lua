AddCSLuaFile("autorun/client/cl_hitmarker.lua")
include("autorun/sh_hitmarker.lua")

util.AddNetworkString("ShareDamageToAttacker")

// This hook is triggered when an npc/player take damage, it send information about the shot (damage, and target position) to the attacker
hook.Add("EntityTakeDamage", "SendDamageInfoToAttacker", function(target, dmgInfo)
    local attacker = dmgInfo:GetAttacker()
    local damage = dmgInfo:GetDamage()
    if (not IsValid(attacker) || type(damage) != "number" || not attacker:IsPlayer() || (not target:IsNPC() && not target:IsPlayer())) then return end

    data = {
        damage = damage,
        targetPos = target:GetPos()
    }
    net.Start("ShareDamageToAttacker")
    net.WriteTable(data)
    net.Send(attacker)
end)