/obj/item/weapon/gun/projectile/automatic/twohanded/can_be_wielded()
	return TRUE

/obj/item/weapon/gun/projectile/automatic/twohanded/l10c
	name = "L10-c"
	desc = "A basic energy-based carbine with fast rate of fire."
	icon_state = "l10-car"
	item_state = "l10-car"
	wielded_state = "l10"
	w_class = 4.0
	origin_tech = "combat=3;magnets=2"
	mag_type = /obj/item/ammo_box/magazine/l10mag
	fire_sound = 'sound/weapons/guns/l10c-shot.ogg'
	recoil = 0
	energy_gun = 1

/obj/item/weapon/gun/projectile/automatic/twohanded/l10c/atom_init()
	. = ..()
	update_icon()

/obj/item/weapon/gun/projectile/automatic/twohanded/l10c/process_chamber()
	return ..(0, 1, 1)

/obj/item/weapon/gun/projectile/automatic/twohanded/l10c/afterattack(atom/target, mob/living/user, flag)
	..()
	update_icon(user)
	return

/obj/item/weapon/gun/projectile/automatic/twohanded/l10c/attack_hand(mob/user)
	if(loc != usr)//Pick it up
		..()
	if(magazine && magazine.ammo_count())
		playsound(user, 'sound/weapons/guns/l10c-unload.ogg', 70, 1)
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

/obj/item/weapon/gun/projectile/automatic/twohanded/l10c/attackby(obj/item/A, mob/user)
	if (istype(A, /obj/item/ammo_box/magazine))
		var/obj/item/ammo_box/magazine/AM = A
		if (!magazine && istype(AM, mag_type))
			user.remove_from_mob(AM)
			magazine = AM
			magazine.loc = src
			to_chat(user, "<span class='notice'>You load a new magazine into \the [src].</span>")
			if(AM.ammo_count())
				playsound(user, 'sound/weapons/guns/l10c-load.ogg', 70, 1)
			chamber_round()
			A.update_icon()
			update_icon(user)
			return 1
		else if (magazine)
			to_chat(user, "<span class='notice'>There's already a magazine in \the [src].</span>")
	..()

/obj/item/weapon/gun/projectile/automatic/twohanded/l10c/update_icon(mob/M)
	if(!magazine)
		icon_state = "[initial(icon_state)]-e"
		item_state = "[initial(item_state)]-e"
	else if(chambered)
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(item_state)]"
	else if(magazine && magazine.ammo_count())
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(item_state)]"
	else
		icon_state = "[initial(icon_state)]-0"
		item_state = "[initial(item_state)]-0"
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_inv_l_hand()
		H.update_inv_r_hand()
		H.update_inv_belt()
	return

/obj/item/weapon/gun/projectile/automatic/twohanded/tommygun
	name = "tommy gun"
	desc = "A genuine Chicago Typewriter."
	icon_state = "tommygun"
	item_state = "tommygun"
	slot_flags = 0
	origin_tech = "combat=5;materials=1;syndicate=2"
	mag_type = /obj/item/ammo_box/magazine/tommygunm45
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'

/obj/item/weapon/gun/projectile/automatic/twohanded/tommygun/isHandgun()
	return 0

/obj/item/weapon/gun/projectile/automatic/twohanded/bar
	name = "Browning M1918"
	desc = "Browning Automatic Rifle."
	icon_state = "bar"
	item_state = "bar"
	w_class = 5.0
	origin_tech = "combat=5;materials=2"
	mag_type = /obj/item/ammo_box/magazine/m3006
	fire_sound = 'sound/weapons/gunshot3.wav'


/obj/item/weapon/gun/projectile/automatic/twohanded/bulldog
	name = "V15 Bulldog shotgun"
	desc = "A compact, mag-fed semi-automatic shotgun for combat in narrow corridors. Compatible only with specialized magazines."
	icon_state = "bulldog"
	item_state = "bulldog"
	w_class = 3.0
	origin_tech = "combat=5;materials=4;syndicate=6"
	mag_type = /obj/item/ammo_box/magazine/m12g
	fire_sound = 'sound/weapons/Gunshot.ogg'

/obj/item/weapon/gun/projectile/automatic/twohanded/bulldog/atom_init()
	. = ..()
	update_icon()

/obj/item/weapon/gun/projectile/automatic/twohanded/bulldog/proc/update_magazine()
	if(magazine)
		src.overlays = 0
		overlays += "[magazine.icon_state]_o"
		return

/obj/item/weapon/gun/projectile/automatic/twohanded/bulldog/update_icon()
	src.overlays = 0
	update_magazine()
	icon_state = "bulldog[chambered ? "" : "-e"]"
	return

/obj/item/weapon/gun/projectile/automatic/twohanded/bulldog/afterattack(atom/target, mob/living/user, flag)
	..()
	if(!chambered && !get_ammo() && !alarmed)
		playsound(user, 'sound/weapons/smg_empty_alarm.ogg', 40, 1)
		update_icon()
		alarmed = 1
	return

/obj/item/weapon/gun/projectile/automatic/twohanded/a28
	name = "A28 assault rifle"
	desc = ""
	icon_state = "a28"
	item_state = "a28"
	w_class = 3.0
	origin_tech = "combat=5;materials=4;syndicate=6"
	mag_type = /obj/item/ammo_box/magazine/m556
	fire_sound = 'sound/weapons/Gunshot.ogg'

/obj/item/weapon/gun/projectile/automatic/twohanded/a28/atom_init()
	. = ..()
	update_icon()

/obj/item/weapon/gun/projectile/automatic/twohanded/a28/update_icon()
	overlays.Cut()
	if(magazine)
		overlays += "[magazine.icon_state]-o"
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"
	return

/obj/item/weapon/gun/projectile/automatic/twohanded/a74
	name = "A74 assault rifle"
	desc = "Stradi and Practican Maid Bai Spess soviets corporation, bazed he original design of 20 centuriyu fin about baars and vodka vile patrimonial it, saunds of balalaika place minvile, yuzes 7.74 caliber"
	mag_type = /obj/item/ammo_box/magazine/a74mm
	w_class = 3.0
	icon_state = "a74"
	item_state = "a74"
	origin_tech = "combat=5;materials=4;syndicate=6"
	fire_sound = 'sound/weapons/guns/ak74_fire.ogg'
	var/icon/mag_icon = icon('icons/obj/gun.dmi',"mag-a74")

/obj/item/weapon/gun/projectile/automatic/twohanded/a74/atom_init()
	. = ..()
	update_icon()

/obj/item/weapon/gun/projectile/automatic/twohanded/a74/update_icon()
	overlays.Cut()
	if(magazine)
		overlays += mag_icon
		item_state = "[initial(icon_state)]"
	else
		item_state = "[initial(icon_state)]-e"

/obj/item/weapon/gun/projectile/automatic/twohanded/a74/attack_hand(mob/user)
	if(..())
		playsound(user, 'sound/weapons/guns/ak74_reload.ogg', 50, 1)
		update_icon()

/obj/item/weapon/gun/projectile/automatic/twohanded/a74/attackby(obj/item/A, mob/user)
	if(..())
		playsound(user, 'sound/weapons/guns/ak74_reload.ogg', 50, 1)
	update_icon()

/obj/item/weapon/gun/projectile/automatic/twohanded/l6_saw
	name = "\improper L6 SAW"
	desc = "A heavily modified light machine gun with a tactical plasteel frame resting on a rather traditionally-made ballistic weapon. Has 'Aussec Armoury - 2531' engraved on the reciever, as well as '7.62x51mm'."
	icon_state = "l6closed100"
	item_state = "l6closedmag"
	wielded_state = "l6"
	w_class = 5
	slot_flags = 0
	origin_tech = "combat=5;materials=1;syndicate=2"
	mag_type = /obj/item/ammo_box/magazine/m762
	fire_sound = 'sound/weapons/gunshot3.wav'

/obj/item/weapon/gun/projectile/automatic/twohanded/l6_saw/update_icon()
	icon_state = "l6[magazine ? ceil(get_ammo(0) / 12.5) * 25 : "-empty"]"

/obj/item/weapon/gun/projectile/automatic/twohanded/l6_saw/attack_hand(mob/user)
	if(loc != user)
		..()
		return	//let them pick it up
	if(!magazine)
		..()
	else if(magazine)
		//drop the mag
		magazine.update_icon()
		magazine.loc = get_turf(src.loc)
		user.put_in_hands(magazine)
		magazine = null
		update_icon()
		to_chat(user, "<span class='notice'>You remove the magazine from [src].</span>")

/obj/item/weapon/gun/projectile/automatic/twohanded/tommygun
	name = "thompson SMG"
	desc = "Based on the classic 'Chicago Typewriter'."
	icon_state = "tommygun"
	item_state = "shotgun"
	w_class = 5
	slot_flags = 0
	origin_tech = "combat=5;materials=1;syndicate=2"
	mag_type = /obj/item/ammo_box/magazine/tommygunm45
	fire_sound = 'sound/weapons/Gunshot_smg.ogg'
	//can_suppress = 0
 	//burst_size = 4
 	//fire_delay = 1