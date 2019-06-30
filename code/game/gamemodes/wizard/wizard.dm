/datum/game_mode/wizard
	name = "wizard"
	config_tag = "wizard"
	role_type = ROLE_WIZARD
	required_players = 1
	required_players_secret = 10
	required_enemies = 1
	recommended_enemies = 1

	votable = 0

	uplink_welcome = "Wizardly Uplink Console:"
	uplink_uses = 20

	var/finished = 0

/datum/game_mode/wizard/announce()
	to_chat(world, "<B>The current game mode is - Wizard!</B>")
	to_chat(world, "<B>There is a \red SPACE WIZARD\black on the station. You can't let him achieve his objective!</B>")


/datum/game_mode/wizard/can_start()
	if(!..())
		return FALSE

	if(!LAZYLEN(wizardstart))
		to_chat(world, "<span class='danger'>A starting location for wizard could not be found, please report this bug!</span>")
		return FALSE
	return TRUE


/datum/game_mode/wizard/pre_setup()
	for(var/datum/mind/wizard in wizards)
		wizard.current.loc = pick(wizardstart)

	var/datum/mind/wizard = pick(antag_candidates)
	wizard.assigned_role = "MODE"
	wizard.original = wizard.current
	wizard.make_wizard()
	modePlayer += wizard
	wizard.current.loc = pick(wizardstart)
	return 1


/datum/game_mode/wizard/post_setup()
	for(var/datum/mind/wizard in wizards)
		if(!config.objectives_disabled)
			forge_wizard_objectives(wizard)
		equip_wizard(wizard.current)
		name_wizard(wizard.current)
		greet_wizard(wizard)
		wizard.add_all_spells()

	return ..()


/datum/game_mode/wizard/check_finished()

	if(config.continous_rounds)
		return ..()

	var/wizards_alive = 0
	for(var/datum/mind/wizard in wizards)
		if(!istype(wizard.current,/mob/living/carbon))
			continue
		if(wizard.current.stat==2)
			continue
		wizards_alive++

	if (wizards_alive)
		return ..()
	else
		finished = 1
		return 1



/datum/game_mode/wizard/declare_completion()
	var/prefinal_text = ""
	var/final_text = ""
	completion_text += "<B>Wizard mode resume:</B><BR>"

	for(var/datum/mind/wizard in wizards)
		if(wizard.current.stat == DEAD || finished)
			feedback_set_details("round_end_result","loss - wizard killed")
			prefinal_text = "<FONT size = 3>Wizard <b>[wizard.name]</b><i> ([wizard.key])</I> has been <font color='red'><b>killed</b></font by the crew! The Space Wizards Federation has been taught a lesson they will not soon forget!</FONT><BR>"
		else
			var/failed = 0
			for(var/datum/objective/objective in wizard.objectives)
				if(!objective.check_completion())
					failed = 1
			if(!failed)
				feedback_set_details("round_end_result","win - wizard alive")
				prefinal_text = "<FONT size = 3>Wizard <b>[wizard.name]</b><i> ([wizard.key])</i> managed to <font color='green'><B>complete</B></font> his mission! The Space Wizards Federation understood that station crew - easy target and will use them next time.</FONT><BR>"
			else
				feedback_set_details("round_end_result","loss - wizard alive")
				prefinal_text = "<FONT size = 3>Wizard <b>[wizard.name]</b><i> ([wizard.key])</i> managed to stay alive, but <font color='red'><B>failed</B></font> his mission! The Space Wizards Federation wouldn't forget this shame!</FONT><BR>"
		final_text += "[prefinal_text]"

	completion_text += "[final_text]"
	..()
	return 1


