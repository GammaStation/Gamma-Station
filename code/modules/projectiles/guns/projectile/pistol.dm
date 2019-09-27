/obj/item/weapon/gun/projectile/pistol
	name = "pistol"
	desc = "A small, easily concealable gun for civic self-defense. Uses 9mm rounds."
	icon = 'icons/obj/guns/projectile/pistols.dmi'
	icon_state = "pistol"
	item_state = "pistol"
	lefthand_file = 'icons/mob/inhands/pistols_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/pistols_righthand.dmi'
	w_class = ITEM_SIZE_SMALL
	origin_tech = "combat=2;materials=2"
	mag_type = /obj/item/ammo_box/magazine/m9mm_pistol

/obj/item/weapon/gun/projectile/pistol/isHandgun()
	return TRUE

/obj/item/weapon/gun/projectile/pistol/update_icon()
	overlays.Cut()
	if(magazine)
		overlays += image(icon, "[initial(icon_state)]-mag")
	icon_state = "[initial(icon_state)][(!chambered) ? "-e" : ""]"

/obj/item/weapon/gun/projectile/pistol/colt1911
	desc = "A cheap Martian knock-off of a Colt M1911. Uses less-than-lethal .45 rounds."
	name = "Colt M1911"
	icon_state = "colt1911"
	item_state = "colt"
	mag_type = /obj/item/ammo_box/magazine/colt_45c
	fire_sound = 'sound/weapons/guns/station/colt1911_shot.ogg'

/obj/item/weapon/gun/projectile/pistol/colt1911/detective  //Only for start with rubber bullets
	magazine = /obj/item/ammo_box/magazine/colt_45c/rubber

/obj/item/weapon/gun/projectile/pistol/colt1911/detective/verb/rename_gun()
	set name = "Name Gun"
	set category = "Object"
	set desc = "Click to rename your gun."

	var/mob/M = usr
	var/input = sanitize_safe(input(M,"What do you want to name the gun?"), MAX_NAME_LEN)

	if(src && input && !M.incapacitated())
		name = input
		to_chat(M, "You name the gun [input]. Say hello to your new friend.")

/obj/item/weapon/gun/projectile/pistol/syndicate
	name = "\improper Stechkin pistol"
	desc = "A small, easily concealable gun. Uses 9mm rounds."
	icon_state = "syndie"
	silenced = FALSE
	origin_tech = "combat=2;materials=2;syndicate=2"
	mag_type = /obj/item/ammo_box/magazine/m9mm_pistol
	fire_sound = 'sound/weapons/guns/station/pistol_shot1.ogg'

/obj/item/weapon/gun/projectile/pistol/syndicate/attack_hand(mob/user)
	if(loc == user)
		if(silenced)
			silencer_attack_hand(user)
	..()

/obj/item/weapon/gun/projectile/pistol/syndicate/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/silencer))
		silencer_attackby(I,user)
	..()

/obj/item/weapon/gun/projectile/pistol/syndicate/update_icon()
	..()
	if(silenced)
		overlays += image(icon, "[initial(icon_state)]-silencer")

/obj/item/weapon/gun/projectile/pistol/sec_pistol
	name = "security pistol"
	desc = "A W&J Company designed WJ P250, found pretty much everywhere humans are. Uses 9mm rounds."
	icon_state = "wjp250"
	item_state = "wjp250"
	mag_type = /obj/item/ammo_box/magazine/m9mm_pistol
	fire_sound = 'sound/weapons/Gunshot.ogg'
	magazine = /obj/item/ammo_box/magazine/m9mm_pistol/rubber

/obj/item/weapon/gun/projectile/pistol/sec_pistol/thunderfield_pistol //Thunderfield stuff
	name = "\improper self-defense pistol"
	desc = ".22CB pistol"
	mag_type = /obj/item/ammo_box/magazine/c22cb

/obj/item/weapon/gun/projectile/pistol/sec_pistol/spec
	name = "P250"
	desc = "A W&J Company designed WJ P250, this one has a military coloring. Uses 9mm rounds."
	icon_state = "wjp250special"
	item_state = "wjp250special"
	magazine = /obj/item/ammo_box/magazine/m9mm_pistol

/obj/item/weapon/gun/projectile/pistol/deagle
	name = "desert eagle"
	desc = "A robust handgun that uses .50 AE ammo."
	icon_state = "deagle"
	item_state = "deagle"
	force = 14
	mag_type = /obj/item/ammo_box/magazine/m50
	fire_sound = 'sound/weapons/guns/station/deagle_shot.ogg'

/obj/item/weapon/gun/projectile/pistol/deagle/gold
	desc = "A gold plated gun folded over a million times by superior martian gunsmiths. Uses .50 AE ammo."
	icon_state = "deagleg"
	item_state = "deagleg"

/*
/obj/item/weapon/gun/projectile/sec_pistol
	name = "\improper pistol"
	desc = "AT-7 .45 caliber pistol."
	icon_state = "at7"
	fire_sound = 'sound/weapons/guns/at7_shot.wav'
	mag_type = /obj/item/ammo_box/magazine/at7_45
*/

/*
/obj/item/weapon/gun/projectile/sec_pistol/atom_init()
	. = ..()
	update_icon()

/obj/item/weapon/gun/projectile/sec_pistol/isHandgun()
	return 1

/obj/item/weapon/gun/projectile/sec_pistol/update_magazine()
	if(magazine)
		src.overlays = 0
		overlays += image('icons/obj/gun.dmi', "at7-mag")
		return

/obj/item/weapon/gun/projectile/sec_pistol/update_icon(load = 0)
	src.overlays = 0
	update_magazine()
	if(load)
		icon_state = "[initial(icon_state)]"
		return
	icon_state = "[initial(icon_state)][(!chambered && !get_ammo()) ? "-e" : ""]"
	return

/obj/item/weapon/gun/projectile/sec_pistol/attackby(obj/item/A, mob/user)
	if (istype(A, /obj/item/ammo_box/magazine))
		var/obj/item/ammo_box/magazine/AM = A
		if (!magazine && istype(AM, mag_type))
			user.remove_from_mob(AM)
			magazine = AM
			magazine.loc = src
			to_chat(user, "<span class='notice'>You load a new magazine into \the [src].</span>")
			chamber_round()
			A.update_icon()
			update_icon(1)
			return 1
		else if (magazine)
			to_chat(user, "<span class='notice'>There's already a magazine in \the [src].</span>")
	return 0

/obj/item/weapon/gun/projectile/sec_pistol/acm38
	name = "\improper pistol"
	desc = "Seegert ACM38 pistol - when you need be TACTICOOL."
	icon_state = "acm38"
	item_state = "colt"
	fire_sound = 'sound/weapons/guns/acm38_shot.ogg'
	mag_type = /obj/item/ammo_box/magazine/acm38_38

/obj/item/weapon/gun/projectile/sec_pistol/update_icon(load = 0)
	if(load)
		icon_state = "[initial(icon_state)]"
		return
	icon_state = "[initial(icon_state)][(!chambered && !get_ammo()) ? "-e" : ""]"
	return
*/