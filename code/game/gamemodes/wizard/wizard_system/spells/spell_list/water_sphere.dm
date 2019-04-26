//Rename

/obj/effect/proc_holder/magic/click_on/shoot/water_sphere
	name = "Water sphere"
	desc = ""
	mana_cost = 0
	projectile = /obj/item/projectile/magic/water_sphere
	shootsound = 'sound/magic/water.ogg'

/obj/effect/proc_holder/magic/click_on/shoot/water_sphere/process()
	switch(owner.current.a_intent)
		if("help")
			name = "Stone arrow"
			projectile = /obj/item/projectile/bullet/stone_arrow
			shootsound = 'sound/weapons/Gunshot_silenced.ogg'			//Change sound effect
		if("disarm")
			name = "Water sphere"
			projectile = /obj/item/projectile/magic/water_sphere
			shootsound = 'sound/magic/water.ogg'
		if("hurt")
			name = "Fireball"
			projectile = /obj/item/projectile/magic/fireball_weak
			shootsound = 'sound/magic/Fireball.ogg'
		if("grab")
			name = "Ball lightning"
			projectile = /obj/item/projectile/magic/lightning_weak
			shootsound = 'sound/magic/lightningbolt.ogg'


/obj/item/projectile/magic/water_sphere
	name = "watersphere"
	icon = 'icons/effects/effects.dmi'
	icon_state = "bubble"
	nodamage = FALSE
	damage = 5
	weaken = WATERSPHERE_WEAKEN_TIME

	damage_type = OXY

/obj/item/projectile/bullet/stone_arrow
	name = "stone arrow"
	damage = 20
	muzzle_type = null

/obj/item/projectile/magic/fireball_weak
	name = "bolt of fireball"
	icon_state = "fireball"
	damage = 10
	damage_type = BURN
	nodamage = 0

/obj/item/projectile/magic/fireball_weak/on_hit(atom/target)
	if(isliving(target))
		var/mob/living/M = target
		M.fire_act()
		M.adjust_fire_stacks(5)
	return ..()

/obj/item/projectile/magic/lightning_weak
	name = "lightning bolt"
	icon_state = "tesla_projectile"
	damage = 5
	damage_type = BURN
	nodamage = 0


/obj/item/projectile/magic/lightning_weak/on_hit(atom/target)
	tesla_zap(src, 3, 2000)
	return ..()


/obj/item/projectile/magic/water_sphere/atom_init()
	. = ..()
	var/matrix/Mx = matrix()
	Mx.Scale(1.3)
	transform = Mx
	color = "#00BFFF"


/obj/item/projectile/magic/water_sphere/on_hit(atom/target)
	var/datum/effect/effect/system/steam_spread/steam = new /datum/effect/effect/system/steam_spread()
	steam.set_up(10, 0, loc)
	steam.start()

	target.water_act(WATERSPHERE_AMOUNT_OF_LIQUID/10)
	spawn_fluid(loc, WATERSPHERE_AMOUNT_OF_LIQUID)

	message_admins("[src.name] launched by [usr] ([usr.ckey]) spawned water at [get_area(target)](<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>)")
	log_game("[src.name] launched by [usr] ([usr.ckey]) spawned water at [get_area(target)]")

	for(var/atom/movable/A in orange(WATERSPHERE_WATERBLAST_RANGE,loc))
		if(A.anchored)
			continue
		step_away(A,loc)
		if(ismob(A))
			var/mob/living/M = A
			M.Weaken(WATERSPHERE_WEAKEN_TIME)

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(istype(H.wear_suit, /obj/item/clothing/suit/space/rig) && H.wear_suit.flags & NOSLIP)
			return
		for(var/obj/item/I in H.contents)
			if(istype(I, /obj/item/weapon/implant))
				continue
			I.make_wet()
	return ..()

#undef WATERSPHERE_MANACOST
#undef WATERSPHERE_DAMAGE
#undef WATERSPHERE_AMOUNT_OF_LIQUID
#undef WATERSPHERE_WEAKEN_TIME
#undef WATERSPHERE_WATERBLAST_RANGE