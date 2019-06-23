//Shuttle Floors
/obj/landed_holder
	name = "landed turf holder"
	desc = "holds all the info about the turf this turf 'landed on'"
	var/turf/turf_type
	var/turf/simulated/shuttle/my_turf
	var/image/turf_image
	var/list/decals

/obj/landed_holder/New(location = null, turf/simulated/shuttle/turf)
	..(null)
	my_turf = turf

/obj/landed_holder/proc/land_on(turf/T)
	//Gather destination information
	var/obj/landed_holder/new_holder = new(null)
	new_holder.turf_type = T.type
	new_holder.dir = T.dir
	new_holder.icon = T.icon
	new_holder.icon_state =  T.icon_state
	new_holder.overlays = T.overlays.Copy()
	new_holder.underlays = T.underlays.Copy()

	//Set the destination to be like us
	T.Destroy()
	var/turf/simulated/shuttle/new_dest = T.ChangeTurf(my_turf.type,,1)
	new_dest.set_dir(my_turf.dir)
	new_dest.icon_state = my_turf.icon_state
	new_dest.icon = my_turf.icon
	new_dest.overlays = my_turf.overlays
	new_dest.underlays = my_turf.underlays
	//Shuttle specific stuff
	new_dest.interior_corner = my_turf.interior_corner
	new_dest.takes_underlays = my_turf.takes_underlays
	new_dest.under_turf = my_turf.under_turf
	new_dest.join_flags = my_turf.join_flags
	new_dest.join_group = my_turf.join_group

	// Associate the holder with the new turf.
	new_holder.my_turf = new_dest
	new_dest.landed_holder = new_holder

	//Update underlays if necessary (interior corners won't have changed).
	if(new_dest.takes_underlays && !new_dest.interior_corner)
		new_dest.underlay_update()

	return new_dest

/obj/landed_holder/proc/leave_turf()
	var/turf/new_source
	//Change our source to whatever it was before
	if(turf_type)
		new_source = my_turf.ChangeTurf(turf_type,,1)
		new_source.set_dir(dir)
		new_source.icon_state = icon_state
		new_source.icon = icon
		new_source.overlays = overlays
		new_source.underlays = underlays
	else
		new_source = my_turf.ChangeTurf(get_base_turf_by_area(my_turf),,1)

	return new_source

/turf/simulated/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0
	layer = 2
	explosion_resistance = 1

	var/obj/landed_holder/landed_holder
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