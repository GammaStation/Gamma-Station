//Used for initializing overmap
var/datum/subsystem/overmap/SSovermap

/datum/subsystem/overmap
	name = "Overmap"
	flags = SS_NO_FIRE

/datum/subsystem/overmap/Initialize(timeofday)
	..()
	build_overmap_templates()
	setup_overmap()

/datum/subsystem/overmap/proc/build_overmap_templates()


/datum/subsystem/overmap/proc/setup_overmap()
	//Removing overmap turfs, which are near to the edge of the map
	var/list/object_candidates = overmap_turfs.Copy()
	for(var/turf/T in overmap_turfs)
		for(var/turf/TU in RANGE_TURFS(2, T))
			if(istype(TU, /turf/unsimulated/wall/overmap))
				object_candidates -= T
	//Placing NFS Gamma to random sector
	var/turf/unsimulated/floor/overmap/G = pick(object_candidates)
	if(istype(G))
		new /obj/effect/overmap/object/gamma(G)
		G.mapZ = ZLEVEL_STATION
		G.map_can_be_killed = FALSE
	//Starting to generate random events
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