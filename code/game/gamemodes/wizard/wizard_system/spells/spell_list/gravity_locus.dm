/obj/effect/proc_holder/magic/click_on/gravity
	name = "Gravity locus"
	desc = ""
	mana_cost = 0
	cooldown = 15
	types_to_click = list("turfs")

/obj/effect/proc_holder/magic/click_on/gravity/cast_on_turf(turf/target)
	for(var/atom/movable/AM in range(3,target))
		if(AM == owner.current || AM.anchored)
			continue
		var/distance= get_dist(target, AM)
		var/maxthrow = 5		//Define this
		if(owner.current.a_intent == "help" || owner.current.a_intent == "disarm").
			AM.throw_at(get_edge_target_turf(target, get_dir(target, get_step_away(AM, target))), ((Clamp((maxthrow - (Clamp(distance - 2, 0, distance))), 3, maxthrow))), 1, owner.current)	//Pizdec
		else
			AM.throw_at(target, maxthrow, 1, owner.current)

		if(isliving(AM))
			var/mob/living/M = AM
			M.Weaken(2)
