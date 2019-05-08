/obj/item/door_control_assembly
	name = "remote door-control assembly"
	desc = "It controls doors, remotely, when assembled."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doorctrl0"
	var/has_wires = FALSE
	var/has_signaler = FALSE
	var/obj/item/weapon/airlock_electronics/electronics

/obj/item/door_control_assembly/examine(mob/user)
	..()
	if(!has_wires)
		to_chat(user, "[bicon(src)] Is missing wires.")
	if(!has_signaler)
		to_chat(user, "[bicon(src)] Is missing a signaler.")

/obj/item/door_control_assembly/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/wrench))
		user.SetNextMove(CLICK_CD_RAPID)
		new /obj/item/stack/sheet/plasteel(loc, 1)
		if(has_wires)
			new /obj/item/stack/cable_coil(loc, 1)
		if(has_signaler)
			new /obj/item/device/assembly/signaler(loc)
		if(electronics)
			electronics.forceMove(loc)
			electronics = null
		qdel(src)
		return
	else if(!has_wires && istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/CC = W
		if(CC.use(1))
			to_chat(user, "<span class='notice'>You add wires to [src].</span>")
			has_wires = TRUE
		return
	else if(!has_signaler && istype(W, /obj/item/device/assembly/signaler))
		to_chat(user, "<span class='notice'>You add a signaler to [src].</span>")
		has_signaler = TRUE
		qdel(W)
		return
	else if(istype(W, /obj/item/weapon/airlock_electronics))
		var/obj/item/weapon/airlock_electronics/AE = W
		if(!AE.broken && !user.is_busy())
			playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
			user.visible_message("<span class='notice'>[user] installs \the [AE] into \the [src].</span>", "<span class='notice'>You start to install [AE] into \the [src].</span>")
			if(do_after(user, 40, target = src))
				to_chat(user, "<span class='notice'>You installed \the [AE]!</span>")
				user.drop_from_inventory(AE, get_turf(AE))
				AE.forceMove(src)
				electronics = AE
	return ..()

/obj/item/door_control_assembly/proc/try_build(turf/on_wall)
	if(get_dist(on_wall, usr) > 1)
		return
	var/ndir = get_dir(usr, on_wall)
	if (!(ndir in cardinal))
		return
	if(!has_wires)
		to_chat(usr, "<span class='warning'>[src] cannot be used without wires.</span>")
		return
	if(!has_signaler)
		to_chat(usr, "<span class='warning'>[src] cannot be used without a signaler.</span>")
		return
	var/turf/T = get_turf(usr)
	var/area/A = T.loc
	if(!istype(T, /turf/simulated/floor))
		to_chat(usr, "<span class='warning'>[src] cannot be placed on this spot.</span>")
		return
	if(A.requires_power == 0 || A.name == "Space")
		to_chat(usr, "<span class='warning'>[src] cannot be placed in this area.</span>")
		return
	if(gotwallitem(T, ndir))
		to_chat(usr, "<span class='warning'>There's already an item on this wall!</span>")
		return
	var/obj/machinery/door_control/DC = new /obj/machinery/door_control(T, ndir, TRUE)

	if(electronics && !electronics.broken)
		electronics.forceMove(DC)
		DC.electronics = electronics
		if(electronics.one_access)
			DC.req_access = null
			DC.req_one_access = electronics.conf_access
		else
			DC.req_access = electronics.conf_access
		electronics = null

	qdel(src)


/obj/machinery/door_control
	name = "remote door-control"
	desc = "It controls doors, remotely."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doorctrl0"
	power_channel = ENVIRON
	anchored = TRUE
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4
	var/id = null
	var/range = 10
	var/normaldoorcontrol = FALSE
	var/desiredstate = 0 // Zero is closed, 1 is open.
	var/specialfunctions = 1
	var/obj/item/weapon/airlock_electronics/electronics

/obj/machinery/door_control/atom_init(mapload, dir, building)
	. = ..()

	if(building)
		pixel_x = (dir & 3) ? 0 : (dir == 4 ? 24 : -24)
		pixel_y = (dir & 3) ? (dir == 1 ? 24 : -24) : 0

/obj/machinery/door_control/allowed_fail(mob/user)
	playsound(src, 'sound/items/buttonswitch.ogg', 20, 1, 1)
	flick("doorctrl-denied",src)

/obj/machinery/door_control/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/device/detective_scanner))
		return
	if(istype(W, /obj/item/weapon/card/emag))
		req_access = list()
		user.SetNextMove(CLICK_CD_INTERACT)
		req_one_access = list()
		playsound(src.loc, "sparks", 100, 1)
	if(istype(W, /obj/item/device/multitool))
		if(!id)
			id = input("Please type in an id for the button") as text
			return
		else
			to_chat(user, "<span class='notice'>[bicon(W)] The multitool ID field reads: </span><span class='bold'>\"[id]\"</span><span class='notice'>.</span>")
			if(alert("Save ID to multitool?", , "Yes", "No") == "Yes")
				var/obj/item/device/multitool/MT = W
				MT.button_id = id
			return
	if(istype(W, /obj/item/weapon/wrench) && !user.is_busy() && do_after(user, 40, target=src))
		var/obj/item/door_control_assembly/DCA = new /obj/item/door_control_assembly(loc)
		DCA.has_wires = TRUE
		DCA.has_signaler = TRUE
		if(electronics)
			electronics.forceMove(DCA)
			DCA.electronics = electronics
			electronics = null
		qdel(src)
		return
	return attack_hand(user)

/obj/machinery/door_control/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	user.SetNextMove(CLICK_CD_INTERACT)
	playsound(src, 'sound/items/buttonswitch.ogg', 20, 1, 1)
	use_power(5)
	icon_state = "doorctrl1"

	if(normaldoorcontrol)
		for(var/obj/machinery/door/airlock/D in range(range))
			if(D.id_tag == src.id && D.anchored)
				if(specialfunctions & OPEN)
					if (D.density)
						spawn(0)
							D.open()
							return
					else
						spawn(0)
							D.close()
							return
				if(desiredstate == 1)
					if(specialfunctions & IDSCAN)
						D.aiDisabledIdScanner = 1
					if(specialfunctions & BOLTS)
						D.bolt()
					if(specialfunctions & SHOCK)
						D.secondsElectrified = -1
					if(specialfunctions & SAFE)
						D.safe = 0
				else
					if(specialfunctions & IDSCAN)
						D.aiDisabledIdScanner = 0
					if(specialfunctions & BOLTS)
						if(!D.isAllPowerCut() && D.hasPower())
							D.unbolt()
					if(specialfunctions & SHOCK)
						D.secondsElectrified = 0
					if(specialfunctions & SAFE)
						D.safe = 1

	else
		for(var/obj/machinery/door/poddoor/M in machines)
			if(M.id == src.id && M.anchored)
				if (M.density)
					spawn( 0 )
						M.open()
						return
				else
					spawn( 0 )
						M.close()
						return

	desiredstate = !desiredstate
	spawn(15)
		if(!(stat & NOPOWER))
			icon_state = "doorctrl0"

/obj/machinery/door_control/power_change()
	..()
	if(stat & NOPOWER)
		icon_state = "doorctrl-p"
	else
		icon_state = "doorctrl0"

/obj/machinery/driver_button/attackby(obj/item/weapon/W, mob/user)

	if(istype(W, /obj/item/device/detective_scanner))
		return
	return src.attack_hand(user)

/obj/machinery/driver_button/attack_hand(mob/user)
	if(..() || active)
		return 1

	use_power(5)
	user.SetNextMove(CLICK_CD_INTERACT)

	active = 1
	icon_state = "launcheract"

	for(var/obj/machinery/door/poddoor/M in machines)
		if(M.id == src.id && M.anchored)
			spawn( 0 )
				M.open()
				return

	sleep(20)

	for(var/obj/machinery/mass_driver/M in machines)
		if(M.id == src.id && M.anchored)
			M.drive()

	sleep(50)

	for(var/obj/machinery/door/poddoor/M in machines)
		if(M.id == src.id && M.anchored)
			spawn( 0 )
				M.close()
				return

	icon_state = "launcherbtt"
	active = 0
