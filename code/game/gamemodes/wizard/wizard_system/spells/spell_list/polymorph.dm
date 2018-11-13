/obj/effect/proc_holder/magic/click_on/polymorph
	name = "Polymorph"
	desc = ""
	delay = POLYMORPH_DELAY
	mana_cost = POLYMORPH_MANACOST
	types_to_click = list("mobs")

// Taking damage in space

/obj/effect/proc_holder/magic/click_on/polymorph/check_mob_cast(mob/living/target)
	. = ..()
	if(!ishuman(target))
		to_chat(owner.current, "<font color = 'purple'><span class = 'bold'>This spell works only on humans and human-like creatures!</span></font>")
		return FALSE



/obj/effect/proc_holder/magic/click_on/polymorph/cast_on_mob(mob/living/carbon/human/target)
	var/mob/living/polymorphed
	switch(owner.current.a_intent)
		if("help")
			polymorphed = new /mob/living/simple_animal/mouse/polymorph(target.loc)
			var/mob/living/simple_animal/mouse/polymorph/mouse = polymorphed
			mouse.original_body = target
		if("disarm")
			polymorphed = new /mob/living/simple_animal/headcrab/polymorph(target.loc)
			var/mob/living/simple_animal/headcrab/polymorph/headcrab = polymorphed
			headcrab.original_body = target
		if("hurt")
			polymorphed = new /mob/living/simple_animal/hulk/human/polymorph(target.loc)
			var/mob/living/simple_animal/hulk/human/polymorph/hulk = polymorphed
			hulk.original_body = target
		if("grab")
			polymorphed = new /mob/living/simple_animal/hostile/carp/megacarp/polymorph(target.loc)
			var/mob/living/simple_animal/hostile/carp/megacarp/polymorph/carp = polymorphed
			carp.original_body = target

	target.forceMove(polymorphed)
	if(target.mind)
		target.mind.transfer_to(polymorphed)
	to_chat(owner.current, "<font color = 'purple'><span class = 'bold'>I transform [target] into [polymorphed]!</span></font>")



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