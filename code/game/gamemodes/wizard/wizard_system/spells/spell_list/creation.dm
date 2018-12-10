/obj/effect/proc_holder/magic/click_on/creation
	name = "Esoteric creation"
	desc = ""
	mana_cost = CREATION_MANACOST
	delay = CREATION_DELAY
	types_to_click = list("turfs")
	closerange = TRUE

/obj/effect/proc_holder/magic/click_on/creation/check_turf_cast(turf/target)
	if(is_blocked_turf(target))
		to_chat(owner.current, "<font color='purple'><i>This place is occupied! I can't conjure a creature here!</i></font>")
		return TRUE


/obj/effect/proc_holder/magic/click_on/creation/cast_on_turf(turf/target)
	var/mob/living/simple_animal/hostile/hostile_created_mob
	switch(owner.current.a_intent)
		if("help")
			var/mob/living/simple_animal/peaceful_created_mob = pick (/mob/living/simple_animal/chicken, /mob/living/simple_animal/cow, /mob/living/simple_animal/pig, /mob/living/simple_animal/turkey, /mob/living/simple_animal/goose, /mob/living/simple_animal/seal, /mob/living/simple_animal/walrus)
			new peaceful_created_mob(target)
			message_admins("[usr] ([usr.ckey]) spawned a [peaceful_created_mob] at X=[target.x] Y=[target.y] Z=[target.z] with [src.name] spell.(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
		if("disarm")
			hostile_created_mob = new /mob/living/simple_animal/hostile/giant_spider/nurse(target)
		if("hurt")
			hostile_created_mob = new /mob/living/simple_animal/hostile/asteroid/goliath(target)
		if("grab")
			hostile_created_mob = new /mob/living/simple_animal/hostile/mimic/crate(target)

	if(hostile_created_mob)
		hostile_created_mob.friends += owner.current
		hostile_created_mob.faction = "conjured"
		message_admins("[usr] ([usr.ckey]) spawned a [hostile_created_mob] at X=[target.x] Y=[target.y] Z=[target.z] with [src.name] spell.(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")



#undef CREATION_MANACOST
#undef CREATION_MANACOST
