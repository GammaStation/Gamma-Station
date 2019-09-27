/datum/random_map/noise/exoplanet
	descriptor = "exoplanet"
	smoothing_iterations = 1
	var/area/planetary_area = /area/surface

	var/water_level
	var/water_level_min = 0
	var/water_level_max = 5
	var/land_type = /turf/simulated/floor
	var/water_type

	//intended x*y size, used to adjust spawn probs
	var/intended_x = 150
	var/intended_y = 150
	var/large_flora_prob = 60
	var/flora_prob = 60
	var/fauna_prob = 2
	var/flora_diversity = 4

	var/list/fauna_types = list()
	var/list/small_flora_types = list()
	var/list/big_flora_types = list()
	var/list/plantcolors = list("RANDOM")

/datum/random_map/noise/exoplanet/New(var/seed, var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/never_be_priority = 0, var/_planetary_area)
	target_turf_type = world.turf
	water_level = rand(water_level_min,water_level_max)
//	generate_flora()
	planetary_area = _planetary_area
	//automagically adjust probs for bigger maps to help with lag
	var/size_mod = intended_x / tlx * intended_y / tly
	flora_prob *= size_mod
	large_flora_prob *= size_mod
	fauna_prob *= size_mod

	..()

//	GLOB.using_map.base_turf_by_z[num2text(tz)] = land_type

/datum/random_map/noise/exoplanet/proc/noise2value(var/value)
	return min(9,max(0,round((value/cell_range)*10)))

/datum/random_map/noise/exoplanet/proc/is_edge_turf(turf/T)
	return T.x <= TRANSITIONEDGE || T.x >= (limit_x - TRANSITIONEDGE + 1) || T.y <= TRANSITIONEDGE || T.y >= (limit_y - TRANSITIONEDGE + 1)

/datum/random_map/noise/exoplanet/get_map_char(var/value)
	if(water_type && noise2value(value) < water_level)
		return "~"
	return "[noise2value(value)]"

/datum/random_map/noise/exoplanet/get_appropriate_path(var/value)
	if(water_type && noise2value(value) < water_level)
		return water_type
	else
		return land_type