/obj/effect/proc_holder/magic/click_on/shoot/lash
	name = "Shaab's lash"
	desc = ""
	mana_cost = LASH_MANACOST
	projectile = /obj/item/projectile/lash


/obj/item/projectile/lash
	name = "fiery lash"
	icon_state = null	//If you have sprite of a fiery lash - pls give
	damage = LASH_BASE_DAMAGE
	damage_type = BURN
	flag = "bomb"


/obj/item/projectile/lash/Move()
	. = ..()
	var/turf/T = get_turf(src)
	if(T)
		if(!istype(T,/turf/simulated))
			qdel(src)			//Runtime in process
		else
			T.create_fire(4)


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
		var/atom/throwtarget = get_edge_target_turf(src, get_dir(src, get_step_away(target, src)))
		if(istype(target, /atom/movable))
			var/atom/movable/T = target
			if(!T.anchored)
				T.throw_at(throwtarget, 7, 3)
				if(isliving(T))
					var/mob/living/M = T
					M.Weaken(2)

	else if(firer.a_intent == "help")
		firer.throw_at(target, get_dist(firer, target) - 1, 1, spin = FALSE)		//Crashing into the floor
	return ..()


#undef LASH_MANACOST
#undef LASH_BASE_DAMAGE