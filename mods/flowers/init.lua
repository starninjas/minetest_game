-- Minetest 0.4 mod: default
-- See README.txt for licensing and other information.

-- Map Generation
dofile(minetest.get_modpath("flowers").."/mapgen.lua")

-- Aliases for original flowers mod
minetest.register_alias("flowers:flower_dandelion_white", "flowers:dandelion_white")
minetest.register_alias("flowers:flower_dandelion_yellow", "flowers:dandelion_yellow")
minetest.register_alias("flowers:flower_geranium", "flowers:geranium")
minetest.register_alias("flowers:flower_rose", "flowers:rose")
minetest.register_alias("flowers:flower_tulip", "flowers:tulip")
minetest.register_alias("flowers:flower_viola", "flowers:viola")

-- Flower registration function
local function add_simple_flower(name, desc, image, f_groups)
	minetest.register_node("flowers:"..name.."", {
		description = desc,
		drawtype = "plantlike",
		tiles = { image..".png" },
		inventory_image = image..".png",
		wield_image = image..".png",
		sunlight_propagates = true,
		paramtype = "light",
		walkable = false,
		stack_max = 99,
		groups = f_groups,
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = { -0.15, -0.5, -0.15, 0.15, 0.2, 0.15 },
		},
	})
end

-- Registrations using the function above
add_simple_flower("dandelion_yellow", "Yellow Dandelion", "flowers_dandelion_yellow", {snappy=3,flammable=2,flower=1,flora=1,attached_node=1,dig_by_water=1,color_yellow=1})
add_simple_flower("geranium", "Blue Geranium", "flowers_geranium", {snappy=3,flammable=2,flower=1,flora=1,attached_node=1,dig_by_water=1,color_blue=1})
add_simple_flower("rose", "Rose", "flowers_rose", {snappy=3,flammable=2,flower=1,flora=1,attached_node=1,dig_by_water=1,color_red=1})
add_simple_flower("tulip", "Orange Tulip", "flowers_tulip", {snappy=3,flammable=2,flower=1,flora=1,attached_node=1,dig_by_water=1,color_orange=1})
add_simple_flower("dandelion_white", "White dandelion", "flowers_dandelion_white",{snappy=3,flammable=2,flower=1,flora=1,attached_node=1,color_white=1})
add_simple_flower("viola", "Viola", "flowers_viola", {snappy=3,flammable=2,flower=1,flora=1,attached_node=1,color_violet=1})


minetest.register_abm({
	nodenames = {"group:flora"},
	neighbors = {"default:dirt_with_grass", "default:desert_sand"},
	interval = 50,
	chance = 25,
	action = function(pos, node)
		pos.y = pos.y - 1
		local under = minetest.get_node(pos)
		pos.y = pos.y + 1
		if under.name == "default:desert_sand" then
			minetest.set_node(pos, {name="default:dry_shrub"})
		elseif under.name ~= "default:dirt_with_grass" then
			return
		end
		
		local light = minetest.get_node_light(pos)
		if not light or light < 13 then
			return
		end
		
		local pos0 = {x=pos.x-4,y=pos.y-4,z=pos.z-4}
		local pos1 = {x=pos.x+4,y=pos.y+4,z=pos.z+4}
		if #minetest.find_nodes_in_area(pos0, pos1, "group:flora_block") > 0 then
			return
		end
		
		local flowers = minetest.find_nodes_in_area(pos0, pos1, "group:flora")
		if #flowers > 3 then
			return
		end
		
		local seedling = minetest.find_nodes_in_area(pos0, pos1, "default:dirt_with_grass")
		if #seedling > 0 then
			seedling = seedling[math.random(#seedling)]
			seedling.y = seedling.y + 1
			light = minetest.get_node_light(seedling)
			if not light or light < 13 then
				return
			end
			if minetest.get_node(seedling).name == "air" then
				minetest.set_node(seedling, {name=node.name})
			end
		end
	end,
})
