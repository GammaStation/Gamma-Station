/turf/unsimulated/floor/overmap
	icon_state = "map"
	var/sector = null
	var/list/ships_in_sector = list()
	var/mappath = "maps/templates/spacesector.dmm"
	var/mapZ = null
	var/map_can_be_killed = TRUE

/turf/unsimulated/floor/overmap/atom_init()
	. = ..()
	overmap_turfs += src
	name = "[x]-[y]"

/turf/unsimulated/floor/overmap/proc/pre_crossed(atom/movable/A)
	if(mapZ)
		return
	if(empty_zlevels.len)
		testing("Checking if we have empty zlevel")
		mapZ = empty_zlevels[1]
		return
	world.maxz++
	mapZ = world.maxz
	map_zlevels.Add(mapZ)

/turf/unsimulated/floor/overmap/proc/can_die()
	testing("Checking if sector at [mapZ] can die.")
	if(!map_can_be_killed)
		return FALSE
	for(var/mob/living/M in player_list)
		if(M.z == mapZ)
			testing("There are people on it.")
			return FALSE
	return TRUE

/turf/unsimulated/floor/overmap/Crossed(atom/movable/A)
	testing("[A] has entered sector")
	if(istype(A, /obj/effect/overmap/ship))
		var/obj/effect/overmap/ship/S = A
		S.current_sector = src
		ships_in_sector += A

/turf/unsimulated/floor/overmap/Uncrossed(atom/movable/A)
	testing("[A] has left sector")
	if(istype(A, /obj/effect/overmap/ship))
		var/obj/effect/overmap/ship/S = A
		S.current_sector = null
		ships_in_sector -= A
	if(!ships_in_sector.len && can_die())
		testing("Killing sector at [mapZ].")
		var/turf/center = locate(world.maxx/2, world.maxy/2, mapZ)
		for(var/atom/atom in RANGE_TURFS(world.maxx/2, center))
			qdel(atom)
		map_zlevels -= mapZ
		empty_zlevels += mapZ
		testing("[empty_zlevels.len]")
		mapZ = null

/turf/unsimulated/wall/overmap
	icon = 'icons/turf/floors.dmi'
	icon_state = "map"

/turf/unsimulated/wall/overmap/atom_init()
	. = ..()
	name = "[x]-[y]"
	var/list/numbers = list()

	if(x == 1 || x == OVERMAP_SIZE)
		numbers += list("[round(y/10)]","[round(y%10)]")
		if(y == 1 || y == OVERMAP_SIZE)
			numbers += "-"
	if(y == 1 || y == OVERMAP_SIZE)
		numbers += list("[round(x/10)]","[round(x%10)]")

	for(var/i = 1 to numbers.len)
		var/image/I = image('icons/effects/numbers.dmi',numbers[i])
		I.pixel_x = 5*i - 2
		I.pixel_y = world.icon_size/2 - 3
		if(y == 1)
			I.pixel_y = 3
			I.pixel_x = 5*i + 4
		if(y == OVERMAP_SIZE)
			I.pixel_y = world.icon_size - 9
			I.pixel_x = 5*i + 4
		if(x == 1)
			I.pixel_x = 5*i - 2
		if(x == OVERMAP_SIZE)
			I.pixel_x = 5*i + 2
		overlays += I

/turf/unsimulated/floor/bluespace
	icon = 'icons/turf/floors.dmi'
	icon_state = "bluespace"

/turf/unsimulated/wall/bluespace
	icon = 'icons/turf/floors.dmi'
	icon_state = "bluespace"