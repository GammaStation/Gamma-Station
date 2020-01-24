/obj/item/weapon/shield
	name = "shield"
	var/block_chance = 65

/obj/item/weapon/shield/riot
	name = "riot shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "riot"
	flags = CONDUCT
	slot_flags = SLOT_BACK
	force = 5.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = 4.0
	g_amt = 7500
	m_amt = 1000
	origin_tech = "materials=2"
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time

	Get_shield_chance()
		return block_chance

	attackby(obj/item/weapon/W, mob/user)
		if(istype(W, /obj/item/weapon/melee/baton))
			if(cooldown < world.time - 25)
				user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
				playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
				cooldown = world.time
		else
			..()

/obj/item/weapon/shield/energy
	name = "energy combat shield"
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "eshield0" // eshield1 for expanded
	flags = CONDUCT
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = 2
	block_chance = 30
	origin_tech = "materials=4;magnets=3;syndicate=4"
	attack_verb = list("shoved", "bashed")
	var/active = 0
	var/emp_cooldown = 0

/obj/item/weapon/shield/energy/IsReflect(def_zone, hol_dir, hit_dir)
	if(active)
		return is_the_opposite_dir(hol_dir, hit_dir)
	return FALSE

/obj/item/weapon/shield/energy/emp_act(severity)
	if(active)
		if(severity == 2 && prob(35))
			active = !active
			emp_cooldown = world.time + 200
			turn_off()
		else if(severity == 1)
			active = !active
			emp_cooldown = world.time + rand(200, 400)
			turn_off()


/obj/item/weapon/shield/riot/tele
	name = "telescopic shield"
	desc = "An advanced riot shield made of lightweight materials that collapses for easy storage."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "teleriot0"
	origin_tech = "materials=3;combat=4;engineering=4"
	slot_flags = null
	force = 3
	throwforce = 3
	throw_speed = 3
	throw_range = 4
	block_chance = 50
	var/active = 0

/obj/item/weapon/shield/riot/tele/Get_shield_chance()
	if(active)
		return block_chance
	return 0

/obj/item/weapon/shield/riot/tele/attack_self(mob/living/user)
	active = !active
	icon_state = "teleriot[active]"
	playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, 1)

	if(active)
		force = 8
		throwforce = 5
		throw_speed = 2
		w_class = 4
		slot_flags = SLOT_BACK
		to_chat(user, "<span class='notice'>You extend \the [src].</span>")
	else
		force = 3
		throwforce = 3
		throw_speed = 3
		w_class = 3
		slot_flags = null
		to_chat(user, "<span class='notice'>[src] can now be concealed.</span>")
	add_fingerprint(user)

/obj/item/weapon/shield/riot/roman
	name = "roman shield"
	desc = "Bears an inscription on the inside: <i>\"Romanes venio domus\"</i>."
	icon_state = "roman_shield"
	item_state = "roman_shield"

/*
/obj/item/weapon/cloaking_device
	name = "cloaking device"
	desc = "Use this to become invisible to the human eyesocket."
	icon = 'icons/obj/device.dmi'
	icon_state = "shield0"
	var/active = 0.0
	flags = CONDUCT
	item_state = "electronic"
	throwforce = 10.0
	throw_speed = 2
	throw_range = 10
	w_class = 2.0
	origin_tech = "magnets=3;syndicate=4"

/obj/item/weapon/cloaking_device/attack_self(mob/user)
	src.active = !( src.active )
	if (src.active)
		to_chat(user, "\blue The cloaking device is now active.")
		src.icon_state = "shield1"
	else
		to_chat(user, "\blue The cloaking device is now inactive.")
		src.icon_state = "shield0"
	src.add_fingerprint(user)
	return

/obj/item/weapon/cloaking_device/emp_act(severity)
	active = 0
	icon_state = "shield0"
	if(ismob(loc))
		loc:update_icons()
	..()
*/

/obj/item/clothing/belt/energy_shield
	name = "portable energy shield"
	desc = "A shield capable of defend user from projectiles and melee attacks."
	origin_tech = "materials=6;magnets=5;bluespace=4;phorontech=3"
	icon_state = "shieldbelt"
	actions_types = /datum/action/item_action/shield
	var/active = 0
	var/mob/living/carbon/human/wearer = null
	var/obj/item/weapon/stock_parts/cell/scell = null
	var/charge_cost = 10
	var/shield_on = "shield-old"

/obj/item/clothing/belt/energy_shield/atom_init()
	. = ..()
	scell = new /obj/item/weapon/stock_parts/cell

/obj/item/clothing/belt/energy_shield/IsReflect(def_zone, hol_dir, hit_dir)
	if(active)
		return 1
	return 0

/obj/item/clothing/belt/energy_shield/equipped(mob/user, slot)
	..()
	if(slot == slot_belt)
		wearer = user
	if(istype(wearer, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = wearer
		H.energy_shield = src

/obj/item/clothing/belt/energy_shield/dropped(mob/user)
	if(active)
		toggle_shield()
	if(istype(wearer, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = wearer
		H.energy_shield = null
	wearer = null

	..()

/obj/item/clothing/belt/energy_shield/proc/slot_check()
	if(!ishuman(wearer))
		return 1

	if((slot_flags & SLOT_BELT) && wearer.belt == src)
		return 1
	return 0

/obj/item/clothing/belt/energy_shield/proc/actble()
	if(active)
		to_chat(wearer, "<span class='warning'>You cannot operate with [src] while it's active!</span>")
		return 0
	return 1

/obj/item/clothing/belt/energy_shield/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/stock_parts/cell) && actble())
		if(scell)
			to_chat(user, "<span class='notice'>\the [src] already has a cell.</span>")
		else
			if(!user.unEquip(I))
				return
			I.forceMove(src)
			scell = I
			to_chat(user, "<span class='notice'>You install a cell in \the [src].</span>")
			src.add_fingerprint(user)
			update_icon()

	else if(isscrewdriver(I) && actble())
		if(scell)
			scell.update_icon()
			scell.forceMove(get_turf(src.loc))
			scell = null
			to_chat(user, "<span class='notice'>You remove the cell from \the [src].</span>")
			src.add_fingerprint(user)
			update_icon()
		else
			to_chat(user, "<span class='notice'>[src] don't have any cell in it.</span>")
	else
		return ..()

/obj/item/clothing/belt/energy_shield/verb/shield()
	set name = "Toggle Shield"
	set category = "Object"

	if(!slot_check())
		to_chat(wearer, "<span class='warning'>You need to equip [src] before running the shield protocol!</span>")
		return
	if(wearer.is_busy())
		return
	if(!istype(wearer, /mob/living/carbon/human))
		to_chat(wearer, "<span class='warning'>The [src] designed only for humanoid type species!</span>")
		return
	if(scell.charge <= 0)
		to_chat(wearer, "<span class='warning'>The [src] not have enough charge for this!</span>")
		return
	src.add_fingerprint(wearer)
	toggle_shield()

/obj/item/clothing/belt/energy_shield/proc/toggle_shield()
	if(!active)
		to_chat(wearer, "<span class='notice'>You launching the shield protocol.</span>")
		if(do_after(wearer, 40, target = wearer))
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
			s.set_up(3, 1, wearer)
			s.start()
			scell.use(charge_cost)
			active = 1
			canremove = 0
			START_PROCESSING(SSobj, src)
			wearer.overlays += image('icons/effects/effects.dmi', shield_on)
			return
	active = 0
	canremove = 1
	STOP_PROCESSING(SSobj, src)
	wearer.overlays -= image('icons/effects/effects.dmi', shield_on)
	to_chat(wearer, "<span class='notice'>Shield bubble disabled.</span>")

/obj/item/clothing/belt/energy_shield/process()
	if(scell.charge < charge_cost)
		to_chat(wearer, "<span class='warning'>Not enough energy to support a shield!</span>")
		STOP_PROCESSING(SSobj, src)
		toggle_shield()
		return
	scell.use(charge_cost)

/obj/item/clothing/belt/energy_shield/emp_act()
	if(active)
		toggle_shield()
	if(scell)
		explosion(src.loc, scell.rating / 2, scell.rating/ 2, scell.rating)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return