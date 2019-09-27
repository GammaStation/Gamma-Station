var/list/geothermal_cache = list()
var/vent_min_power = 1500 * 2
var/vent_max_power = 1500 * 8

/obj/structure/geothermal_vent
	name = "vent"
	desc = "A geothermal vent."
	icon = 'icons/obj/machines/power/geothermal.dmi'
	icon_state = "vent_segment"
	density = FALSE
	opacity = FALSE
	anchored = TRUE
	layer = TURF_LAYER + 0.1

	var/next_vent_time = 0
	var/covered
	var/destroyed
	var/datum/effect/effect/system/smoke_spread/bad/steam

/obj/structure/geothermal_vent/atom_init()
	. = ..()
	update_icon(1)
	START_PROCESSING(SSobj, src)
	steam = new /datum/effect/effect/system/smoke_spread/bad()
	steam.attach(src)
	steam.set_up(3, 0, get_turf(src))

/obj/structure/geothermal_vent/Destroy()
	update_icon(1)
	STOP_PROCESSING(SSobj, src)
	return ..()


/obj/structure/geothermal_vent/process()
	if(covered || world.time < next_vent_time)
		return
	next_vent_time = world.time + rand(700,900)
	steam.start()

/obj/structure/geothermal_vent/ex_act()
	return

/obj/structure/geothermal_vent/update_icon(update_neighbors)

	var/turf/origin = get_turf(src)
	if(!istype(origin))
		return
	var/list/neighbors = list()
	for(var/checkdir in list(NORTH, SOUTH, EAST, WEST))
		var/turf/T = get_step(origin, checkdir)
		if(istype(T))
			var/obj/structure/geothermal_vent/V = locate() in T.contents
			if(!V || V.destroyed)
				continue
			neighbors |= checkdir
			if(update_neighbors)
				V.update_icon()

	if(!neighbors.len)
		icon_state = "vent_single"
	else if(neighbors.len == 1)
		dir = neighbors[1]
		icon_state = "vent_terminus"
	else if(neighbors.len == 2)
		var/has_north = (NORTH in neighbors)
		var/has_south = (SOUTH in neighbors)
		var/has_east =  (EAST in neighbors)
		var/has_west =  (WEST in neighbors)
		icon_state = "vent_segment"

		if(has_north && has_south)
			dir = pick(NORTH, SOUTH)
		else if(has_east && has_west)
			dir = pick(EAST, WEST)
		else if(has_east)
			if(has_north)
				dir = NORTHEAST
			else if(has_south)
				dir = SOUTHEAST
		else if(has_west)
			if(has_north)
				dir = NORTHWEST
			else if(has_south)
				dir = SOUTHWEST
	else
		icon_state = "vent_full"

/obj/machinery/power/geothermal
	name = "geothermal turbine"
	desc = "A hulking mass of pipes and metal used to produce power from geothermal vents."
	icon = 'icons/obj/machines/power/geothermal.dmi'
	icon_state = "geothermal-base"
	density = TRUE
	opacity = TRUE
	anchored = TRUE

	// Power vars.
	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0

	// Ref for power generation.
	var/obj/structure/geothermal_vent/vent
	var/last_produced = 0
	var/list/neighbors = list()
	var/efficiency = 0
	var/destroyed

	var/max_integrity = 100
	var/integrity = 100
	var/datum/effect/effect/system/spark_spread/sparks

/obj/machinery/power/geothermal/Destroy()
	destroyed = TRUE
	if(vent) vent.covered = 0
	update_neighbors()
	return ..()

/obj/machinery/power/geothermal/atom_init()
	. = ..()
	sparks = new /datum/effect/effect/system/spark_spread
	vent = locate() in get_turf(src)
	if(vent) vent.covered = 1
	if(powernet)
		connect_to_network()
	update_neighbors(1)

/obj/machinery/power/geothermal/attackby(obj/item/W, mob/user)
	if(!(stat & BROKEN)  && integrity < max_integrity)
		if(istype(W, /obj/item/weapon/wrench))
			if(user.is_busy()) return

			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			to_chat(user, "<span class='notice'>You start repairing damage of [src].</span>")
			if(do_after(user,40,target = src))
				if(!src || !user || !W)
					return
				to_chat(user, "<span class='notice'>You finish fixing some damege of [src].</span>")
				if(integrity < max_integrity)
					integrity += rand(25,30)
					healthcheck()

	else
		if(istype(W, /obj/item/weapon/weldingtool))
			if(user.is_busy()) return

			var/obj/item/weapon/weldingtool/WT = W

			if(WT.remove_fuel(5,user))
				to_chat(user, "<span class='notice'>You start weld bursted pipes of [src].</span>")
				playsound(src, 'sound/items/Welder.ogg', 100, 1)
				if(do_after(user,100, target = src))
					if(!src || !user || !WT || !WT.isOn())
						return
					to_chat(user, "<span class='notice'>You finish welding bursted pipes of [src].</span>")
					integrity = max_integrity
					stat &= ~BROKEN
					update_icon()

	if(iscoil(W))
		var/turf/T = get_turf(src)
		if(T && T.is_plating())
			var/from_dir = get_dir(src, user)
			for(var/obj/structure/cable/LC in T)
				if((LC.d1 == from_dir && LC.d2 == 0) || ( LC.d2 == from_dir && LC.d1 == 0))
					return
			var/obj/item/stack/cable_coil/coil = W
			coil.turf_place(T, user)
	. = ..()

/obj/machinery/power/geothermal/proc/update_neighbors(var/propagate_update)
	neighbors = list()
	for(var/checkdir in list(NORTH, SOUTH, EAST, WEST))
		var/obj/machinery/power/geothermal/G = locate() in get_step(src, checkdir)
		if(G && !G.destroyed)
			neighbors |= checkdir
			if(propagate_update)
				G.update_neighbors()
	// Base + two neighbors covers all available vent tiles and produces 100% avail. power.
	efficiency = min(1,(neighbors.len * 0.3) + 0.4)
	update_icon()

/obj/machinery/power/geothermal/update_icon()
	overlays.Cut()
	var/cache_key = ""
	for(var/checkdir in neighbors)
		cache_key = "geothermal-connector-[checkdir]"
		if(!geothermal_cache[cache_key])
			geothermal_cache[cache_key] = image(icon_state = "geothermal-connector", dir = checkdir)
		overlays |= geothermal_cache[cache_key]
		if(last_produced)
			cache_key = "geothermal-connector-glow-[checkdir]"
			if(!geothermal_cache[cache_key])
				geothermal_cache[cache_key] = image(icon_state = "geothermal-connector-glow", dir = checkdir)
			overlays |= geothermal_cache[cache_key]
	if(stat & BROKEN)
		return
	if(vent)
		cache_key = "geothermal-turbine-[src.dir]"
		if(!geothermal_cache[cache_key])
			geothermal_cache[cache_key] = image(icon_state = "geothermal-turbine", dir = src.dir)
		overlays |= geothermal_cache[cache_key]
		if(last_produced)
			var/produced_alpha = min(255,max(0,round((last_produced / vent_max_power)*255)))
			cache_key = "geothermal-glow-[produced_alpha]-[src.dir]"
			if(!geothermal_cache[cache_key])
				var/image/I = image(icon_state = "geothermal-glow", dir = src.dir)
				I.alpha = produced_alpha
				geothermal_cache[cache_key] = I
			overlays |= geothermal_cache[cache_key]

/obj/machinery/power/geothermal/process()
	last_produced = 0
	if(!(stat & BROKEN))
		if(vent && powernet)
			last_produced = (rand(vent_min_power, vent_max_power) * efficiency)
			add_avail(last_produced)
			if(integrity < max_integrity)
				if(prob(max_integrity-integrity))
					sparks.set_up(3, 1, src)
					sparks.start()
			if(prob(5))
				integrity -= rand(0,5)
				healthcheck()

	update_icon()

/obj/machinery/power/geothermal/proc/healthcheck()
	if(integrity <= 0)
		if(!(stat & BROKEN))
			broken()
	if(integrity > max_integrity)
		integrity = max_integrity

/obj/machinery/power/geothermal/proc/broken()
	stat |= BROKEN
	visible_message("<span class='notice'>[src] is busted!</span>",1)