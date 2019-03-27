/obj/vehicle/segway
	name = "segway"
	desc = "two-wheeled vehicle of fashion, WOAH!"
	icon_state = "segway"
	dir = SOUTH

	load_item_visible = 1
	mob_offset_y = 5
	health = 100
	maxhealth = 100
	on = 1
	can_pull = 1
	anchored = 0
	layer = MOB_LAYER + 2
	airlock_automatic_opening = 1

	fire_dam_coeff = 0.75
	brute_dam_coeff = 0.65
	var/protection_percent = 60

	var/land_speed = 1.5
	var/space_speed = 0

	var/step_energy_drain = 5
	var/obj/item/weapon/stock_parts/cell/powercell = null

/obj/vehicle/segway/load(mob/living/M)
	if(!istype(M))
		return FALSE
	if(M.buckled || M.incapacitated() || M.lying || !Adjacent(M) || !M.Adjacent(src))
		return FALSE
	. = ..()
	if( . )
		M.layer = layer - 0.9
	return

/obj/vehicle/segway/MouseDrop_T(mob/living/M, mob/living/user)
	if(!istype(user, /mob/living/carbon/human) || !istype(M, /mob/living/carbon/human))
		return
	if(isessence(user))
		return
	if(user.incapacitated() || user.lying)
		return
	if(!load(M))
		to_chat(user, "<span class='warning'>You were unable to load \the [M] onto \the [src].</span>")
		return

/obj/vehicle/segway/atom_init()
	. = ..()
	overlays += image('icons/obj/vehicles.dmi', "[icon_state]_overlay", MOB_LAYER + 1)
	turn_off()

/obj/vehicle/segway/relaymove(mob/user, direction)
	if(user.stat || user.stunned || user.weakened || user.paralysis)
		unload(user)
		return
	if(open || !(powercell && powercell.charge >= step_energy_drain))
		return

	. = Move(get_step(src, direction))
	if(.)
		powercell.charge = max(0, powercell.charge - step_energy_drain)
	user.dir = dir

/obj/vehicle/segway/Move(var/turf/destination)
	if(istype(destination,/turf/space))
		if(!space_speed)
			return 0
		move_delay = space_speed + slow_cooef
	else
		if(!land_speed)
			return 0
		move_delay = land_speed + slow_cooef
	return ..()

/obj/vehicle/segway/attack_hand(mob/user)
	if(!load)
		return
	user.SetNextMove(CLICK_CD_MELEE)
	if(load != user)
		if(do_after(user, 20, target=src))
			load.visible_message(\
				"<span class='notice'>[load.name] was unbuckled by [user.name]!</span>",\
				"<span class='warning'>You were unbuckled from [src] by [user.name].</span>",\
				"<span class='notice'>You hear metal clanking.</span>")
			unload(load)
	else
		load.visible_message(\
			"<span class='notice'>[load.name] unbuckled \himself!</span>",\
			"<span class='notice'>You unbuckle yourself from [src].</span>",\
			"<span class='notice'>You hear metal clanking.</span>")
		unload(load)

/obj/vehicle/segway/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/stock_parts/cell) && !powercell && open)
		user.drop_item()
		W.forceMove(src)
		powercell = W
		user.visible_message("[user] inserts a cell into the [name].", "You insert a cell into the [name].")
		turn_on()
		return
	if(istype(W, /obj/item/weapon/crowbar))
		if(open && powercell)
			powercell.forceMove(loc)
			powercell = null
			user.visible_message("[user] removes the cell from the [name].", "You remove the cell from the [name].")
			turn_off()
			return
	return ..()

/obj/vehicle/segway/examine(mob/user)
	..()
	to_chat(user, " [open ? "Maintenance panel is open. " : "Maintenance panel is closed. "] [ open && !powercell ? "Powercell is missing. " : "" ]")

/obj/vehicle/segway/turn_on()
	light_power = 3
	return ..()

/obj/vehicle/segway/turn_off()
	light_power = 0
	..()