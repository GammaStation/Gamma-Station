/obj/machinery/optable
	name = "Operating Table"
	desc = "Used for advanced medical procedures."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "table2-idle"
	density = 1
	anchored = 1.0
	use_power = 1
	idle_power_usage = 1
	active_power_usage = 5
	var/mob/living/carbon/human/victim = null
	var/strapped = 0.0

	var/obj/machinery/computer/operating/computer = null

/obj/machinery/optable/atom_init()
	. = ..()
	for(dir in list(NORTH,EAST,SOUTH,WEST))
		computer = locate(/obj/machinery/computer/operating, get_step(src, dir))
		if (computer)
			computer.table = src
			break
//	spawn(100) //Wont the MC just call this process() before and at the 10 second mark anyway?
//		process()

/obj/machinery/optable/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				src.density = 0
		else
	return

/obj/machinery/optable/blob_act()
	if(prob(75))
		qdel(src)

/obj/machinery/optable/attack_paw(mob/user)
	if ((HULK in usr.mutations))
		user.SetNextMove(CLICK_CD_MELEE)
		to_chat(usr, text("<span class='notice'>You destroy the operating table.</span>"))
		visible_message("<span class='danger'>[usr] destroys the operating table!</span>")
		src.density = 0
		qdel(src)
	return

/obj/machinery/optable/attack_hand(mob/user)
	if (HULK in usr.mutations)
		user.SetNextMove(CLICK_CD_MELEE)
		to_chat(usr, text("<span class='notice'>You destroy the table.</span>"))
		visible_message("<span class='danger'>[usr] destroys the operating table!</span>")
		src.density = 0
		qdel(src)
	else
		return ..() // for fun, for braindamage and fingerprints.

/obj/machinery/optable/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	if(mover.is_focused)
		return 1
	else
		return 0


/obj/machinery/optable/MouseDrop_T(obj/O, mob/user)
	if(isrobot(user) || isessence(user))
		return

	if ((!( istype(O, /obj/item/weapon) ) || user.get_active_hand() != O))
		return
	user.drop_item()
	if (O.loc != src.loc)
		step(O, get_dir(O, src))
	return

/obj/machinery/optable/proc/check_victim()
	if(locate(/mob/living/carbon/human, src.loc))
		var/mob/living/carbon/human/M = locate(/mob/living/carbon/human, src.loc)
		if(M.resting)
			src.victim = M
			icon_state = M.pulse ? "table2-active" : "table2-idle"
			return 1
	src.victim = null
	icon_state = "table2-idle"
	return 0

/obj/machinery/optable/process()
	check_victim()

/obj/machinery/optable/proc/take_victim(mob/living/carbon/C, mob/living/carbon/user)
	if (C == user)
		user.visible_message("<span class='rose'>[user] climbs on the operating table.</span>","<span class='notice'>You climb on the operating table.</span>")
	else
		visible_message("<span class='notice'>[C] has been laid on the operating table by [user].</span>", 3)
	if (C.client)
		C.client.perspective = EYE_PERSPECTIVE
		C.client.eye = src
	C.resting = 1
	C.loc = src.loc
	for(var/obj/O in src)
		O.loc = src.loc
	src.add_fingerprint(user)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		src.victim = H
		icon_state = H.pulse ? "table2-active" : "table2-idle"
	else
		icon_state = "table2-idle"

/obj/machinery/optable/verb/climb_on()
	set name = "Climb On Table"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || !ishuman(usr) || usr.buckled || usr.restrained())
		return

	if(src.victim)
		to_chat(usr, "<span class='rose'>The table is already occupied!</span>")
		return

	take_victim(usr,usr)

/obj/machinery/optable/attackby(obj/item/weapon/W, mob/living/carbon/user, params)
	if(isrobot(user))
		return

	if(istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = W
		if(iscarbon(G.affecting))
			take_victim(G.affecting, user)
			user.SetNextMove(CLICK_CD_MELEE)
			qdel(W)
			return

	var/obj/item/tk_grab/put_me = user.get_active_hand(additional_checks = FALSE)
	if(istype(put_me))
		if(put_me.focus.anchored || !Adjacent(put_me.focus))
			return
		if(iscarbon(put_me.focus))
			take_victim(put_me.focus, user)
			user.SetNextMove(CLICK_CD_MELEE)
			return
		if(istype(put_me.focus, /obj/item))
			var/obj/item/II = put_me.focus
			if(II.flags & NODROP || II.flags & ABSTRACT)
				return
			var/list/click_params = params2list(params)
			//Center the icon where the user clicked.
			if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
				return
			put_me.focus.pixel_x = Clamp(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
			put_me.focus.pixel_y = Clamp(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)
		if(!istype(put_me.focus.loc, /turf))
			user.drop_from_inventory(put_me.focus)
		put_me.focus.forceMove(loc)
		return

	user.drop_item()
	if(W && W.loc)
		W.loc = src.loc
