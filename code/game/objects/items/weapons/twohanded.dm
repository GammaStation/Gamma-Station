#define DUALSABER_BLOCK_CHANCE_MODIFIER 1.2

/* Two-handed Weapons
 * Contains:
 * 		Twohanded
 *		Fireaxe
 *		Double-Bladed Energy Swords
 */
/*
 * Fireaxe
 */
/obj/item/weapon/twohanded/fireaxe  // DEM AXES MAN, marker -Agouri
	icon_state = "fireaxe"
	wielded_state = "fireaxe"
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"
	force = 5
	sharp = 1
	edge = 1
	w_class = 4.0
	slot_flags = SLOT_BACK
	force_unwielded = 10
	force_wielded = 40
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")

/obj/item/weapon/twohanded/fireaxe/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return
	..()
	if(A && wielded) //destroys windows and grilles in one hit
		if(istype(A,/obj/structure/window)) //should just make a window.Break() proc but couldn't bother with it
			var/obj/structure/window/W = A
			W.shatter()
		else if(istype(A,/obj/structure/grille))
			var/obj/structure/grille/G = A
			new /obj/item/stack/rods(G.loc)
			qdel(A)

/obj/item/weapon/twohanded/fireaxe/can_be_wielded()
	return TRUE

/*
 * Double-Bladed Energy Swords - Cheridan
 */
/obj/item/weapon/twohanded/dualsaber
	var/reflect_chance = 0
	icon_state = "dualsaber"
	name = "double-bladed energy sword"
	desc = "Handle with care."
	force = 3
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	item_color = "green"
	force_unwielded = 3
	force_wielded = 45
	var/hacked
	var/slicing
	wieldsound = 'sound/weapons/saberon.ogg'
	unwieldsound = 'sound/weapons/saberoff.ogg'
	flags = NOSHIELD
	origin_tech = "magnets=3;syndicate=4"
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sharp = 1
	edge = 1
	can_embed = 0

/obj/item/weapon/twohanded/dualsaber/atom_init()
	. = ..()
	reflect_chance = rand(50, 65)
	item_color = pick("red", "blue", "green", "purple","yellow","pink","black")
	switch(item_color)
		if("red")
			light_color = "#ff0000"
		if("blue")
			light_color = "#0000b2"
		if("green")
			light_color = "#00ff00"
		if("purple")
			light_color = "#551a8b"
			light_power = 2
		if("yellow")
			light_color = "#ffff00"
		if("pink")
			light_color = "#ff00ff"
		if("black")
			light_color = "#aeaeae"

/obj/item/weapon/twohanded/dualsaber/can_be_wielded()
	return TRUE


/obj/item/weapon/twohanded/dualsaber/update_icon()
	if(wielded)
		icon_state = "dualsaber[item_color]"
	else
		icon_state = "dualsaber"
	clean_blood()//blood overlays get weird otherwise, because the sprite changes.

/obj/item/weapon/twohanded/dualsaber/attack(target, mob/living/user)
	..()
	if((CLUMSY in user.mutations) && (wielded) && prob(40))
		to_chat(user, "<span class='userdanger'> You twirl around a bit before losing your balance and impaling yourself on the [src].</span>")
		user.take_bodypart_damage(20, 25)
		return
	if(wielded && prob(50))
		spawn(0)
			for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2))
				user.dir = i
				sleep(1)

/obj/item/weapon/twohanded/dualsaber/Get_shield_chance()
	if(wielded && !slicing)
		return reflect_chance * DUALSABER_BLOCK_CHANCE_MODIFIER - 5
	else
		return 0

/obj/item/weapon/twohanded/dualsaber/IsReflect(def_zone, hol_dir, hit_dir)
	return !slicing && wielded && prob(reflect_chance) && is_the_opposite_dir(hol_dir, hit_dir)

/obj/item/weapon/twohanded/dualsaber/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/device/multitool))
		if(!hacked)
			hacked = 1
			to_chat(user,"<span class='warning'>2XRNBW_ENGAGE</span>")
			item_color = "rainbow"
			light_color = ""
			update_icon()
		else
			to_chat(user,"<span class='warning'>It's starting to look like a triple rainbow - no, nevermind.</span>")
	else
		return ..()

/obj/item/weapon/twohanded/dualsaber/afterattack(obj/O, mob/user, proximity)
	if(!istype(O,/obj/machinery/door/airlock) || slicing)
		return
	if(O.density && wielded && proximity && in_range(user, O))
		user.visible_message("<span class='danger'>[user] start slicing the [O] </span>")
		playsound(user.loc, 'sound/items/Welder2.ogg', 100, 1, -1)
		slicing = TRUE
		var/obj/machinery/door/airlock/D = O
		var/obj/effect/I = new /obj/effect/overlay/slice(D.loc)
		if(do_after(user, 450, target = D) && D.density && !(D.operating == -1) && in_range(user, O))
			sleep(6)
			var/obj/structure/door_scrap/S = new /obj/structure/door_scrap(D.loc)
			var/iconpath = D.icon
			var/icon/IC = new(iconpath, "closed")
			IC.Blend(S.door, ICON_OVERLAY, 1, 1)
			IC.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0))
			S.icon = IC
			S.name = D.name
			S.name += " remains"
			qdel(D)
			qdel(IC)
			playsound(user.loc, 'sound/weapons/blade1.ogg', 100, 1, -1)
		slicing = FALSE
		qdel(I)


/obj/item/weapon/twohanded/dualsaber/dropped(mob/user)
 	..()
 	slicing = FALSE

/obj/item/weapon/twohanded/dualsaber/attack_self(mob/user)
	if(slicing)
		return
	..()

/obj/item/weapon/twohanded/dualsaber/unwield()
	set_light(0)
	w_class = initial(w_class)
	return ..()

/obj/item/weapon/twohanded/dualsaber/wield()
	set_light(2)
	w_class = 5
	return ..()

#undef DUALSABER_BLOCK_CHANCE_MODIFIER
