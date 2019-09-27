var/list/hair_colors = list("090806","2C222B","71635A","B7A69E","D6C4C2","CABFB1","DCD0BA","FFF5E1","E6CEA8","DEBC99","B89778","A56B46","B55239","8D4A43","91553D","533D32")

/mob/living/simple_animal/hostile/hellspawn/zombie
	name = "zombie"
	desc = ""
	icon = 'icons/mob/hellspawn/zombie.dmi'

	speak_chance = 0
	turns_per_move = 5
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = 6
	move_to_delay = 6
	a_intent = "harm"
	maxHealth = 50
	health = 50

	harm_intent_damage = 8
	melee_damage_lower = 5
	melee_damage_upper = 5
	attack_message = list("punches")
	attack_sound = 'sound/weapons/bite.ogg'
	sight_sound = list(
	'sound/mob/zombie/zombie_sight1.ogg',\
	'sound/mob/zombie/zombie_sight2.ogg',\
	'sound/mob/zombie/zombie_sight3.ogg',\
	'sound/mob/zombie/zombie_sight4.ogg',\
	'sound/mob/zombie/zombie_sight5.ogg',\
	'sound/mob/zombie/zombie_sight6.ogg',\
	'sound/mob/zombie/zombie_sight7.ogg',\
	'sound/mob/zombie/zombie_sight8.ogg',\
	'sound/mob/zombie/zombie_sight9.ogg',\
	'sound/mob/zombie/zombie_sight10.ogg',\
	'sound/mob/zombie/zombie_sight11.ogg',\
	'sound/mob/zombie/zombie_sight12.ogg',\
	)
	death_sound = list(
	'sound/mob/zombie/zombie_death1.ogg',\
	'sound/mob/zombie/zombie_death2.ogg',\
	'sound/mob/zombie/zombie_death3.ogg',\
	'sound/mob/zombie/zombie_death4.ogg',\
	'sound/mob/zombie/zombie_death5.ogg',\
	'sound/mob/zombie/zombie_death6.ogg'
	)
	pain_sound = list(
	'sound/mob/zombie/zombie_pain1.ogg',\
	'sound/mob/zombie/zombie_pain2.ogg',\
	'sound/mob/zombie/zombie_pain3.ogg',\
	'sound/mob/zombie/zombie_pain4.ogg',\
	'sound/mob/zombie/zombie_pain5.ogg',\
	'sound/mob/zombie/zombie_pain6.ogg',\
	'sound/mob/zombie/zombie_pain7.ogg',\
	'sound/mob/zombie/zombie_pain8.ogg',\
	'sound/mob/zombie/zombie_pain9.ogg',\
	'sound/mob/zombie/zombie_pain10.ogg',\
	'sound/mob/zombie/zombie_pain11.ogg',\
	'sound/mob/zombie/zombie_pain12.ogg',\
	'sound/mob/zombie/zombie_pain13.ogg',\
	)
	var/list/blunt_weapon = list(/obj/item/weapon/extinguisher/outpost)
	var/list/cutting_weapon = list(/obj/item/weapon/kitchenknife)
	var/list/range_weapon = list(/obj/item/weapon/gun/projectile/pistol)
	var/obj/item/weapon/weapon = null
	var/weapon_overlay

	var/reload_time = 40

/mob/living/simple_animal/hostile/hellspawn/zombie/IsAdvancedToolUser()
	return TRUE

/mob/living/simple_animal/hostile/hellspawn/zombie/atom_init()
	. = ..()
	gender = pick(MALE, FEMALE)
	generate_icons()
	get_weapon()

/mob/living/simple_animal/hostile/hellspawn/zombie/death()
	lying = TRUE
	update_transform()
	overlays -= weapon_overlay
	if (istype(loc, /turf/simulated))
		new /obj/effect/decal/cleanable/blood(loc)
	drop_loot()
	return ..()

/mob/living/simple_animal/hostile/hellspawn/zombie/proc/drop_loot()
	if(weapon && prob(10))
		weapon.forceMove(get_turf(src))
		weapon = null

/mob/living/simple_animal/hostile/hellspawn/zombie/proc/generate_icons()
	icon_state = "[gender]_[pick("caucasian","afro","asian")]"
	icon_living = icon_state
	icon_dead = icon_state

	var/image/hair
	if(gender == MALE)
		hair = image('icons/mob/hellspawn/zombie_hair_male.dmi', pick(icon_states('icons/mob/hellspawn/zombie_hair_male.dmi')))
	else
		hair = image('icons/mob/hellspawn/zombie_hair_female.dmi', pick(icon_states('icons/mob/hellspawn/zombie_hair_female.dmi')))

	var/hex_color = pick(hair_colors)
	hair.color = RGB_CONTRAST(hex2rgb_r(hex_color), hex2rgb_g(hex_color), hex2rgb_b(hex_color))

	overlays += hair

/mob/living/simple_animal/hostile/hellspawn/zombie/proc/get_weapon()
	var/weapon_type = pick("blunt","cutting","range")
	var/obj/item/weapon/pickup
	switch(weapon_type)
		if("blunt")
			pickup = pick(blunt_weapon)
			environment_smash = 1
		if("cutting")
			pickup = pick(cutting_weapon)
		if("range")
			pickup = pick(range_weapon)

	weapon = new pickup(src)

	melee_damage_lower = (weapon.force/2)
	melee_damage_upper = weapon.force
	attack_message = weapon.attack_verb
	attack_sound = weapon.hitsound

	var/item_state_overlay = weapon.item_state ? weapon.item_state : weapon.icon_state
	if(weapon_type == "range")
		var/obj/item/weapon/gun/projectile/G = weapon
		ranged = 1
		projectilesound = G.fire_sound
		casingtype = G.magazine.ammo_type
		var/obj/item/ammo_casing/boolet = new G.magazine.ammo_type
		projectiletype = boolet.projectile_type
		if(!G.isHandgun())
			item_state_overlay = "[G.item_state]_wield"

	weapon_overlay = image(weapon.righthand_file,item_state_overlay)
	overlays += weapon_overlay

/mob/living/simple_animal/hostile/hellspawn/zombie/AttackingTarget()
	. =..()
	if(environment_smash && isliving(target))
		var/mob/living/L = target
		if(prob(15))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")


/mob/living/simple_animal/hostile/hellspawn/zombie/proc/Reload()
	var/obj/item/weapon/gun/projectile/G = weapon
	visible_message("\red <b>[src]</b> is starts reload his gun!", 1)
	stance = HOSTILE_STANCE_IDLE
	reloading = TRUE
	if(do_after(src, reload_time))
		if(istype(G,/obj/item/weapon/gun/projectile/revolver))
			while (G.get_ammo() > 0)
				var/obj/item/ammo_casing/CB
				CB = G.magazine.get_round(0)
				G.chambered = null
				CB.loc = get_turf(loc)
				CB.SpinAnimation(10, 1)
				CB.update_icon()

		for(var/i in 1 to G.magazine.max_ammo)
			G.magazine.stored_ammo += new G.magazine.ammo_type(G.magazine)

		G.chamber_round()
		reloading = FALSE
	else
		reloading = FALSE
	//	if(reload_sound)
	//		playsound(src.loc, reload_sound, 50, 1)





/mob/living/simple_animal/hostile/hellspawn/zombie/OpenFire(the_target)
	var/obj/item/weapon/gun/projectile/G = weapon
	var/target = the_target

	var/boolets
	if(istype(G,/obj/item/weapon/gun/projectile/revolver))  //for correct count of remaining ammo in revolvers and non-revolvers gun
		boolets = G.get_ammo(0,0)
	else
		boolets = G.get_ammo(1,0)
	if(!boolets)
		Reload()
		return

	G.afterattack(target, src)

	ranged_cooldown = ranged_cooldown_cap
/*
	if(current_shots >= shots_before_reload)
		Reload()
		return



	if(rapid)
		spawn(1)
			Shoot(target)
		spawn(4)
			Shoot(target)
		spawn(6)
			Shoot(target)
	else
		/obj/item/weapon/gun/

	return

/mob/living/simple_animal/hostile/hellspawn/zombie/Shoot(target)
	var/turf/T = get_turf(target)
	var/turf/S = get_turf(src)

	if(T == S)
		return

	if(current_shots >= shots_before_reload)
		return

	var/obj/item/projectile/A = new projectiletype(get_turf(src))
	playsound(src, projectilesound, 100, 1)
	if(!A)
		return
	if (!T)
		qdel(A)
		return
	A.current = T
	A.starting = S
	A.original = T
	A.yo = T.y - S.y
	A.xo = T.x - S.x
	A.process()

	current_shots++

	if(casingtype && !istype(weapon, /obj/item/weapon/gun/projectile/revolver/doublebarrel))  //Revolvers don't spent cases on fire
		var/obj/item/ammo_casing/AC = new casingtype(get_turf(src))
		AC.spent()
		AC.SpinAnimation(10, 1)
*/
/mob/living/simple_animal/hostile/hellspawn/zombie/AttackingTarget()
	if(weapon && !ranged)
		target.attackby(weapon, src)
	else
		target.attack_animal(src)

