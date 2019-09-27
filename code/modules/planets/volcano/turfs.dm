/turf/simulated/floor/plating/basalt //floor piece
	name = "volcanic floor"
	icon = 'icons/turf/planets/volcano/floors.dmi'
	icon_state = "basalt0"
	oxygen = LAVA_TURF_O2
	nitrogen = LAVA_TURF_N
	carbon_dioxide = LAVA_TURF_CO2
	temperature = LAVA_TURF_TEMP
	icon_plating = "basalt"
	var/dug = 0       //0 = has not yet been dug, 1 = has already been dug
	has_resources = 1
	footsteps_sound = list('sound/effects/asteroid1.ogg','sound/effects/asteroid2.ogg','sound/effects/asteroid3.ogg','sound/effects/asteroid4.ogg','sound/effects/asteroid5.ogg')
	light_power = 1
	light_color = COLOR_GRAY

/turf/simulated/floor/plating/basalt/atom_init()
	. = ..()
	set_light(1.5)
	if(prob(20))
		icon_state = "basalt[rand(0,12)]"
	if(!istype(src,/turf/simulated/floor/plating/basalt/lava) && istype(get_area(src),/area/surface) && prob(1))
		new /obj/structure/flora/rock/volcano(src)

/turf/simulated/floor/plating/basalt/ex_act(severity)
	switch(severity)
		if(3.0)
			return
		if(2.0)
			if(prob(70))
				icon_plating = "basalt_dug"
				icon_state = "basalt_dug"
		if(1.0)
			icon_plating = "basalt_dug"
			icon_state = "basalt_dug"
	return

/turf/simulated/floor/plating/basalt/break_tile()
	return

/turf/simulated/floor/plating/basalt_plating/caution
	icon_state = "basalt_plating-caution"

/turf/simulated/floor/plating/basalt_plating/caution/corner
	icon_state = "basalt_plating-cautioncorner"

/turf/simulated/basalt //wall piece
	name = "Basalt rock"
	icon = 'icons/turf/planets/volcano/walls.dmi'
	icon_state = "basalt_rock"
	oxygen = LAVA_TURF_O2
	nitrogen = LAVA_TURF_N
	carbon_dioxide = LAVA_TURF_CO2
	temperature = LAVA_TURF_TEMP
	opacity = TRUE
	density = TRUE
	blocks_air = TRUE
	color = "#6F6F6F"
	var/mineral/mineral
	var/mined_ore = 0
	var/last_act = 0
	basetype = /turf/simulated/floor/plating/basalt
	var/datum/geosample/geologic_data
	var/excavation_level = 0
	var/list/finds
	var/next_rock = 0
	var/archaeo_overlay = ""
	var/excav_overlay = ""
	var/obj/item/weapon/last_find
	var/datum/artifact_find/artifact_find

/turf/simulated/basalt/atom_init()
	..()
	update_icon()
	return INITIALIZE_HINT_LATELOAD

/turf/simulated/basalt/atom_init_late()
//	update_icon()

/turf/simulated/basalt/update_icon()
	overlays.Cut()

	for(var/direction in cardinal)
		var/turf/turf_to_check = get_step(src,direction)
		if(istype(turf_to_check,/turf/simulated/floor/plating/basalt) || istype(turf_to_check,/turf/space) )
			var/image/rock_side = image(icon, "[icon_state]-side", dir = turn(direction, 180))
			rock_side.color = "#6F6F6F"
			turf_to_check.overlays += rock_side


/turf/simulated/floor/plating/basalt/lava
	name = "lava"
	icon = 'icons/turf/planets/volcano/lava.dmi'
	icon_state = "lava"
	var/basestate = "lava"
	light_power = 1
	light_color = COLOR_ORANGE

/turf/simulated/floor/plating/basalt/lava/atom_init()
	..()
	set_light(2)
	return INITIALIZE_HINT_LATELOAD

/turf/simulated/floor/plating/basalt/lava/atom_init_late()
	update_icon(1)

/turf/simulated/floor/plating/basalt/lava/ex_act(severity)
	return

/turf/simulated/floor/plating/basalt/lava/update_icon()
	overlays.Cut()
	var/list/dirs = list()
	for(var/turf/simulated/floor/plating/basalt/lava/L in orange(src,1))
		dirs += get_dir(src, L)

	var/list/connections = dirs_to_corner_states(dirs)

	icon_state = ""
	for(var/i = 1 to 4)
		var/image/I = image(icon, "[basestate][connections[i]]", dir = 1<<(i-1),layer = layer + 0.1)
		overlays += I

/turf/simulated/floor/plating/basalt/lava/Entered(atom/movable/AM)
	..()
	if(isliving(AM))
		var/mob/living/M = AM
		M.adjust_fire_stacks(20)
		M.IgniteMob()
	else if(isobj(AM))
		visible_message("<span class='warning'>[AM] has burned in lava!</span>")
		qdel(AM)
