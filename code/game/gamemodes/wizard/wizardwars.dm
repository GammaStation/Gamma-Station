/datum/game_mode/wizardwars
	name = "wizard wars"
	config_tag = "wizard wars"
	role_type = ROLE_WIZARD
	required_players = 2
	required_players_secret = 30
	required_enemies = 2
	recommended_enemies = 2

	var/datum/mind/redwizard
	var/datum/mind/bluewizard

	var/redscore = 0
	var/bluescore = 0
	var/redlifes = WIZARD_STARTING_LIFES
	var/bluelifes = WIZARD_STARTING_LIFES


	var/finished = FALSE
	votable = TRUE

/datum/game_mode/wizardwars/announce()
	to_chat(world, "<B>The current game mode is - Wizard Wars!</B>")
	to_chat(world, "<B>Wizards from opposing magic schools chose the station as their battlefield! Kick them away!</B>")

/datum/game_mode/wizardwars/can_start()
	if(!..())
		return FALSE

	if(!wizardstart.len)
		to_chat(world, "<span class='danger'>A starting location for wizard could not be found, please report this bug!</span>")
		return FALSE
	return TRUE

/datum/game_mode/wizardwars/pre_setup()
	var/datum/mind/wizard = pick(antag_candidates)
	wizard.assigned_role = "MODE"
	wizard.make_wizard()
	wizard.original = wizard.current
	modePlayer += wizard
	bluewizard = wizard
	wizard.current.loc = pick(wizardstart)

	antag_candidates -= wizard

	wizard = pick(antag_candidates)
	wizard.assigned_role = "MODE"
	wizard.make_wizard()
	wizard.original = wizard.current
	modePlayer += wizard
	redwizard = wizard
	wizard.current.loc = pick(wizardstart)

	return TRUE

/datum/game_mode/wizardwars/post_setup()
	equip_wizard(redwizard.current)
	name_wizard(redwizard.current)
	greet_wizard(redwizard)

	equip_wizard(bluewizard.current)
	name_wizard(bluewizard.current)
	greet_wizard(bluewizard)

	return ..()


/datum/game_mode/wizardwars/proc/compare_scores(var/score1, var/score2)
	if(score1 < CREW_VICTORY_TRESHOLD)
		return "<font color = 'red'>[score1] (Less than [CREW_VICTORY_TRESHOLD])</font>"
	if(score1 < score2)
		return "<font color = 'red'>[score1] (Defeat)</font>"
	else if(score1 > score2)
		return "<font color = 'green'>[score1] (Victory)</font>"
	else
		return "<font color = 'gray'>[score1] (Draw)</font>"



/datum/game_mode/wizardwars/declare_completion()
	var/final_text = ""
	completion_text += "<B>Wizard mode resume:</B><BR>"

	final_text += "<div align='center'><FONT size = 4><B>The clash of wizards is over!</B></FONT></div>"
	final_text += "<table border=0 align = 'center' rules=all frame=void cellspacing=0 cellpadding=5><tr><td align = 'left'><b>[redwizard.name]</b><i>(played by [redwizard.key])</i></td><th>VS</th><td align = 'right'><b>[bluewizard.name]</b><i>(played by [bluewizard.key])</i></td></tr>"


	var/overallscorered = round(redscore * redlifes/WIZARD_STARTING_LIFES)
	var/overallscoreblue = round(bluescore * bluelifes/WIZARD_STARTING_LIFES)

	final_text += "<tr><td align = 'left'><b>Overall score: [(redscore!=overallscorered) ? "[redscore] - <font color = 'red'>[redscore-overallscorered](Resurrections)</font> = " : null][compare_scores(overallscorered,overallscoreblue)]</b></td><th></th><td align = 'right'><b>Overall score: [(bluescore!=overallscoreblue) ? "[bluescore] - <font color = 'red'>[bluescore-overallscoreblue](Resurrections)</font> = " : null][compare_scores(overallscoreblue,overallscorered)]</b></td></tr></table>"

	if(overallscorered < CREW_VICTORY_TRESHOLD && overallscoreblue < CREW_VICTORY_TRESHOLD)
		feedback_set_details("round_end_result","crew won")
		final_text += "<FONT size = 3>Station crew managed to thwart the wizard clash and kick both mages away. The crew <b><font color = 'green'>won!</font></b> Space Wizard Federation will never forget this shame!</FONT>"

	else if(overallscorered > overallscoreblue)
		feedback_set_details("round_end_result","red wizard won")
		final_text += "<FONT size = 3>[redwizard.name] <b><font color = 'green'>triumphs!</font></b> [bluewizard.name] will never forget this humiliating defeat!</FONT>"

	else if(overallscorered < overallscoreblue)
		feedback_set_details("round_end_result","blue wizard won")
		final_text += "<FONT size = 3>[bluewizard.name] <b><font color = 'green'>triumphs!</font></b> [redwizard.name] will never forget this humiliating defeat!</FONT>"

	else if(overallscorered == overallscoreblue)
		feedback_set_details("round_end_result","draw")
		final_text += "<FONT size = 3>The clash resulted in a tie between wizards! There is no victor in this clash!</FONT>"
	completion_text += "[final_text]"
	..()
	return 1


#undef CREW_VICTORY_TRESHOLD
#undef WIZARD_STARTING_LIFES
