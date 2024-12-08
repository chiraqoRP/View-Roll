local ENTITY = FindMetaTable("Entity")
local PLAYER = FindMetaTable("Player")
local aGetViewEntity = GetViewEntity
local pInVehicle = PLAYER.InVehicle
local eGetVelocity = ENTITY.GetVelocity
local eGetMoveType = ENTITY.GetMoveType
local enabled = CreateClientConVar("cl_cview_viewroll_enabled", 0, true, false, "", 0, 1)
local intensity = CreateClientConVar("cl_cview_viewroll_intensity", 1.0, true, false, "", 0.1, 10)

hook.Add("CalcView", "CView", function(ply, origin, angles, fov, zNear, zFar)
    if !enabled:GetBool() or ply != aGetViewEntity() or pInVehicle(ply) then
        return
    end

    local moveType = eGetMoveType(ply)

    if moveType == MOVETYPE_NOCLIP then
        return
    end

    -- REFERENCE: https://github.com/ValveSoftware/source-sdk-2013/blob/master/mp/src/game/shared/baseplayer_shared.cpp#L1728
    local velocity = eGetVelocity(ply)
    local side = velocity:Dot(angles:Right())
    local sign = 1

    if side < 0 then
        sign = -1
    end

    side = math.Clamp(math.abs(side), 0, 1000) * intensity:GetFloat()

    angles.r = angles.r + (sign * side) * 0.005
end)