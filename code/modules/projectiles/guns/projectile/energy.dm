/obj/item/weapon/gun/projectile/automatic/plasma_rifle
	name = "plasma rifle"
	desc = "A Vektor T-11 - a UN-standard issued plasma rifle."
	icon_state = "plasma"
	item_state = "plasma"
	bypass_icon = "bypass/gun/military.dmi"
	w_class = ITEM_SIZE_LARGE
	origin_tech = "combat=3;magnets=2"
	twohands_required = TRUE
	slot_flags = SLOT_BACK
	burst_mode = TRUE
	burst_amount = 3
	burst_delay = 6

	mag_type = /obj/item/ammo_box/magazine/plasma_mag
	fire_sound = 'sound/weapons/guns/military/plasma_shot1.ogg'
	recoil = 0
	energy_gun = 1

/obj/item/weapon/gun/projectile/automatic/plasma_rifle/atom_init()
	. = ..()
	update_icon()

/obj/item/weapon/gun/projectile/automatic/plasma_rifle/update_icon()
	..()
	icon_state = "[initial(icon_state)][magazine ? "" : "-e"]"
	if(wielded)
		item_state = "[initial(item_state)]_wield"
	else
		item_state = "[initial(item_state)]"


/obj/item/weapon/gun/projectile/automatic/plasma_rifle/CtrlClick(mob/user)
	if(loc == user)
		burst_mode = !burst_mode
		to_chat(user, "<span class='notice'>You switch \the [src] to [burst_mode ? "burst mode" : "single mode"].</span>")
	else
		..()

/obj/item/weapon/gun/projectile/automatic/plasma_rifle/process_chamber()
	return ..(0, 1, 1)

/obj/item/weapon/gun/projectile/automatic/plasma_rifle/attack_self(mob/user)
	if(chambered)
		var/obj/item/ammo_casing/AC = chambered //Find chambered round
		qdel(AC)
		chambered = null
		magazine.stored_ammo += new magazine.ammo_type(magazine)
	if (magazine)
		magazine.loc = get_turf(src.loc)
		user.put_in_hands(magazine)
		magazine.update_icon()
		magazine = null
		to_chat(user, "<span class='notice'>You pull the magazine out of \the [src]!</span>")
	else
		to_chat(user, "<span class='notice'>There's no magazine in \the [src].</span>")
	update_icon(user)
	return

/obj/item/weapon/gun/projectile/automatic/plasma_rifle/attackby(obj/item/A, mob/user)
	if (istype(A, /obj/item/ammo_box/magazine))
		var/obj/item/ammo_box/magazine/AM = A
		if (!magazine && istype(AM, mag_type))
			user.remove_from_mob(AM)
			magazine = AM
			magazine.loc = src
			to_chat(user, "<span class='notice'>You load a new magazine into \the [src].</span>")
			chamber_round()
			A.update_icon()
			update_icon(user)
			return 1
		else if (magazine)
			to_chat(user, "<span class='notice'>There's already a magazine in \the [src].</span>")
	return 0
