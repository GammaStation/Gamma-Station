var/global/list/rituals = list()

/proc/ritual_list_init()
	for(var/type in subtypesof(/datum/ritual))
		var/datum/ritual/R = new type
		if(!R.generatable)
			continue
		if(!R.pools.len)
			continue
		for(var/pool in R.pools)
			if(pool in rituals)
				rituals[pool] += type
			else
				rituals[pool] = list(type)

#define INPUT_RUNE     "#DA00FF" // purple rune's color.
#define OUTPUT_RUNE    "#A8E61D" // green rune's color.
#define CASTER_RUNE    "#00B7EF" // blue rune's color.
#define SACRIFICE_RUNE "#DA0000" // red rune's color.

/datum/ritual
	var/starting_phrase = null // Either of these could potentially start the ritual. Keep null, if you don't want to start it this way.
	var/starting_emote = null
	var/starting_language = null // Store type of language. Not name or obj.

	var/mob/caster = null

	var/name = "" // Name the ritual here, it will be displayed in the book.
	var/desc = "" // Put the generic ritual description here, as in what it does. Most requirements will be generated automagically.

	var/list/rune_requirements = list(INPUT_RUNE = 0, OUTPUT_RUNE = 0, CASTER_RUNE = 0, SACRIFICE_RUNE = 0) // Please consider requiring at least 1 CASTER_RUNE.
	var/list/ritual_step_types = list() // All steps need to be accomplished.
	var/list/ritual_steps = list()
	var/current_step = 1

	var/list/ritual_attributes = list() // A list of items around that may be used in the ritual.

	var/obj/item/weapon/ritual_book/ritual_container = null // An atom that contains this ritual.
	var/list/pools = list("All")
	var/generatable = TRUE // we ignore /datum/ritual by subtypesof anyway.

/datum/ritual/New(rit_container)
	ritual_container = rit_container
	for(var/step_ in ritual_step_types)
		var/datum/ritual_step/RS = new step_(src)
		ritual_steps += RS

/datum/ritual/Destroy()
	QDEL_LIST(ritual_steps)
	ritual_attributes = list()
	ritual_container = null
	caster = null
	return ..()

/datum/ritual/proc/get_desc()

/datum/ritual/proc/start(mob/starter)
	/* Ritual starting proc, does all the needed calculations for you, in case you need to add special effects,
	consider calling parent proc AFTER the special effects. */
	if(!istype(ritual_container.loc, /turf))
		world.log << "not on turf"
		return

	var/list/current_rune_reqs = rune_requirements.Copy()

	for(var/atom/A in view(2, ritual_container))
		if(istype(A, /obj/effect/decal/cleanable/crayon))
			var/obj/effect/decal/cleanable/crayon/C = A
			if(current_rune_reqs[C.rune_color])
				current_rune_reqs[C.rune_color] -= 1
			ritual_attributes += C
		else if(istype(A, /obj/item/candle))
			ritual_attributes += A

	for(var/el in current_rune_reqs)
		if(current_rune_reqs[el] > 0)
			world.log << "[el] is [current_rune_reqs[el]]"
			stop()
			return

	ritual_container.ritual_in_progress = TRUE
	ritual_container.current_ritual = src
	caster = starter

	ritual_container.ritual_starting_loc = get_turf(ritual_container)
	ritual_container.caster_starting_loc = get_turf(caster)

	var/obj/effect/decal/cleanable/crayon/rune = locate(/obj/effect/decal/cleanable/crayon) in get_turf(caster)
	if(!rune || rune.rune_color != CASTER_RUNE) // Caster is not on a caster rune.
		world.log << "no rune under caster"
		stop()

	START_PROCESSING(SSobj, ritual_container)

/datum/ritual/proc/accomplish()
	/* This proc is called after we SUCCESFULLY finish the ritual, if you want to add special effects, consider
	calling parent proc AFTER all the special effects. */
	stop()

/datum/ritual/proc/stop()
	/* This is a technical proc, it is issued each time a ritual forcibly stops(even if requirements are unmet),
	highly unlikely that you would want to add special effects here, but if you do, add the parent call proc
	AFTER all the special effects. */
	for(var/datum/ritual_step/RS in ritual_steps)
		RS.reset()
	ritual_attributes = list()

	current_step = 1

	ritual_container.ritual_starting_loc = null
	ritual_container.caster_starting_loc = null

	ritual_container.ritual_in_progress = FALSE
	ritual_container.current_ritual = null
	caster = null
	STOP_PROCESSING(SSobj, ritual_container)

/datum/ritual_step
	var/name = "" // Ritual step name here.
	var/desc= ""  // Put generic step description here. Most requirements are going to be generated automagically.
	var/need_processing = TRUE      // Some steps, such as talking don't need to be checked in a process.
	var/datum/ritual/ritual = null
	var/accomplished = FALSE

/datum/ritual_step/New(rit_)
	ritual = rit_

/datum/ritual_step/proc/reset()
/* This proccompletely resets the ritual to it's unaccomplished form. Feel free to issue it in on_fail() if required. */
	accomplished = FALSE

/datum/ritual_step/proc/get_desc()

/datum/ritual_step/proc/on_success()
	/* check_requirements proc of this step returned true. If you wish to add special effects, call parent proc
	AFTER the effects. */
	reset()
	if(ritual.current_step == ritual.ritual_steps.len)
		ritual.accomplish()
	else
		ritual.current_step++

/datum/ritual_step/proc/check_requirements()
	/* Here we check all the requirements to accomplish a step, if you return FALSE - step is not done yet, if you
	return TRUE - on_success() will be called. If you want to punish players for being idiots add on_fail() proc
	somewhere. */
	return FALSE

/datum/ritual_step/proc/on_fail()
	/* Call this proc in check_requirements when you feel like you need to screw over the player*/

/datum/ritual_step/sacrifice
	var/list/last_victim_damage = list() // Contains the health of each individual victim. In form of real_name = health.

	var/damage_to_deal = 0          // Damaged needed to deal to accomplish the ritual.
	var/count_dam_types = list() // Damage types that are counted towards the damage goal.

/datum/ritual_step/sacrifice/check_requirements()
	var/mob/living/victim = null
	world.log << "I AM BEING PROCCESSED"
	to_chat(ritual.caster, ritual.ritual_attributes)
	for(var/obj/effect/decal/cleanable/crayon/rune in ritual.ritual_attributes)
		if(rune.rune_color == SACRIFICE_RUNE)
			world.log << "I AM A SACRIFICE RUNE"
			victim = locate(/mob/living) in get_turf(rune)
			if(victim)
				world.log << victim
				var/new_dam = victim.getDamageOfTypes(count_dam_types)
				world.log << new_dam
				if(last_victim_damage[victim.real_name] < new_dam)
					world.log << "test"
					damage_to_deal -= new_dam - last_victim_damage[victim.real_name]
					last_victim_damage[victim.real_name] = new_dam
					if(damage_to_deal <= 0)
						return TRUE
	return FALSE

/datum/ritual_step/sacrifice/reset()
	..()
	damage_to_deal = initial(damage_to_deal)
	count_dam_types = list()

/datum/ritual_step/item_sacrifice
	var/list/item_type_chances = list() // type = probability(1 to 100)

/datum/ritual_step/item_sacrifice/proc/sacrifice_item(atom/movable/sacrificed)
/* This proc determines what we do to the item if the sacrifice is succesful, is called before on_success() proc. */
	return

/datum/ritual_step/item_sacrifice/on_fail(atom/movable/sacrificed)
	sacrificed.throw_at(ritual.caster, 5, 10, ritual.caster)

/datum/ritual_step/item_sacrifice/check_requirements()
	var/atom/movable/sacrificed = null
	for(var/obj/effect/decal/cleanable/crayon/rune in ritual.ritual_attributes)
		if(rune.rune_color == INPUT_RUNE)
			for(var/type in item_type_chances)
				sacrificed = locate(type) in get_turf(rune)
				if(sacrificed)
					if(prob(item_type_chances[type]))
						sacrifice_item(sacrificed)
						return TRUE
					on_fail()
	return FALSE

/datum/ritual_step/ghost_help
/* Is handled in ritual_book /attack_ghost(). */
	need_processing = FALSE
	var/ghost_clicks_required = 1
	var/list/names_clicked = list()

/datum/ritual_step/ghost_help/reset()
	..()
	names_clicked = list()
	ghost_clicks_required = initial(ghost_clicks_required)

/datum/ritual_step/ghost_help/check_requirements(mob/user)
	if(!(user.name in names_clicked))
		names_clicked += user.name
		ghost_clicks_required--
		if(ghost_clicks_required <= 0)
			return TRUE
	return FALSE

/datum/ritual_step/check_attributes
/* This step is intentionally generalised. There is nothing to it, here we check if candles are lit, if lights are
off, and stuff like that. Reaaaaaaally important stuff in general. */

/datum/ritual_step/talk
	need_processing = FALSE
	var/hear_message = null
	var/hear_emote = null
	var/required_language = null // This could be fun. Store type, not object.

/datum/ritual_step/talk/check_requirements(mob/M, message, emote, datum/language/L)
	if(required_language && istype(L, required_language))
		world.log << "wrong lang"
		return FALSE
	if(hear_message && message == sanitize(hear_message))
		return TRUE
	if(hear_emote && emote == sanitize(hear_emote))
		return TRUE
	world.log << "none"
	return FALSE

/datum/ritual_step/talk/chorus
	var/people_repeated = 0
	var/people_need_to_repeat = 2

	var/people_failed_to_repeat = 0
	var/fail_on_bad_repeats = 2

	var/last_said = 0 // Last time somebody did say the phrase and we recorded it.
	var/last_said_delay = 5 SECONDS // if we record somebody saying the phrase after this much time of the step starting, we just declare failure.

	var/list/names_talked = list()

/datum/ritual_step/talk/chorus/reset()
	..()
	names_talked = list()
	people_repeated = initial(people_repeated)
	people_failed_to_repeat = initial(people_failed_to_repeat)
	last_said = 0

/datum/ritual_step/talk/chorus/check_requirements(mob/M, message, emote, datum/language/L)
	if(..())
		if(!(M.real_name in names_talked))
			names_talked += M.real_name
			last_said = world.time
			people_repeated++
	else
		people_failed_to_repeat++

	if(world.time > last_said + last_said_delay)
		on_fail()
		return FALSE

	if(people_failed_to_repeat >= fail_on_bad_repeats)
		on_fail()
		return FALSE

	if(people_repeated >= people_need_to_repeat)
		return TRUE

/datum/ritual_step/talk/chorus/on_fail()
	names_talked = list()

/* ACTUAL RITUAL STEPS BEGIN HERE */

/datum/ritual/evil_summon
	name = "The Ancient Evil Summoning"
	starting_phrase = "Cachoochoo fuhtan ta ta"
	rune_requirements = list(CASTER_RUNE = 1, SACRIFICE_RUNE = 1, OUTPUT_RUNE = 1)

	var/evil_type = /mob/living/simple_animal/cat // By default THE GREAT EVIL is a kitten.See check_requirements/evil_summon step.

	ritual_step_types = list(/datum/ritual_step/sacrifice/evil_summon)

/datum/ritual_step/sacrifice/evil_summon
	name = "Bloodletting"
	damage_to_deal = 10
	count_dam_types = list(BRUTE)

/datum/ritual/evil_summon/accomplish()
	for(var/obj/effect/decal/cleanable/crayon/rune in ritual_attributes)
		var/turf/T = get_turf(rune)
		if(rune.rune_color == OUTPUT_RUNE)
			new /obj/effect/effect/smoke(T)
			playsound(get_turf(src), 'sound/effects/screech.ogg', 50, 0)
			new evil_type(T)
		else if(rune.rune_color != CASTER_RUNE)
			var/obj/fire/F = new(T)
			QDEL_IN(F, 2 SECONDS)
		for(var/obj/machinery/light/L in view(3, get_turf(rune)))
			if(prob(50))
				L.flicker()
			else
				L.on = TRUE
				L.broken()
			sleep(1)
		sleep(1)
	..()

/datum/ritual/exampler
	name = "Cthulhu"
	starting_phrase = "Cthulhu fhtagn"
	rune_requirements = list(CASTER_RUNE = 1, SACRIFICE_RUNE = 1)

	ritual_step_types = list(/datum/ritual_step/talk/exampler, /datum/ritual_step/sacrifice/exampler) // All steps need to be accomplished.

/datum/ritual/exampler/accomplish()
	world.log << "SUCCESS"
	..()

/datum/ritual_step/talk/exampler
	name = "exampler talk"
	hear_message = "Fhtagn!"

/datum/ritual_step/sacrifice/exampler
	name = "exampler sacrifice"
	damage_to_deal = 10
	count_dam_types = list(BRUTE)
