/obj/item/ammo_box/a357
	name = "ammo box (.357)"
	desc = "A box of .357 ammo"
	icon_state = "357"
	ammo_type = /obj/item/ammo_casing/a357
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_box/c9mm
	name = "Ammunition Box (9mm)"
	icon_state = "9mm"
	origin_tech = "combat=2"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 30

/obj/item/ammo_box/c45
	name = "Ammunition Box (.45)"
	icon_state = "9mm"
	origin_tech = "combat=2"
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 30

/obj/item/ammo_box/a12mm
	name = "Ammunition Box (12mm)"
	icon_state = "9mm"
	origin_tech = "combat=2"
	ammo_type = /obj/item/ammo_casing/a12mm
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_box/shotgun
	name = "shotgun shells box (buckshot)"
	icon_state = "12gbuckshot"
	w_class = 3
	origin_tech = "combat=2"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	max_ammo = 20

/obj/item/ammo_box/shotgun/slug
	name = "shotgun shells box  (slug)"
	icon_state = "45box"
	ammo_type = /obj/item/ammo_casing/shotgun

/obj/item/ammo_box/shotgun/beanbag
	name = "shotgun shells box (beanbag)"
	icon_state = "12gbeanbang"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag

/obj/item/ammo_box/fancy
	name = "Ammunition Box (6.8mm)"
	desc = "A box of 6.8 x 43 mm ammo"
	icon_state = "ammobox"
	origin_tech = "combat=2"
	w_class = ITEM_SIZE_NORMAL
	slot_flags = 0
	ammo_type = /obj/item/ammo_casing/a68
	caliber = "6.8mm"
	max_ammo = 60

/obj/item/ammo_box/fancy/update_icon()
	if(stored_ammo.len == max_ammo)
		icon_state = "[initial(icon_state)]"
	else if(!stored_ammo.len)
		icon_state = "[initial(icon_state)]-open"
	else
		icon_state = "[initial(icon_state)]-open-full"
		desc = "[initial(desc)] There are [stored_ammo.len] shell\s left!"

/obj/item/ammo_box/fancy/shotgun
	name = "Ammunition Box (12 gauge buckshot)"
	desc = "A box of 12 gauge buckshots"
	icon_state = "shotgunbox"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	caliber = "shotgun"
	max_ammo = 24