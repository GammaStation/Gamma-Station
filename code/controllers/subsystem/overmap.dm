//Used for initializing overmap
var/datum/subsystem/overmap/SSovermap

/datum/subsystem/overmap
	name = "Overmap"
	flags = SS_NO_FIRE

/datum/subsystem/overmap/Initialize(timeofday)
	..()
	build_overmap()
	setup_overmap()

/datum/subsystem/overmap/proc/build_overmap()
	if(!config.overmap_enabled)
		return
	testing("Building overmap")
	world.maxz++
	var/list/turfs = list()
	for (var/square in block(locate(1, 1, ZLEVEL_OVERMAP), locate(OVERMAP_SIZE, OVERMAP_SIZE, ZLEVEL_OVERMAP)))
		var/turf/T = square
		if(T.x == OVERMAP_SIZE || T.y == OVERMAP_SIZE)
			T = T.ChangeTurf(/turf/unsimulated/wall/overmap)
		else
			T = T.ChangeTurf(/turf/unsimulated/floor/overmap)
		turfs += T
	testing("Overmap build complete.")

/datum/subsystem/overmap/proc/setup_overmap()
	if(!config.overmap_enabled)
		return
	// Removing overmap turfs, which are near to the edge of the map
	var/list/object_candidates = overmap_turfs.Copy()
	for(var/turf/T in overmap_turfs)
		for(var/turf/TU in RANGE_TURFS(2, T))
			if(istype(TU, /turf/unsimulated/wall/overmap))
				object_candidates -= T
	// Placing NFS Gamma to random sector
	var/turf/unsimulated/floor/overmap/G = pick(object_candidates)
	if(istype(G))
		new /obj/effect/overmap/object/gamma(G)
		G.mapZ = ZLEVEL_STATION
		G.map_can_be_killed = FALSE
	// Placing derelicts
	var/list/derelict_mappaths = file2list("maps/OvermapDerelicts/derelict_map_list.txt")
	for(var/mappath in derelict_mappaths)
		var/turf/unsimulated/floor/overmap/derelict_target = pick(object_candidates)
		if(!derelict_target.map_can_be_killed) // There is already something loaded there
			continue
		derelict_target.mapZ = maploader.load_new_z_level(mappath)
		derelict_target.map_can_be_killed = TRUE
		new /obj/effect/overmap/object/derelict(derelict_target)
	// Starting to generate random events
	for(var/turf/E in overmap_turfs)
		if(locate(/obj/effect/overmap/object) in E)
			continue
		switch(pickweight(possible_events))
			if("meteor")
				new /obj/effect/overmap/event/meteor(E)
			if("dust")
				new /obj/effect/overmap/event/dust(E)
			if("electrical")
				new /obj/effect/overmap/event/electrical(E)
			if("carp")
				new /obj/effect/overmap/event/carp(E)
			if("ion")
				new /obj/effect/overmap/event/ion(E)