/obj/effect/proc_holder/magic/nondirect/summon_forest
	name = "Summon forest"
	desc = ""
	mana_cost = 0
	cooldown = 45
	delay = 30


/obj/effect/proc_holder/magic/nondirect/summon_forest/cast()
	playsound(owner.current.loc, 'sound/magic/warp.ogg', 100, 1)
	var/list/targets = list()
	for(var/turf/T in view(4, owner.current))
		if(!is_blocked_turf(T))
			targets += T
	for(var/i in 1 to FOREST_AMOUNT_OF_TREES)
		if(!targets)
			break
		var/turf/spawn_place = pick(targets)
		targets -= spawn_place
		var/mob/living/simple_animal/hostile/tree/spawned = new(spawn_place)
		spawned.friends += owner.current
		spawned.anchored = TRUE
		spawned.vision_range = 1
		spawned.aggro_vision_range = 1
		spawned.wander = 0
		spawned.a_intent = "hurt"
		spawned.idle_vision_range = 1
		QDEL_IN(spawned, FOREST_TREE_LIFESPAN)
	message_admins("[usr] ([usr.ckey]) spawned magical forest at [get_area(usr)].(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")


#undef FOREST_MANACOST
#undef FOREST_DELAY
#undef FOREST_AMOUNT_OF_TREES
#undef FOREST_TREE_LIFESPAN