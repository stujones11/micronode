MICRONODE_MOD_NAME = minetest.get_current_modname()
dofile(minetest.get_modpath(MICRONODE_MOD_NAME) .. "/config.lua")
dofile(minetest.get_modpath(MICRONODE_MOD_NAME) .. "/micronode.lua")

minetest.register_entity("micronode:mesh", {
	micronode = nil,
	physical = true,
	visual = "cube",
	visual_size = MICRONODE_VISUAL_SIZE,
	collisionbox = MICRONODE_COLLISION_BOX,
	textures = micronode.default_tiles,
	on_activate = function(self, staticdata, dtime_s)
		if staticdata then
			if staticdata == "expired" then
				self.object:remove()
			end
			local t = micronode:get_texture(staticdata)
			if t then
				self.object:set_properties({textures={t,t,t,t,t,t}})
				self.micronode = staticdata
			end
		end
	end,
	on_rightclick = function(self, clicker)
		local item = clicker:get_wielded_item()
		local def = item:get_definition()
		if def.type == "node" and def.name:find("micronode:") == 1 then
			local n = micronode:get_object_normal(self.object, clicker)
			local p = self.object:getpos()
			if n and p then
				local offset = vector.multiply(n, MICRONODE_BLOCK)
				local pos = vector.add(p, offset)
				micronode:add_mesh(pos, def.name)
			end
		end
	end,
	on_punch = function(self, hitter)
		if self.micronode then
			local inv = hitter:get_inventory()
			if inv then
				inv:add_item("main", self.micronode)
			end
		end
		self.object:remove()
	end,
	get_staticdata = function(self)
		if self.micronode and MICRONODE_REMOVE_UNLOADED == false then
			return self.micronode
		end
		return "expired"
	end,
})

if MICRONODE_LASER_USES > 0 then
	local groups = {}
	if MICRONODE_LASER_IN_CREATIVE == false then
		groups.not_in_creative_inventory = 1
	end
	minetest.register_tool("micronode:laser", {
		description = "Laser Cutter",
		inventory_image = "micronode_laser.png",
		wield_image = "micronode_laser_wield.png",
		wield_scale = {x=1/16, y=8, z=1/4},
		groups = groups,
		on_use = function(itemstack, user, pointed_thing)
			local pos = minetest.get_pointed_thing_position(pointed_thing)
			local node = minetest.get_node(pos)
			if node.name then
				local name = node.name:gsub("^.+:", "micronode:")
				if minetest.registered_items[name] then
					local stack = {name=name, count=MICRONODE_STACK_MAX}
					local inv = user:get_inventory()
					if inv then
						inv:add_item("main", stack)
					end
					minetest.remove_node(pos)
				end
			end
			itemstack:add_wear(MICRONODE_LASER_WEAR)
			return itemstack
		end,
	})
end

if MICRONODE_LASER_REGISTER_CRAFT == true then
	minetest.register_craft({
		output = 'micronode:laser',
		recipe = {
			{'default:bronzeblock'},
			{'default:mese_crystal'},
			{'default:glass'},
		}
	})
end

if minetest.get_modpath("wool") then
	local colors = {
		"white", "grey", "black", "red",
		"yellow", "green", "cyan", "blue",
		"magenta", "orange", "violet", "brown",
		"pink", "dark_grey", "dark_green",
	}
	for _,color in ipairs(colors) do
		local desc = color:gsub("%a", string.upper, 1) .. " Micronode"
		micronode:register_node("micronode:" .. color, {
			description = desc,
			image = "wool_" .. color .. ".png",
		})
	end
end

local nodes = {"wood", "cobble", "obsidian", "glass"}
for _,node in ipairs(nodes) do
	local desc = node:gsub("%a", string.upper, 1) .. " Micronode"
	micronode:register_node("micronode:" .. node, {
		description = desc,
		image = "default_" .. node .. ".png",
	})
end

local blocks = {"coal", "steel", "copper", "bronze", "gold", "diamond"}
for _,block in ipairs(blocks) do
	local desc = block:gsub("%a", string.upper, 1) .. " Micronode"
	micronode:register_node("micronode:" .. block .. "block", {
		description = desc,
		image = "default_" .. block .. "_block.png",
	})
end

micronode:register_node("micronode:mese", {
	description = "Mese Micronode",
	image = "default_mese_block.png",
})

micronode:register_node("micronode:water_source", {
	description = "Water Micronode",
	image = "default_water.png",
})

