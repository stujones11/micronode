-- Begin User Defined Configs
MICRONODE_BLOCKS_PER_VERTEX = 5
MICRONODE_LASER_USES = 100
MICRONODE_LASER_REGISTER_CRAFT = true
MICRONODE_LASER_IN_CREATIVE = true
MICRONODE_NODES_IN_CREATIVE = true
MICRONODE_REMOVE_UNLOADED = false
MICRONODE_CAMERA_OFFSET = 1.61
-- End User Defined Configs

local modpath = minetest.get_modpath(MICRONODE_MOD_NAME)
local input = io.open(modpath.."/micronode.conf", "r")
if input then
	dofile(modpath.."/micronode.conf")
	input:close()
	input = nil
end

MICRONODE_BLOCKS_PER_VERTEX = math.floor(MICRONODE_BLOCKS_PER_VERTEX)
MICRONODE_LASER_WEAR = math.floor(65535 / MICRONODE_LASER_USES) + 1
MICRONODE_STACK_MAX = math.pow(MICRONODE_BLOCKS_PER_VERTEX, 3)
MICRONODE_SIZE = 1 / MICRONODE_BLOCKS_PER_VERTEX
MICRONODE_OFFSET = MICRONODE_SIZE / 2
MICRONODE_OFFSET_POS = {
	x = MICRONODE_OFFSET,
	y = MICRONODE_OFFSET,
	z = MICRONODE_OFFSET,
}
MICRONODE_BLOCK = {
	x = MICRONODE_SIZE,
	y = MICRONODE_SIZE,
	z = MICRONODE_SIZE,
}
MICRONODE_VISUAL_SIZE = {x=MICRONODE_SIZE, y=MICRONODE_SIZE}
MICRONODE_COLLISION_BOX = {
	-MICRONODE_OFFSET, -MICRONODE_OFFSET, -MICRONODE_OFFSET,
	MICRONODE_OFFSET, MICRONODE_OFFSET, MICRONODE_OFFSET,
}

