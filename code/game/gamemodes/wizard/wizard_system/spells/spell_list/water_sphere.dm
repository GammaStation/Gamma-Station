/obj/effect/proc_holder/magic/click_on/shoot/water_sphere
	name = "Water Sphere"
	desc = ""
	mana_cost = WATERSPHERE_MANACOST
	projectile = /obj/item/projectile/magic/water_sphere
	shootsound = 'sound/magic/water.ogg'

/obj/item/projectile/magic/water_sphere
	name = "watersphere"
	icon = 'icons/effects/effects.dmi'
	icon_state = "bubble"
	nodamage = FALSE
	damage = WATERSPHERE_DAMAGE
	weaken = WATERSPHERE_WEAKEN_TIME

	damage_type = OXY

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