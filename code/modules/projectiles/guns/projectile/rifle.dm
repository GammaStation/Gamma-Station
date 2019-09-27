/obj/item/weapon/gun/projectile/automatic/assault_rifle
	name = "assault rifle"
	desc = "The rugged STS-35 is a durable automatic weapon of a make popular on the frontier worlds. The serial number has been scratched off."
	icon = 'icons/obj/guns/projectile/rifles.dmi'
	icon_state = "rifle"
	item_state = "rifle"
	lefthand_file = 'icons/mob/inhands/rifles_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/rifles_righthand.dmi'
	w_class = ITEM_SIZE_LARGE
	twohands_required = TRUE
	slot_flags = SLOT_BACK
	origin_tech = "combat=5;materials=4"
	burst_delay = 4
	fire_sound = 'sound/weapons/guns/station/rifle_shot1.ogg'
	load_sound = 'sound/weapons/guns/station/rifle_load.ogg'
	unload_sound = 'sound/weapons/guns/station/rifle_unload.ogg'

/obj/item/weapon/gun/projectile/automatic/assault_rifle/atom_init()
	. = ..()
	update_icon()


/obj/item/weapon/gun/projectile/automatic/assault_rifle/update_icon()
	..()
	overlays.Cut()
	if(magazine)
		overlays += image(icon, "[initial(icon_state)]-mag")
	icon_state = "[initial(icon_state)][(!chambered) ? "-e" : ""]"
	if(wielded)
		item_state = "[initial(icon_state)][magazine ? "" : "-e"]_wield"
	else
		item_state = "[initial(icon_state)][magazine ? "" : "-e"]"

/obj/item/weapon/gun/projectile/automatic/assault_rifle/a28
	name = "A28 assault rifle"
	desc = ""
	icon_state = "a28"
	item_state = "a28"
	slot_flags = 0
	mag_type = /obj/item/ammo_box/magazine/m68mm/type2
	fire_sound = 'sound/weapons/guns/station/rifle_shot2.ogg'
/*
/obj/item/weapon/gun/projectile/automatic/a28/atom_init()
	. = ..()
	update_icon()

/obj/item/weapon/gun/projectile/automatic/a28/update_icon()
	overlays.Cut()
	if(magazine)
		overlays += "[magazine.icon_state]-o"
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"
	return
*/

/obj/item/weapon/gun/projectile/automatic/assault_rifle/military
	name = "assault rifle"
	desc = ""
	bypass_icon = "bypass/gun/military.dmi"

	mag_type = /obj/item/ammo_box/magazine/m68mm
	fire_sound = 'sound/weapons/guns/military/rifle_shot.ogg'
	load_sound = 'sound/weapons/guns/military/rifle_load.ogg'
	unload_sound = 'sound/weapons/guns/military/rifle_unload.ogg'

/obj/item/weapon/gun/projectile/automatic/assault_rifle/military/carbine
	name = "carbine"
	bypass_icon = "bypass/gun/military.dmi"
	icon_state = "carbine"
	item_state = "carbine"
	w_class = ITEM_SIZE_NORMAL
	fire_sound = 'sound/weapons/guns/military/carbine_fire.ogg'