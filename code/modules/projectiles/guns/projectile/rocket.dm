/obj/item/weapon/gun/projectile/revolver/rocketlauncher
	name = "Goliath missile launcher"
	desc = "The Goliath is a single-shot shoulder-fired multipurpose missile launcher."
	icon_state = "rocket"
	item_state = "rocket"
	w_class = 4.0
	force = 5
	flags =  CONDUCT
	origin_tech = "combat=8;materials=5"
	slot_flags = 0
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/rocket
	fire_sound = 'sound/effects/bang.ogg'

/obj/item/weapon/gun/projectile/revolver/rocketlauncher/isHandgun()
	return 0

/obj/item/weapon/gun/projectile/revolver/rocketlauncher/process_chamber()
	return ..(1, 1)

/obj/item/weapon/gun/projectile/revolver/rocketlauncher/attack_hand(mob/user)
	if(loc != user)
		..()
		return	//let them pick it up
	var/num_unloaded = 0
	while (get_ammo() > 0)
		var/obj/item/ammo_casing/CB
		CB = magazine.get_round(0)
		chambered = null
		CB.loc = get_turf(src.loc)
		CB.SpinAnimation(10, 1)
		CB.update_icon()
		num_unloaded++
	if (num_unloaded)
		to_chat(user, "<span class = 'notice'>You unload [num_unloaded] missile\s from [src].</span>")
	else
		to_chat(user, "<span class='notice'>[src] is empty.</span>")

/obj/item/weapon/gun/projectile/revolver/rocketlauncher/afterattack(atom/target, mob/living/user, flag, params) //what I tried to do here is just add a check to see if the cover is open or not and add an icon_state change because I can't figure out how c-20rs do it with overlays
	..()
	if(chambered)
		qdel(chambered)
		chambered = null
