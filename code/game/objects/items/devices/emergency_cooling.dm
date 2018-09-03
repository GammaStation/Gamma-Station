/obj/item/device/emergency_cooling_device
	name = "emergency cooling device"
	desc = "A portable and small liquid cooling device. Used for emergency cooling."
	w_class = 1
	icon = 'icons/obj/device.dmi'
	icon_state = "emcooler0"
	slot_flags = SLOT_BELT
	//copied from tank.dm
	flags = CONDUCT
	force = 5.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 4

	origin_tech = "magnets=2;materials=2"

	var/on = 0				//is it turned on?
	var/cover_open = 0		//is the cover open?
	var/obj/item/weapon/stock_parts/cell/cell
	var/max_cooling = 8				//in degrees per second - probably don't need to mess with heat capacity here
	var/charge_consumption = 500		//increased consumption in comparison with bigger one, which has 16.6
	var/thermostat = T20C


/obj/item/device/emergency_cooling_device/atom_init()
	. = ..()
	START_PROCESSING(SSobj, src)

	cell = new/obj/item/weapon/stock_parts/cell()	//comes with the crappy default power cell - high-capacity ones shouldn't be hard to find
	cell.loc = src

/obj/item/device/emergency_cooling_device/process()
	if (!on || !cell)
		return

	if (!ismob(loc))
		return

	var/mob/living/carbon/human/H = loc

	var/env_temp = get_environment_temperature()		//wont save you from a fire
	var/temp_adj = min(H.bodytemperature - max(thermostat, env_temp), max_cooling)

	if (temp_adj < 0.5)	//only cools, doesn't heat, also we don't need extreme precision
		return

	var/charge_usage = (temp_adj/max_cooling)*charge_consumption

	H.bodytemperature -= temp_adj*5

	cell.use(charge_usage)

	if(cell.charge <= 0)
		turn_off()

/obj/item/device/emergency_cooling_device/proc/get_environment_temperature()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(istype(H.loc, /obj/mecha))
			var/obj/mecha/M = H.loc
			return M.return_temperature()
		else if(istype(H.loc, /obj/machinery/atmospherics/components/unary/cryo_cell))
			var/obj/machinery/atmospherics/components/unary/cryo_cell/cryo = H.loc
			var/datum/gas_mixture/G = cryo.AIR1
			return G.temperature

	var/turf/T = get_turf(src)
	if(istype(T, /turf/space))
		return 0	//space has no temperature, this just makes sure the cooling unit works in space

	var/datum/gas_mixture/environment = T.return_air()
	if (!environment)
		return 0

	return environment.temperature

/obj/item/device/emergency_cooling_device/proc/turn_on()
	if(!cell)
		return
	if(cell.charge <= 0)
		return

	on = 1
	updateicon()

/obj/item/device/emergency_cooling_device/proc/turn_off()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.show_message("\The [src] clicks and whines as it powers down.", 2)	//let them know in case it's run out of power.
	on = 0
	updateicon()

/obj/item/device/emergency_cooling_device/attack_self(mob/user)
	if(cover_open && cell)
		if(ishuman(user))
			user.put_in_hands(cell)
		else
			cell.loc = get_turf(loc)

		cell.add_fingerprint(user)
		cell.updateicon()

		to_chat(user, "You remove the [src.cell].")
		src.cell = null
		updateicon()
		return

	//TODO use a UI like the air tanks
	if(on)
		turn_off()
	else
		turn_on()
		if (on)
			to_chat(user, "You switch on the [src].")

/obj/item/device/emergency_cooling_device/attackby(obj/item/weapon/W, mob/user)
	if (istype(W, /obj/item/weapon/screwdriver))
		if(cover_open)
			cover_open = 0
			to_chat(user, "You screw the panel into place.")
		else
			cover_open = 1
			to_chat(user, "You unscrew the panel.")
		updateicon()
		return

	if (istype(W, /obj/item/weapon/stock_parts/cell))
		if(cover_open)
			if(cell)
				to_chat(user, "There is a [cell] already installed here.")
			else
				user.drop_item()
				W.loc = src
				cell = W
				to_chat(user, "You insert the [cell].")
		updateicon()
		return

	return ..()

/obj/item/device/emergency_cooling_device/proc/updateicon()
	if (cover_open)
		if (cell)
			icon_state = "emcooler1"
		else
			icon_state = "emcooler2"
	else
		icon_state = "emcooler0"

/obj/item/device/emergency_cooling_device/examine(mob/user)
	..()
	if (src in view(1, user))
		if (on)
			to_chat(user, "It's switched on and running.")
		else
			to_chat(user, "It is switched off.")

		if (cover_open)
			if(cell)
				to_chat(user, "The panel is open, exposing the [cell].")
			else
				to_chat(user, "The panel is open.")

		if (cell)
			to_chat(user, "The charge meter reads [round(cell.percent())]%.")
		else
			to_chat(user, "It doesn't have a power cell installed.")
