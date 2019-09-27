var/obj/effect/sector/ZLEVEL_OUTPOST_NORTH

/obj/effect/sector
	name = "sector"
	icon_state = "globe"
	var/maxx
	var/maxy

//	var/list/possible_themes = list(/datum/sector_theme/mountains,/datum/sector_theme)
//	var/list/themes = list()

/obj/effect/sector/New(nloc, max_x, max_y)

	maxx = max_x ? max_x : world.maxx
	maxy = max_y ? max_y : world.maxy
//	planetary_area = new planetary_area()

//	name = "[generate_planet_name()], \a [name]"

	world.maxz++
	forceMove(locate(1,1,world.maxz))

	..()

/obj/effect/sector/proc/build_level()
//	generate_habitability()
//	generate_atmosphere()
	generate_map()
//	generate_features()
//	generate_landing(2)
//	update_biome()
//	generate_daycycle()
//	START_PROCESSING(SSobj, src)

/obj/effect/sector/proc/generate_map()
//	for(var/datum/sector_theme/T in themes)
//		T.before_map_generation(src)
	var/list/edges
	edges += block(locate(1, 1, z), locate(1, maxy, z))
	edges |= block(locate(maxx-1, 1, z),locate(maxx, maxy, z))
	edges |= block(locate(1, 1, z), locate(maxx, 1, z))
	edges |= block(locate(1, maxy-1, z),locate(maxx, maxy, z))
	for(var/turf/T in edges)
		T.ChangeTurf(/turf/unsimulated/wall)
/*
	var/padding = TRANSITIONEDGE
	for(var/map_type in map_generators)
		if(ispath(map_type, /datum/random_map/noise/exoplanet))
			var/datum/random_map/noise/exoplanet/RM = new map_type(null,padding,padding,world.maxz,maxx-padding,maxy-padding,0,1,1,planetary_area)
			get_biostuff(RM)
		else
			new map_type(null,1,1,world.maxz,maxx,maxy,0,1,1)
*/

/proc/build_sectors()
	ZLEVEL_OUTPOST_NORTH = new /obj/effect/sector(locate(1,1,1))
//	world.maxz++
//	ZLEVEL_OUTPOST_NORTH = world.maxz
//	var/sector_type = pick(subtypesof(/obj/effect/sector))
//	var/obj/effect/sector/new_sector = new sector_type(null, PLANET_SIZE_X-100, PLANET_SIZE_Y-100)
	ZLEVEL_OUTPOST_NORTH.build_level()
/*
/proc/generate_map()
	if(!ZLEVEL_OUTPOST_NORTH)
		return
	var/list/edges
	edges += block(locate(1, 1, ZLEVEL_OUTPOST_NORTH), locate(TRANSITIONEDGE, maxy, ZLEVEL_OUTPOST_NORTH))
	edges |= block(locate(maxx-TRANSITIONEDGE, 1, ZLEVEL_OUTPOST_NORTH),locate(world.maxx, maxy, ZLEVEL_OUTPOST_NORTH))
	edges |= block(locate(1, 1, ZLEVEL_OUTPOST_NORTH), locate(world.maxx, TRANSITIONEDGE, ZLEVEL_OUTPOST_NORTH))
	edges |= block(locate(1, maxy-TRANSITIONEDGE, ZLEVEL_OUTPOST_NORTH),locate(world.maxx, maxy, ZLEVEL_OUTPOST_NORTH))
	for(var/turf/T in edges)
		T.ChangeTurf(/turf/unsimulated/wall)

*/