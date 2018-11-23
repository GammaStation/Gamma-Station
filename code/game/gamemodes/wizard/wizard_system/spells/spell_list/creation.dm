/obj/effect/proc_holder/magic/click_on/creation
	name = "Esoteric creation"
	desc = ""
	mana_cost = CREATION_MANACOST
	delay = CREATION_DELAY
	types_to_click = list("turfs")

/obj/effect/proc_holder/magic/click_on/creation/check_turf_cast(turf/target)
	. = ..()
	if(is_blocked_turf(target))
		to_chat(owner.current, "<font color='purple'><i>This place is occupied! I can't conjure a creature here!</i></font>")
		return FALSE


/obj/effect/proc_holder/magic/click_on/creation/cast_on_turf(turf/target)
	var/mob/living/simple_animal/hostile/hostile_created_mob
	switch(owner.current.a_intent)
		if("help")
			var/mob/living/simple_animal/peaceful_created_mob = pick (/mob/living/simple_animal/chicken, /mob/living/simple_animal/cow, /mob/living/simple_animal/pig, /mob/living/simple_animal/turkey, /mob/living/simple_animal/goose, /mob/living/simple_animal/seal, /mob/living/simple_animal/walrus)
			new peaceful_created_mob(target)
		if("disarm")
			hostile_created_mob = new /mob/living/simple_animal/hostile/giant_spider/nurse(target)
		if("hurt")
			hostile_created_mob = new /mob/living/simple_animal/hostile/asteroid/goliath(target)
		if("grab")
			hostile_created_mob = new /mob/living/simple_animal/hostile/mimic(target)

	if(hostile_created_mob)
		hostile_created_mob.friends += owner.current
		hostile_created_mob.faction = "conjured"



#undef CREATION_MANACOST
#undef CREATION_MANACOST
