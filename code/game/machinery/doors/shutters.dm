/obj/machinery/door/poddoor/shutters
	name = "Shutters"
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = "shutter1"
	icon_state_open  = "shutter0"
	icon_state_close = "shutter1"
	door_open_sound  = 'sound/machines/shutter_open.ogg'
	door_close_sound = 'sound/machines/shutter_close.ogg'

/obj/machinery/door/poddoor/shutters/atom_init()
	. = ..()
	layer = SHUTTERS_LAYER

/obj/machinery/door/poddoor/shutters/constructable
	anchored = FALSE

/obj/machinery/door/poddoor/shutters/constructable/atom_init()
	. = ..()
	close(TRUE)

/obj/machinery/door/poddoor/shutters/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/weapon/wrench))
		if(!density)
			default_unfasten_wrench(user, I, time = 30)
		return
	if(istype(I, /obj/item/device/multitool))
		var/obj/item/device/multitool/MT = I
		if(!anchored && MT.button_id)
			to_chat(user, "<span class='notice'>[bicon(MT)] Set [src]'s ID to: </span><span class='bold'>\"[MT.button_id]\"</span><span class='notice'>.</span>")
			id = MT.button_id
		return
	if(istype(I, /obj/item/weapon/crowbar))
		if(!anchored && !user.is_busy() && do_after(user, 60, target=src))
			new /obj/item/stack/sheet/plasteel(loc, 5, TRUE)
			qdel(src)
		return
	return ..()

/obj/machinery/door/poddoor/shutters/do_animate(animation)
	switch(animation)
		if("opening")
			flick("shutterc0", src)
		if("closing")
			flick("shutterc1", src)
	return

/obj/machinery/door/poddoor/shutters/syndi

/obj/machinery/door/poddoor/shutters/syndi/ex_act()
	return
