/obj/effect/proc_holder/magic/click_on/polymorph
	name = "Polymorph"
	desc = ""
	delay = POLYMORPH_DELAY
	mana_cost = POLYMORPH_MANACOST
	types_to_click = list("mobs")

// Taking damage in space

/obj/effect/proc_holder/magic/click_on/polymorph/spell_specific_checks(atom/target)
	. = ..()
	if(!ishuman(target))
		to_chat(owner.current, "<font color = 'purple'><span class = 'bold'>This spell works only on humans and human-like creatures!</span></font>")
		return FALSE



/obj/effect/proc_holder/magic/click_on/polymorph/cast_on_mob(mob/living/carbon/human/target)
	switch(owner.current.a_intent)
		if("help")
			var/mob/living/simple_animal/mouse/polymorph/critter_transform = new(target.loc)
			target.forceMove(critter_transform)
			critter_transform.original_body = target
			if(target.mind)
				target.mind.transfer_to(critter_transform)
			to_chat(owner.current, "<font color = 'purple'><span class = 'bold'>I transform [target] into [critter_transform]!</span></font>")
		if("disarm")
			var/mob/living/simple_animal/headcrab/polymorph/headcrab_transform = new(target.loc)
			target.forceMove(headcrab_transform)
			headcrab_transform.original_body = target
			if(target.mind)
				target.mind.transfer_to(headcrab_transform)
			to_chat(owner.current, "<font color = 'purple'><span class = 'bold'>I transform [target] into [headcrab_transform]!</span></font>")
		if("hurt")
			var/mob/living/simple_animal/hulk/human/polymorph/hulk_transform = new(target.loc)
			target.forceMove(hulk_transform)
			hulk_transform.original_body = target
			if(target.mind)
				target.mind.transfer_to(hulk_transform)
			to_chat(owner.current, "<font color = 'purple'><span class = 'bold'>I transform [target] into [hulk_transform]!</span></font>")
		if("grab")
			var/mob/living/simple_animal/hostile/carp/megacarp/polymorph/carp_transform = new(target.loc)
			target.forceMove(carp_transform)
			carp_transform.original_body = target
			if(target.mind)
				target.mind.transfer_to(carp_transform)
			to_chat(owner.current, "<font color = 'purple'><span class = 'bold'>I transform [target] into [carp_transform]!</span></font>")



/mob/living/simple_animal/hostile/carp/megacarp/polymorph		//Human inside still gets damaged by spess. Bug or feature? May replace carp with spider, then.
	var/mob/living/original_body
	speed = -1


/mob/living/simple_animal/hostile/carp/megacarp/polymorph/verb/revert()
	set category = "Polymorph"
	set name = "Revert"
	set desc = "Revert to your normal form"

	qdel(src)


/mob/living/simple_animal/hostile/carp/megacarp/polymorph/death()
	qdel(src)


/mob/living/simple_animal/hostile/carp/megacarp/polymorph/Destroy()
	if(original_body)
		original_body.loc = get_turf(src)
	if(mind)
		mind.transfer_to(original_body)

	return ..()


/mob/living/simple_animal/hulk/human/polymorph


/mob/living/simple_animal/hulk/human/polymorph/verb/revert()
	set category = "Polymorph"
	set name = "Revert"
	set desc = "Revert to your normal form"

	qdel(src)



/mob/living/simple_animal/hulk/human/polymorph/death()
	qdel(src)


/mob/living/simple_animal/hulk/human/polymorph/Destroy()
	if(original_body)
		original_body.loc = get_turf(src)
	if(mind)
		mind.transfer_to(original_body)
	return ..()


/mob/living/simple_animal/headcrab/polymorph
	var/mob/living/original_body


/mob/living/simple_animal/headcrab/polymorph/verb/revert()
	set category = "Polymorph"
	set name = "Revert"
	set desc = "Revert to your normal form"

	qdel(src)


/mob/living/simple_animal/headcrab/polymorph/death()
	qdel(src)


/mob/living/simple_animal/headcrab/polymorph/Destroy()
	if(original_body)
		original_body.loc = get_turf(src)
	if(mind)
		mind.transfer_to(original_body)
	return ..()

/mob/living/simple_animal/headcrab/polymorph/Infect()
	return //No.


/mob/living/simple_animal/mouse/polymorph
	var/mob/living/original_body

/mob/living/simple_animal/mouse/polymorph/verb/revert()
	set category = "Polymorph"
	set name = "Revert"
	set desc = "Revert to your normal form"

	qdel(src)

/mob/living/simple_animal/mouse/polymorph/death()
	qdel(src)


/mob/living/simple_animal/mouse/polymorph/Destroy()
	if(original_body)
		original_body.loc = get_turf(src)
	if(mind)
		mind.transfer_to(original_body)
	return ..()

#undef POLYMORPH_DELAY
#undef POLYMORPH_MANACOST