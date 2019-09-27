/obj/item/weapon/gun/projectile/shotgun
	name = "shotgun"
	desc = "Useful for sweeping alleys."
	icon = 'icons/obj/guns/projectile/shotguns.dmi'
	icon_state = "shotgun"
	item_state = "shotgun"
	w_class = ITEM_SIZE_LARGE
	lefthand_file = 'icons/mob/inhands/shotguns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/shotguns_righthand.dmi'
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = "combat=4;materials=2"
	mag_type = /obj/item/ammo_box/magazine/internal/shot
	twohands_required = TRUE
	var/recentpump = 0 // to prevent spammage
	var/pumped = 0
	fire_sound =  'sound/weapons/guns/station/shotgun_shot1.ogg'
	var/pump_sound = 'sound/weapons/shotgunpump.ogg'

/obj/item/weapon/gun/projectile/shotgun/isHandgun()
	return FALSE

/obj/item/weapon/gun/projectile/shotgun/update_icon()
	if(wielded)
		item_state = "[initial(icon_state)]_wield"
	else
		item_state = "[initial(icon_state)]"

/obj/item/weapon/gun/projectile/shotgun/attackby(obj/item/A, mob/user)
	var/num_loaded = magazine.attackby(A, user, 1)
	if(num_loaded)
		to_chat(user, "<span class='notice'>You load [num_loaded] shell\s into \the [src]!</span>")
		A.update_icon()
		update_icon()

/obj/item/weapon/gun/projectile/shotgun/process_chamber()
	return ..(0, 0)

/obj/item/weapon/gun/projectile/shotgun/chamber_round()
	return

/obj/item/weapon/gun/projectile/shotgun/attack_self(mob/living/user)
	if(recentpump)	return
	pump(user)
	recentpump = 1
	spawn(10)
		recentpump = 0
	return

/obj/item/weapon/gun/projectile/shotgun/proc/pump(mob/M)
	playsound(M, pump_sound, 60, 1)
	pumped = 0
	if(chambered)//We have a shell in the chamber
		chambered.loc = get_turf(src)//Eject casing
		chambered.SpinAnimation(5, 1)
		chambered = null
	if(!magazine.ammo_count())	return 0
	var/obj/item/ammo_casing/AC = magazine.get_round() //load next casing.
	chambered = AC
	update_icon()	//I.E. fix the desc
	return 1

/obj/item/weapon/gun/projectile/shotgun/examine(mob/user)
	..()
	if (chambered)
		to_chat(user, "A [chambered.BB ? "live" : "spent"] one is in the chamber.")

/obj/item/weapon/gun/projectile/shotgun/combat
	name = "combat shotgun"
	icon_state = "cshotgun"
	origin_tech = "combat=5;materials=2"
	mag_type = /obj/item/ammo_box/magazine/internal/shotcom
	w_class = ITEM_SIZE_HUGE

/obj/item/weapon/gun/projectile/revolver/doublebarrel
	name = "double-barreled shotgun"
	desc = "A true classic."
	icon = 'icons/obj/guns/projectile/shotguns.dmi'
	icon_state = "dshotgun"
	item_state = "dshotgun"
	lefthand_file = 'icons/mob/inhands/shotguns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/shotguns_righthand.dmi'
	w_class = ITEM_SIZE_LARGE
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = "combat=3;materials=1"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/dualshot
	var/open = 0
	var/short = 0
	lefthand_file = 'icons/mob/inhands/shotguns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/shotguns_righthand.dmi'
	fire_sound = 'sound/weapons/guns/station/shotgun_shot1.ogg'
	twohands_required = TRUE

/obj/item/weapon/gun/projectile/revolver/doublebarrel/isHandgun()
	return FALSE

/obj/item/weapon/gun/projectile/revolver/doublebarrel/update_icon()
	if(short)
		icon_state = "sawnshotgun[open ? "-o" : ""]"
	else
		icon_state = "dshotgun[open ? "-o" : ""]"
	if(wielded)
		item_state = "[initial(icon_state)]_wield"
	else
		item_state = "[initial(icon_state)]"

/obj/item/weapon/gun/projectile/revolver/doublebarrel/attackby(obj/item/A, mob/user)
	if(open)
		..()
	else
		to_chat(user, "<span class='notice'>You can't load shell while [src] is closed!</span>")
	if(istype(A, /obj/item/weapon/circular_saw) || istype(A, /obj/item/weapon/melee/energy) || istype(A, /obj/item/weapon/pickaxe/plasmacutter))
		if(short) return
		to_chat(user, "<span class='notice'>You begin to shorten the barrel of \the [src].</span>")
		if(get_ammo())
			afterattack(user, user)	//will this work?
			afterattack(user, user)	//it will. we call it twice, for twice the FUN
			playsound(user, fire_sound, 50, 1)
			user.visible_message("<span class='danger'>The shotgun goes off!</span>", "<span class='danger'>The shotgun goes off in your face!</span>")
			return
		if(!user.is_busy() && do_after(user, 30, target = src))	//SHIT IS STEALTHY EYYYYY
			icon_state = "sawnshotgun[open ? "-o" : ""]"
			w_class = ITEM_SIZE_NORMAL
			twohands_required = FALSE
			item_state = "gun"
			slot_flags &= ~SLOT_BACK	//you can't sling it on your back
			slot_flags |= SLOT_BELT		//but you can wear it on your belt (poorly concealed under a trenchcoat, ideally)
			to_chat(user, "<span class='warning'>You shorten the barrel of \the [src]!</span>")
			name = "sawn-off shotgun"
			desc = "Omar's coming!"
			short = 1

/obj/item/weapon/gun/projectile/revolver/doublebarrel/attack_self(mob/living/user)
	add_fingerprint(user)
	open = !open
	if(open)
		//playsound(src.loc, 'sound/weapons/heavybolt_out.ogg', 50, 1)
		var/num_unloaded = 0
		while (get_ammo() > 0)
			spawn(3)
				playsound(src.loc, 'sound/weapons/shell_drop.ogg', 50, 1)
			var/obj/item/ammo_casing/CB
			CB = magazine.get_round(0)
			chambered = null
			CB.loc = get_turf(src.loc)
			CB.SpinAnimation(5, 1)
			CB.update_icon()
			num_unloaded++
		if (num_unloaded)
			to_chat(user, "<span class = 'notice'>You break open \the [src] and unload [num_unloaded] shell\s.</span>")
		else
			to_chat(user, "<span class = 'notice'>You break open \the [src].</span>")

	update_icon()

/obj/item/weapon/gun/projectile/revolver/doublebarrel/special_check(mob/user)
	if(open)
		to_chat(user, "<span class='warning'>You can't fire [src] while its open!</span>")
		return FALSE
	return ..()

/obj/item/weapon/gun/projectile/shotgun/combat/military
	name = "combat shotgun"
	icon_state = "shotgun"
	bypass_icon = "bypass/gun/military.dmi"
	pump_sound = 'sound/weapons/guns/military/shotgun_pump.ogg'
	fire_sound = 'sound/weapons/guns/military/shotgun_shot.ogg'


/obj/item/weapon/gun/projectile/revolver/doublebarrel/quake
	name = "relic double-barreled weapon"
	desc = "A weird gun that looks like overcomplicated double-barreled shotgun"
	bypass_icon = "bypass/gun/relics.dmi"
	fire_sound = 'sound/weapons/guns/quake/shotgun_shot1.ogg'
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/dualshot/quake