/turf/simulated/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0
	layer = 2
	explosion_resistance = 1

	var/interior_corner = 0
	var/takes_underlays = FALSE
	var/turf/under_turf //Underlay override turf path.
	var/join_flags = 0 //Bitstring to represent adjacency of joining walls
	var/join_group = "shuttle" //A tag for what other walls to join with. Null if you don't want them to.

/turf/simulated/shuttle/proc/underlay_update()
	if(!takes_underlays)
		//Basically, if it's not forced, and we don't care, don't do it.
		return FALSE

	var/turf/under //May be a path or a turf
	var/image/us = new(src) //We'll use this for changes later
	us.underlays.Cut()

	//Mapper wanted something specific
	if(under_turf)
		under = under_turf

	if(!under)
		var/turf/T1
		var/turf/T2
		var/turf/T3

		T1 = get_step(src, turn(join_flags,135)) // 45 degrees before opposite
		T2 = get_step(src, turn(join_flags,225)) // 45 degrees beyond opposite
		T3 = get_step(src, turn(join_flags,180)) // Opposite from the diagonal

		if(isfloor(T1) && ((T1.type == T2.type) || (T1.type == T3.type)))
			under = T1
		else if(isfloor(T2) && T2.type == T3.type)
			under = T2
		else if(isfloor(T3) || istype(T3,/turf/space/transit))
			under = T3
		else
			under = get_base_turf_by_area(src)

	if(istype(under,/turf/simulated/shuttle))
		interior_corner = 1 //Prevents us from 'landing on grass' and having interior corners update.

	var/image/under_ma

	if(ispath(under)) //It's just a mapper-specified path
		under_ma = new()
		under_ma.icon = initial(under.icon)
		under_ma.icon_state = initial(under.icon_state)
		under_ma.color = initial(under.color)

	else //It's a real turf
		under_ma = new(under)

	if(under_ma)
		if(ispath(under,/turf/space)) //Scramble space turfs
			under_ma.icon_state = null
			var/image/I = image('icons/turf/space.dmi', SPACE_ICON_STATE, layer=TURF_LAYER)
			I.plane = PLANE_SPACE
			under_ma.underlays += I
		us.underlays = list(under_ma)

	appearance = us

	return under

/turf/simulated/shuttle/floor
	name = "floor"
	icon_state = "floor"

/turf/simulated/shuttle/plating
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"

/turf/simulated/shuttle/floor4 // Added this floor tile so that I have a seperate turf to check in the shuttle -- Polymorph
	name = "Brig floor"        // Also added it into the 2x3 brig area of the shuttle.
	icon_state = "floor4"