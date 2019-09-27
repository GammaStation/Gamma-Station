/datum/sector_theme
	var/name = "Nothing Special"

/datum/sector_theme/proc/before_map_generation(obj/effect/sector/S)

/datum/sector_theme/mountains
	name = "Mountains"

/datum/sector_theme/mountains/before_map_generation(obj/effect/sector/S)
	for(var/zlevel in S.map_z)
		new /datum/random_map/automata/cave_system/mountains(null,TRANSITIONEDGE,TRANSITIONEDGE,zlevel,E.maxx-TRANSITIONEDGE,E.maxy-TRANSITIONEDGE,0,1,1, E.planetary_area, pick(E.rock_colors))