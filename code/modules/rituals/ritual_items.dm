/obj/item/weapon/ritual_book
	name = "ritual book"
	desc = "Seems to contain some weird writings"
	icon = 'icons/obj/storage.dmi'
	icon_state ="bible"
	throw_speed = 1
	throw_range = 5
	w_class = 3.0

	var/ritual_in_progress = FALSE
	var/datum/ritual/current_ritual = null
	var/ritual_starting_loc = null
	var/caster_starting_loc = null

	var/ritual_pool = "All"
	var/list/known_rituals = list()

	var/init_rituals_num = 1
	var/max_rituals_num = 3

/obj/item/weapon/ritual_book/atom_init()
	var/rituals_to_init = rand(init_rituals_num, max_rituals_num)
	for(var/i in 1 to rituals_to_init)
		var/type = pick(rituals[ritual_pool])
		var/datum/ritual/R = new type(src)
		if(is_type_in_list(R, known_rituals))
			qdel(R)
			continue
		known_rituals += R

/obj/item/weapon/ritual_book/Destroy()
	QDEL_NULL(current_ritual)
	QDEL_LIST(known_rituals)
	ritual_starting_loc = null
	caster_starting_loc = null
	return ..()

/obj/item/weapon/ritual_book/attack_ghost(mob/user)
	if(ritual_in_progress)
		var/datum/ritual_step/ghost_help/RS = current_ritual.ritual_steps[current_ritual.current_step]
		if(istype(RS) && RS.check_requirements(user))
			RS.on_success()

/obj/item/weapon/ritual_book/process()
	if(!current_ritual)
		world.log << "stopping proccessing, there is no ritual"
		STOP_PROCESSING(SSobj, src)
		return

	if(loc != ritual_starting_loc)
		world.log << "loc not starting"
		current_ritual.stop()
		return

	if(current_ritual.caster.loc != caster_starting_loc)
		world.log << "caster moved"
		current_ritual.stop()
		return

	var/datum/ritual_step/RS = current_ritual.ritual_steps[current_ritual.current_step]
	if(!RS)
		world.log << "no [RS]"
		current_ritual.stop()
		return

	if(!RS.need_processing)
		world.log << "RS needs not processing"
		return

	world.log << "processing [RS]"

	if(RS.check_requirements())
		RS.on_success()

/obj/item/weapon/ritual_book/hear_talk(mob/M, text, verb, datum/language/speaking)
	if(ritual_in_progress)
		world.log << "in ritual"
		var/datum/ritual_step/talk/RS = current_ritual.ritual_steps[current_ritual.current_step]
		world.log << "[RS]"
		if(RS.check_requirements(M, text, , speaking))
			RS.on_success()
		return
	else
		for(var/datum/ritual/ritual in known_rituals)
			if(text == sanitize(ritual.starting_phrase))
				world.log << "we almost started [ritual.starting_language] [!ritual.starting_language || istype(speaking, ritual.starting_language)]"
				if(!ritual.starting_language || istype(speaking, ritual.starting_language))
					ritual.start(M)
					return

/obj/item/weapon/ritual_book/hear_emote(mob/M, emote, emote_type)
	if(ritual_in_progress)
		var/datum/ritual_step/talk/RS = current_ritual.ritual_steps[current_ritual.current_step]
		if(RS.check_requirements(M, , emote))
			RS.on_success()
		return
	else
		for(var/datum/ritual/ritual in known_rituals)
			if(emote == sanitize(ritual.starting_emote))
				ritual.start(M)
				return

/obj/item/ritual_set

/obj/item/ritual_set/atom_init()
	..()
	new /obj/item/toy/crayon/blue(loc)
	new /obj/item/toy/crayon/purple(loc)
	new /mob/living/carbon/human(loc)
	new /mob/living/carbon/human(loc)
	new /obj/item/weapon/crowbar(loc)
	new /obj/item/weapon/ritual_book(loc)
	return INITIALIZE_HINT_QDEL