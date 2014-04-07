micronode = {
	axis = {
		{{x=1,y=0,z=0}, {x=-1,y=0,z=0}},
		{{x=0,y=1,z=0}, {x=0,y=-1,z=0}},
		{{x=0,y=0,z=1}, {x=0,y=0,z=-1}},
	},
	default_tiles = {
		"micronode_trans.png", "micronode_trans.png",
		"micronode_trans.png", "micronode_trans.png",
		"micronode_trans.png", "micronode_trans.png",
	}
}

function micronode:register_node(name, def)
	local groups = {}
	if MICRONODE_NODES_IN_CREATIVE == false then
		groups.not_in_creative_inventory = 1
	end
	local inventory_image = def.image .. "^micronode_grid.png"
	minetest.register_node(name, {
		description = def.description,
		inventory_image = minetest.inventorycube(inventory_image),
		wield_image = def.image,
		wield_scale = {x=1/3, y=1/3, z=3},
		stack_max = MICRONODE_STACK_MAX,
		drawtype = "glasslike",
		paramtype = "light",
		sunlight_propagates = true,
		tiles = micronode.default_tiles,
		groups = groups,
		selection_box = {
			type = "fixed",
			fixed = {0,0,0, 0,0,0},
		},
		after_place_node = function(pos, placer, itemstack, pointed_thing)
			minetest.remove_node(pos)
			if pointed_thing.type == "node" then
				local v = placer:get_look_dir()
				local p = placer:getpos()
				local n = micronode:get_node_normal(pointed_thing)
				if v and p and n then
					p.y = p.y + MICRONODE_CAMERA_OFFSET
					local offset = vector.multiply(n, {x=0.5, y=0.5, z=0.5})
					local plane = {
						pos = vector.subtract(pos, offset),
						normal = n,
					}
					local ray = {pos=p,  dir=v}
					local t = micronode:get_intersect_point(ray, plane)
					if t then
						local td = vector.multiply(v, {x=t, y=t, z=t})
						local pos_point = vector.add(p, td)
						offset = vector.multiply(n, MICRONODE_OFFSET_POS)
						pos_point = vector.add(pos_point, offset)
						pos_point = micronode:get_grid_pos(pos_point)
						micronode:add_mesh(pos_point, name)
					end
				end
			end
		end,
	})
end

function micronode:get_dot_product(v1, v2)
	return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
end

function micronode:get_grid_pos(pos)
	local n = MICRONODE_BLOCKS_PER_VERTEX
	pos = vector.subtract(pos, {x=0.5, y=0.5, z=0.5})
	pos = {
		x = math.floor(pos.x * n) / n + MICRONODE_OFFSET,
		y = math.floor(pos.y * n) / n + MICRONODE_OFFSET,
		z = math.floor(pos.z * n) / n + MICRONODE_OFFSET,
	}
	return vector.add(pos, {x=0.5, y=0.5, z=0.5})
end

function micronode:get_intersect_point(ray, plane)
	local v = vector.subtract(ray.pos, plane.pos)
	local r1 = micronode:get_dot_product(v, plane.normal)
	local r2 = micronode:get_dot_product(ray.dir, plane.normal)
	if r2 ~= 0 then
		return -(r1 / r2)
	end
end

function micronode:get_node_normal(pointed_thing)
	local pt = pointed_thing
	if pt.above.x > pt.under.x then
		return {x=1, y=0, z=0}
	elseif pt.above.x < pt.under.x then
		return {x=-1, y=0, z=0}
	elseif pt.above.y > pt.under.y then
		return {x=0, y=1, z=0}
	elseif pt.above.y < pt.under.y then
		return {x=0, y=-1, z=0}
	elseif pt.above.z > pt.under.z then
		return {x=0, y=0, z=1}
	elseif pt.above.z < pt.under.z then
		return {x=0, y=0, z=-1}
	end
end

function micronode:get_object_normal(object, player)
	local p1 = player:getpos()
	local p2 = object:getpos()
	local v = player:get_look_dir()
	if p1 and p2 and v then
		p1.y = p1.y + MICRONODE_CAMERA_OFFSET
		local face = {t=-1000}
		for _,axis in ipairs(micronode.axis) do
			local tnear = {dist=1000}
			for _,normal in ipairs(axis) do
				local offset = vector.multiply(normal, MICRONODE_OFFSET_POS)
				local plane = {
					pos = vector.add(p2, offset),
					normal = normal,
				}
				local ray = {pos=p1, dir=v}
				local dist = vector.distance(p1, plane.pos)
				local t = micronode:get_intersect_point(ray, plane)
				if t and dist < tnear.dist then
					tnear = {t=t, dist=dist, normal=normal}
				end
			end
			if tnear.t and tnear.normal then
				if tnear.t > face.t then
					face.t = tnear.t
					face.normal = tnear.normal
				end
			end
		end
		return face.normal
	end
end

function micronode:get_texture(name)
	local item = minetest.registered_items[name]
	if item then
		return item.wield_image
	end
end

function micronode:add_mesh(pos, name)
	local objects = minetest.get_objects_inside_radius(pos, 1)
	if objects then
		for _,object in ipairs(objects) do
			if object then
				local p = object:getpos()
				if p then
					if vector.equals(pos, p) == true then
						return
					end
				end
			end
		end
	end
	local object = minetest.add_entity(pos, "micronode:mesh")
	if object and name then
		local t = micronode:get_texture(name)
		if t then
			object:set_properties({textures={t,t,t,t,t,t}})
			local entity = object:get_luaentity()
			if entity then
				entity.micronode = name
			end
		end
	end
end

