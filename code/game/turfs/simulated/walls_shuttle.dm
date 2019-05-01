/turf/simulated/shuttle/wall
	name = "wall"
	icon = 'icons/turf/shuttle_white.dmi'
	icon_state = "white"
	opacity = TRUE
	density = TRUE
	blocks_air = TRUE
	explosion_resistance = 5

	takes_underlays = TRUE

	var/base_state = "white" //The base iconstate to base sprites on
	var/hard_corner = FALSE //Forces hard corners (as opposed to diagonals)


	//Extra things this will try to locate and act like we're joining to. You can put doors, or whatever.
	//Carefully means only if it's on a /turf/simulated/shuttle subtype turf.
	var/static/list/join_carefully = list(
	/obj/structure/grille,
	/obj/machinery/door/poddoor
	)
	var/static/list/join_always = list(
	/obj/structure/shuttle/engine,
	/obj/structure/shuttle/window,
	/obj/machinery/door/unpowered/shuttle
	)

/turf/simulated/shuttle/wall/atom_init()
	. = ..()
	if(join_group)
		auto_join()
	else
		icon_state = base_state

	if(takes_underlays)
		underlay_update()

/turf/simulated/shuttle/wall/proc/auto_join()
	match_turf(NORTH, NORTH)
	match_turf(EAST, EAST)
	match_turf(SOUTH, SOUTH)
	match_turf(WEST, WEST)

	icon_state = "[base_state][join_flags]"
	if(isDiagonal(join_flags))
		if(hard_corner) //You are using 'hard' (aka full-tile) corners.
			icon_state += "h" //Hard corners have 'h' at the end of the state
		else //Diagonals need an underlay to not look ugly.
			takes_underlays = 1
	else //Everything else doesn't deserve our time!
		takes_underlays = initial(takes_underlays)

	return join_flags

/turf/simulated/shuttle/wall/proc/match_turf(direction, flag, mask=0)
	if((join_flags & mask) == mask)
		var/turf/simulated/shuttle/wall/adj = get_step(src, direction)
		if(istype(adj, /turf/simulated/shuttle/wall) && adj.join_group == join_group)
			join_flags |= flag      // turn on the bit flag
			return

		else if(istype(adj, /turf/simulated/shuttle))
			var/turf/simulated/shuttle/adj_cast = adj
			if(adj_cast.join_group == join_group)
				var/found
				for(var/E in join_carefully)
					found = locate(E) in adj
					if(found) break
				if(found)
					join_flags |= flag      // turn on the bit flag
					return

		var/always_found
		for(var/E in join_always)
			always_found = locate(E) in adj
			if(always_found) break
		if(always_found)
			join_flags |= flag      // turn on the bit flag
		else
			join_flags &= ~flag     // turn off the bit flag

/turf/simulated/shuttle/wall/hard_corner
	name = "wall"
	icon_state = "white-hc"
	hard_corner = TRUE

/turf/simulated/shuttle/wall/no_join
	icon_state = "white-nj"
	join_group = null
	takes_underlays = FALSE

/turf/simulated/shuttle/wall/orange
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "pwall"
	base_state = "pwall"
	join_group = null

/turf/simulated/shuttle/wall/legacy_black
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "wall3"
	base_state = "wall3"
	join_group = null

/turf/simulated/shuttle/wall/black
	icon = 'icons/turf/shuttle_black.dmi'
	icon_state = "black"
	base_state = "black"

/turf/simulated/shuttle/wall/black/hard_corner
	name = "wall"
	icon_state = "black-hc"
	hard_corner = TRUE

/turf/simulated/shuttle/wall/black/no_join
	icon_state = "black-nj"
	join_group = null
	takes_underlays = FALSE