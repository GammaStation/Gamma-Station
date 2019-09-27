/area/shuttle/survivor
	icon_state = "shuttle"

/area/shuttle/survivor/space
	name = "Atlas"
	icon_state = "shuttle"

/area/shuttle/survivor/landed
	name = "Atlas landed"
	icon_state = "shuttlegrn"

/area/shuttle/survivor/transit
	name = "Atlas in flight"
	icon_state = "shuttle3"

/obj/machinery/computer/survivor_shuttle
	icon = 'icons/obj/computer-new.dmi'
	icon_state = "steering"
	var/location = 0



	var/arrival_note = "Landing complete. Warning - no fuel"
	var/department_note = "Emergency undocking procedure is activated."
	var/obj/item/device/radio/intercom/radio
	var/area/curr_location

	var/area/transit_area
	var/moving = FALSE

/obj/machinery/computer/survivor_shuttle/atom_init()
	radio = new(src)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/survivor_shuttle/atom_init_late()
	transit_area = locate(/area/shuttle/survivor/transit)
	curr_location = locate(/area/shuttle/survivor)

/obj/machinery/computer/survivor_shuttle/proc/survivor_move_to()
//	if(moving)	return

	var/area/fromArea
	var/area/toArea

	if (location == 0)
		fromArea = locate(/area/shuttle/survivor/space)
		toArea = locate(/area/shuttle/survivor/landed)

	fromArea.move_contents_to_new(toArea)
	location = 1
/*

	from_area = curr_location
//	moving = TRUE


	radio.autosay(department_note, "Shuttle Alert System")
	to_chat(world,"EDEM2")
	transit_area.parallax_movedir = WEST
	from_area.move_contents_to(transit_area, null, WEST)
	to_chat(world,"EDEM3")
	shake_mobs(transit_area)
	curr_location = transit_area

//	sleep(OFFICER_SHUTTLE_MOVE_TIME)
	var/area/dest_location = locate(/area/shuttle/survivor/landed)
	curr_location.move_contents_to(dest_location)

	radio.autosay(arrival_note, "Arrivals Alert System")

	curr_location = dest_location

	moving = FALSE
*/

/obj/machinery/computer/survivor_shuttle/attackby(obj/item/I, mob/user)
	return attack_hand(user)

/obj/machinery/computer/survivor_shuttle/ui_interact(mob/user)
	var/dat = {"Внимание: топливные баки исчерпаны<br>
		<a href='?src=\ref[src];escape=1'>Emergency undocking</a><br>
		<a href='?src=\ref[user];mach_close=computer'>Close</a>"}

	user << browse(entity_ja(dat), "window=computer;size=575x450")
	onclose(user, "computer")

/obj/machinery/computer/survivor_shuttle/Topic(href, href_list)
	. = ..()
	if(!.)
		return

	if(href_list["escape"])
		survivor_move_to()


	updateUsrDialog()


/obj/machinery/computer/survivor_shuttle/proc/shake_mobs(area/A) //fucking copypaste from arrival shuttle
	for(var/mob/M in A)
		if(M.client)
			spawn(0)
				if(M.buckled)
					shake_camera(M, 2, 1)
				else
					shake_camera(M, 4, 2)
		M.Weaken(4)
		if(isliving(M) && !M.buckled)
			var/mob/living/L = M
			if(isturf(L.loc))
				for(var/i=0, i < 5, i++)
					var/turf/T = L.loc
					var/hit = 0
					T = get_step(T, EAST)
					if(T.density)
						hit = 1
						if(i > 1)
							L.adjustBruteLoss(10)
						break
					else
						for(var/atom/movable/AM in T.contents)
							if(AM.density)
								hit = 1
								if(i > 1)
									L.adjustBruteLoss(10)
									if(isliving(AM))
										var/mob/living/bumped = AM
										bumped.adjustBruteLoss(10)
								break
					if(hit)
						break
					step(L, EAST)


/*
var/surv_ship_location = 1 // 0 = planet , 1 = space

/proc/move_surv_ship()
	var/area/fromArea
	var/area/toArea
	if (surv_ship_location == 1)
		fromArea = locate(/area/shuttle/alien/mine)
		toArea = locate(/area/shuttle/alien/base)
	else
		fromArea = locate(/area/shuttle/alien/base)
		toArea = locate(/area/shuttle/alien/mine)
	fromArea.move_contents_to(toArea)
	if (surv_ship_location)
		surv_ship_location = 0
	else
		surv_ship_location = 1
	return

*/

/turf/simulated/shuttle/wall/erokez
	icon = 'code/modules/locations/shuttles/erokez.dmi'
	icon_state = "0,5"
	base_state = "0,5"
	join_group = null
	under_turf = /turf/simulated/floor/plating/basalt
	takes_underlays = 1