/area/shuttle/survivor
	name = "Apache"
	icon_state = "shuttle"

/area/shuttle/survivor/space
	icon_state = "shuttle"

/area/shuttle/survivor/landed
	name = "Apache landed"
	icon_state = "shuttlegrn"
	base_turf = /turf/simulated/floor/plating/basalt

/area/shuttle/survivor/transit
	icon_state = "shuttle3"

/obj/machinery/computer/survivor_shuttle
	icon = 'icons/obj/computer-new.dmi'
	icon_state = "shuttle_comp"
	var/location = 0

	var/obj/item/device/radio/intercom/radio
	var/area/curr_location

/obj/machinery/computer/survivor_shuttle/atom_init()
	radio = new(src)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/survivor_shuttle/atom_init_late()
	curr_location = locate(/area/shuttle/survivor)

/obj/machinery/computer/survivor_shuttle/proc/check_lockdown()
	if(ticker && istype(ticker.mode,/datum/game_mode/survival))
		var/datum/game_mode/survival/gamemode = ticker.mode
		var/timeleft = gamemode.time_left()
		if(timeleft <= 0)
			return FALSE
		else
			return TRUE

	else
		return FALSE

/obj/machinery/computer/survivor_shuttle/proc/finish_gamemode(location)
	if(ticker && istype(ticker.mode,/datum/game_mode/survival))
		var/datum/game_mode/survival/gamemode = ticker.mode
		gamemode.shuttle_location = location

/obj/machinery/computer/survivor_shuttle/proc/survivor_move_to()
	if(check_lockdown())
		visible_message("<span class='notice'>Unable to start launching procedure - extreme weather conditions!</span>",1)
		return

	var/area/toArea = locate(/area/shuttle/survivor/space)
	curr_location.move_contents_to_new(toArea,null,null,TRUE)
	location = 1
	finish_gamemode(location)

/obj/machinery/computer/survivor_shuttle/attackby(obj/item/I, mob/user)
	return attack_hand(user)

/obj/machinery/computer/survivor_shuttle/ui_interact(mob/user)
	var/dat = {"<a href='?src=\ref[src];escape=1'>Launch</a><br>
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


/turf/simulated/shuttle/wall/erokez
	icon = 'code/modules/locations/shuttles/apache.dmi'
	icon_state = "0,5"
	base_state = "0,5"
	join_group = null
	under_turf = /turf/simulated/floor/plating/basalt
	takes_underlays = TRUE