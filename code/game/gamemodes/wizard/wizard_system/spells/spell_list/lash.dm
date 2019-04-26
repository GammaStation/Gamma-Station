/obj/effect/proc_holder/magic/click_on/shoot/lash
	name = "Shaab's lash"
	desc = ""
	mana_cost = 0
	projectile = /obj/item/projectile/lash


/obj/item/projectile/lash
	name = "fiery lash"
	icon_state = null	//I need a sprite for lash.
	damage = LASH_BASE_DAMAGE
	damage_type = BURN
	flag = "bomb"


/obj/item/projectile/lash/Move()
	. = ..()
	var/turf/T = get_turf(src)
	if(T)
		if(!istype(T,/turf/simulated))
			STOP_PROCESSING(SSobj, src)
			qdel(src)		//Runtime, should forbid using on unsimulated
		else
			T.create_fire(4)		//Fire trail should only be in hurt mode, but I have no sprite so it will be always, until then


/obj/item/projectile/lash/on_hit(atom/target)
	if(firer.a_intent == "grab")
		if(istype(target, /atom/movable))
			var/atom/movable/T = target
			if(!T.anchored)
				T.throw_at(firer, get_dist(firer, T) - 1, 1, spin = FALSE)
				if(isliving(T))
					var/mob/living/M = T
					M.Weaken(2)

	else if(firer.a_intent == "hurt")
		explosion(get_turf(target), 1)
		if(ismob(target))
			var/mob/living/L = target
			L.adjust_fire_stacks(20)
			L.IgniteMob()


	else if(firer.a_intent == "disarm")
		if(istype(target, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = target
			var/obj/item/disarm = H.get_active_hand()
			if(disarm)
				H.drop_item()
				disarm.throw_at(firer, get_dist(firer, disarm) - 1, 1, spin = FALSE)

	else if(firer.a_intent == "help")
		var/atom/throwtarget = get_edge_target_turf(src, get_dir(src, get_step_away(target, src)))
		if(istype(target, /atom/movable))
			var/atom/movable/T = target
			if(!T.anchored)
				T.throw_at(throwtarget, 7, 3)
				if(isliving(T))
					var/mob/living/M = T
					M.Weaken(2)
	return ..()


#undef LASH_MANACOST
#undef LASH_BASE_DAMAGE