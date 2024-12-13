local ENTITY = FindMetaTable("Entity")
local PLAYER = FindMetaTable("Player")
local aGetViewEntity = GetViewEntity
local pInVehicle = PLAYER.InVehicle
local eGetAbsVelocity = ENTITY.GetAbsVelocity
local eGetMoveType = ENTITY.GetMoveType
local pGetWalkSpeed = PLAYER.GetWalkSpeed
local enabled = CreateClientConVar("cl_roll", 1, true, false, "Enables/disables view roll.", 0, 1)
local rAngle = CreateClientConVar("cl_rollangle", 0.5, true, false, "Controls view roll intensity.")

hook.Add("CalcView", "ViewRoll", function(ply, origin, angles, fov, zNear, zFar)
    if !enabled:GetBool() or ply != aGetViewEntity() or pInVehicle(ply) then
        return
    end

    local moveType = eGetMoveType(ply)

    if moveType == MOVETYPE_NOCLIP then
        return
    end

    -- REFERENCE: https://github.com/ValveSoftware/source-sdk-2013/blob/master/mp/src/game/shared/baseplayer_shared.cpp#L1728
    local velocity = eGetAbsVelocity(ply)
    local side = velocity:Dot(angles:Right())
    local sign = 1

    if side < 0 then
        sign = -1
    end

    side = math.abs(side)

    local value = rAngle:GetFloat()
    local rollSpeed = pGetWalkSpeed(ply)

    -- Hit 100% of rollangle at rollspeed. Below that get linear approx.
    if side < rollSpeed then
        side = side * value / rollSpeed
    else
        side = value
    end

    -- Scale by right/left sign
    angles.r = angles.r + side * sign
end)