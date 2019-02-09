/obj/effect/landmark/overmap
	name = "Overmap landmark."

/obj/effect/landmark/overmap/center

/obj/effect/landmark/overmap/bluespace_rift_navpoint
	name = "bluespace rift navpoint"
	var/id

/obj/effect/landmark/overmap/bluespace_rift_navpoint/atom_init()
	. = ..()
	bluespace_rift_navpoints += src

/obj/effect/landmark/overmap/bluespace_rift_navpoint/Destroy()
	bluespace_rift_navpoints -= src
	for(var/turf/T in RANGE_TURFS(BLUESPACE_RIFT_SIZE, src))
		qdel(T)
	..()
