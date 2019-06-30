/obj/effect/proc_holder/magic/click_on/shoot/dreary_cell
	name = "Dreary cell"
	desc = ""
	mana_cost = 0
	cooldown = 15
	projectile = /obj/item/projectile/magic/dreary_cell
	shootsound = 'sound/effects/dark_blast.ogg'


/obj/item/projectile/magic/dreary_cell
	name = "magical trap"
	icon_state = "red_1"
	appearance_flags = PIXEL_SCALE


/obj/item/projectile/magic/dreary_cell/atom_init()
	. = ..()
	var/matrix/Mx = matrix()
	Mx.Scale(1.2)
	transform = Mx
	color = "#8B0000"


/obj/item/projectile/magic/dreary_cell/on_hit(atom/target)
	if(!isliving(target))
		return
	if(istype(target, /mob/living/silicon))
		return  //No robots should be affected by this.
	var/obj/structure/stool/bed/magic_cell/cell = new /obj/structure/stool/bed/magic_cell(target.loc)
	cell.layer = target.layer+1
	cell.pixel_y = -2		//To fully hide human sprite
	target.visible_message("<span class = 'danger'>[target] is caught in an energy cell!</span>")
	cell.buckle_mob(target)
	QDEL_IN(cell, 1200)

	return

/obj/structure/stool/bed/magic_cell
	name = "magical cell"
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield2"
	var/health = 100
	anchored = FALSE			//So wizards can pull their victim into custody
	desc = "Strange energy holding victim inside in place. Struggling against that would hurt..."

/obj/structure/stool/bed/magic_cell/atom_init()
	. = ..()
	color = "#FF0000"

/*
/obj/structure/stool/bed/magic_cell/Destroy()		//Infinite loop
	if(buckled_mob && buckled_mob.buckled == src)
		buckled_mob.buckled = null
		buckled_mob.anchored = initial(buckled_mob.anchored)
		buckled_mob.update_canmove()
		buckled_mob = null
	return ..()
*/


/obj/structure/stool/bed/magic_cell/proc/healthcheck()
	if(health <=0)
		buckled_mob.visible_message("<span class = 'danger'>[buckled_mob] broke free!</span>")
		qdel(src)


/obj/structure/stool/bed/magic_cell/user_unbuckle_mob(mob/living/carbon/human/user)
	if(buckled_mob)
		if(buckled_mob != user)
			if(iswizard(user))
				buckled_mob.visible_message(\
					"<span class='notice'>[user.name] whispers some kind of spell, making magical cell around [buckled_mob.name] disappear!</span>",\
					"<span class='notice'>[user.name] frees you from magical cell.</span>",\
					"<span class='notice'>You hear a zap</span>")
				qdel(src)
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
			health = max(0, health - 20)
			healthcheck()
	return

/obj/structure/stool/bed/magic_cell/attack_hand(mob/living/carbon/human/user)
	if(user != buckled_mob && iswizard(user))		//Only via resist, because resist has natural cooldown
		user_unbuckle_mob(user)
	else
		return

/obj/structure/stool/bed/magic_cell/attack_alien(mob/user)
	if(user != buckled_mob || iswizard(user))
		user_unbuckle_mob(user)
	else
		return

/obj/structure/stool/bed/magic_cell/attackby(obj/item/weapon/W, mob/user)
	if(user == buckled_mob)		//Only via resist
		return

	var/aforce = W.force
	health = max(0, health - aforce)
	user.SetNextMove(CLICK_CD_MELEE)
	visible_message("<span class='warning'>[user] hits [src] with [W]!</span>")
	healthcheck()


//Can be unbuckled via help intent

#undef CHAOS_BOLT_MANACOST
#undef CHAOS_BOLT_DAMAGE
