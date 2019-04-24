/obj/effect/proc_holder/magic/click_on/shoot/dreary_cell
	name = "Dreary cell"
	desc = ""
	mana_cost = 0
	cooldown = 40
	projectile = /obj/item/projectile/magic/dreary_cell
	shootsound = 'sound/effects/dark_blast.ogg'


/obj/item/projectile/magic/dreary_cell
	name = "magical trap"
	icon_state = "red_1"


/obj/item/projectile/magic/dreary_cell/atom_init()
	. = ..()
	color = "#8B0000"


/obj/item/projectile/magic/dreary_cell/on_hit(atom/target)
	if(!isliving(target))
		return
	if(istype(target, /mob/living/silicon))
		return  //No robots should be affected by this.
	var/obj/effect/energy_net/magic_cell/cell = new /obj/effect/energy_net/magic_cell(target.loc)
	cell.layer = target.layer+1
	cell.pixel_y = -2
	target.visible_message("<span class = 'danger'>[target] is caught in an energy cell!</span>")
	cell.affecting = target
	cell.buckle_mob(target)
	QDEL_IN(cell, 1200)

	return

/obj/effect/energy_net/magic_cell
	name = "magical cell"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield2"
	anchored = FALSE			//So wizards can pull their victim into custody
	desc = "Strange energy holding victim inside in place. Struggling against that would hurt..."
	can_buckle = TRUE

/obj/effect/energy_net/magic_cell/atom_init()
	. = ..()
	color = "#FF0000"

//process

/obj/effect/energy_net/magic_cell/Destroy()
	if(buckled_mob && buckled_mob.buckled == src)
		buckled_mob.buckled = null
		buckled_mob.anchored = initial(buckled_mob.anchored)
		buckled_mob.update_canmove()
		buckled_mob = null
	. = ..()

/obj/effect/energy_net/magic_cell/unbuckle_mob()
	..()
	qdel(src)

/obj/effect/energy_net/magic_cell/healthcheck()
	if(health <=0)
		buckled_mob.visible_message("<span class = 'danger'>[buckled_mob] broke free!</span>")
		unbuckle_mob()


/obj/effect/energy_net/magic_cell/user_unbuckle_mob(mob/living/carbon/human/user)
	if(buckled_mob)
		if(buckled_mob != user)
			if(iswizard(user))
				buckled_mob.visible_message(\
					"<span class='notice'>[user.name] whispers some kind of spell, making magical cell around [buckled_mob.name] disappear!</span>",\
					"<span class='notice'>[user.name] frees you from magical cell.</span>",\
					"<span class='notice'>You hear a zap</span>")
				unbuckle_mob()
		else
			var/mob/living/L = buckled_mob
			L.electrocute_act(10, src, def_zone = pick(BP_CHEST , BP_GROIN , BP_L_LEG , BP_R_LEG , BP_R_ARM , BP_L_ARM))
			var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
			sparks.set_up(5, 0, L)
			sparks.start()
			buckled_mob.visible_message(\
				"<span class='warning'>Magical cell electrocutes [buckled_mob.name] as they struggle against it!</span>",\
				"<span class='danger'>Magical cell electrocutes you as you struggle against it!</span>",\
				"<span class='notice'>You hear a zap</span>")
			health -= 20
			healthcheck()
	return

/obj/effect/energy_net/magic_cell/attack_hand(mob/living/carbon/human/user)
	if(user != buckled_mob && iswizard(user))
		user_unbuckle_mob(user)
	else
		..()

/obj/effect/energy_net/magic_cell/attack_alien(mob/user)
	if(user == buckled_mob || iswizard(user))
		user_unbuckle_mob(user)
	else
		..()

/obj/effect/energy_net/magic_cell/attackby(obj/item/weapon/W, mob/user)
	if(user == buckled_mob)
		return
	..()


//Can be unbuckled via help intent

#undef CHAOS_BOLT_MANACOST
#undef CHAOS_BOLT_DAMAGE
