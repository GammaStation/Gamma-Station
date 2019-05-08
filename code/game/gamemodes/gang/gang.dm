//gang.dm
//Gang War Game Mode

/datum/game_mode
	var/list/datum/mind/A_gang = list() //gang A Members
	var/list/datum/mind/B_gang = list() //gang B Members
	var/list/datum/mind/A_bosses = list() //gang A Bosses
	var/list/datum/mind/B_bosses = list() //gang B Bosses
	var/obj/item/device/gangtool/A_tools = list()
	var/obj/item/device/gangtool/B_tools = list()
	var/datum/gang_points/gang_points
	var/A_style
	var/B_style
	var/list/A_territory = list()
	var/list/B_territory = list()
	var/list/A_territory_new = list()
	var/list/A_territory_lost = list()
	var/list/B_territory_new = list()
	var/list/B_territory_lost = list()

/datum/game_mode/gang
	name = "gang war"
	config_tag = "gang"
	role_type = ROLE_GANG
	restricted_jobs = list("Star Vigil Officer", "Star Vigil Sergeant", "Detective", "AI", "Cyborg","Captain", "Head of Personnel", "Star Vigil Commander", "Chief Engineer", "Research Director", "Chief Medical Officer", "Internal Affairs Agent")
	required_players = 15
	required_players_secret = 15
	required_enemies = 2
	recommended_enemies = 4
	var/finished = 0
	// Victory timers
	var/A_timer = "OFFLINE"
	var/B_timer = "OFFLINE"
	//How many attempts at domination each team is allowed
	var/A_dominations = 2
	var/B_dominations = 2
	votable = 0

///////////////////////////
//Announces the game type//
///////////////////////////
/datum/game_mode/gang/announce()
	to_chat(world, "<B>The current game mode is - Gang War!</B>")
	to_chat(world, "<B>A violent turf war has erupted on the station!<BR>Gangsters -  Take over the station by activating and defending a Dominator! <BR>Crew - The gangs will try to keep you on the station. Successfully evacuate the station to win!</B>")

///////////////////////////////////////////////////////////////////////////////
//Gets the round setup, cancelling if there's not enough players at the start//
///////////////////////////////////////////////////////////////////////////////
/datum/game_mode/gang/pre_setup()

	if(config.protect_roles_from_antagonist)
		restricted_jobs += protected_jobs

	for(var/datum/mind/player in antag_candidates)
		for(var/job in restricted_jobs)//Removing heads and such from the list
			if(player.assigned_role == job)
				antag_candidates -= player

	if(antag_candidates.len >= 2)
		assign_bosses(antag_candidates)

	if(!A_bosses.len || !B_bosses.len)
		return 0

	return 1


/datum/game_mode/gang/post_setup()
	spawn(rand(10,100))
		for(var/datum/mind/boss_mind in A_bosses)
			boss_mind.current.verbs += /mob/living/carbon/human/proc/gang_convert
			update_gang_icons_added(boss_mind, "A")
			forge_gang_objectives(boss_mind, "A")
			greet_gang(boss_mind)
			equip_gang(boss_mind.current)

		for(var/datum/mind/boss_mind in B_bosses)
			boss_mind.current.verbs += /mob/living/carbon/human/proc/gang_convert
			update_gang_icons_added(boss_mind, "B")
			forge_gang_objectives(boss_mind, "B")
			greet_gang(boss_mind)
			equip_gang(boss_mind.current)

	modePlayer += A_bosses
	modePlayer += B_bosses
	return ..()

/datum/game_mode/gang/process()
	if(!finished)
		if(isnum(A_timer))
			A_timer -= 2
		if(isnum(B_timer))
			B_timer -= 2

		check_win()

/datum/game_mode/gang/proc/assign_bosses(list/antag_candidates = list())
	var/datum/mind/boss = pick(antag_candidates)
	A_bosses += boss
	antag_candidates -= boss
	boss.special_role = "[gang_name("A")] Gang (A) Boss"
	log_game("[boss.key] has been selected as the boss for the [gang_name("A")] Gang (A)")

	boss = pick(antag_candidates)
	B_bosses += boss
	antag_candidates -= boss
	boss.special_role = "[gang_name("B")] Gang (B) Boss"
	log_game("[boss.key] has been selected as the boss for the [gang_name("B")] Gang (B)")

/datum/game_mode/proc/forge_gang_objectives(datum/mind/boss_mind)
	if(istype(ticker.mode, /datum/game_mode/gang))
		var/datum/objective/rival_obj = new
		rival_obj.owner = boss_mind
		rival_obj.explanation_text = "Preform a hostile takeover of the station with a Dominator."
		boss_mind.objectives += rival_obj


/datum/game_mode/proc/greet_gang(datum/mind/boss_mind, you_are=1)
	var/obj_count = 1
	if (you_are)
		to_chat(boss_mind.current, "<FONT size=3 color=red><B>You are the founding member of the [(boss_mind in A_bosses) ? gang_name("A") : gang_name("B")] Gang!</B></FONT>")
	for(var/datum/objective/objective in boss_mind.objectives)
		to_chat(boss_mind.current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
		obj_count++

/datum/game_mode/gang/proc/domination(gang,modifier=1,obj/dominator)
	if(gang=="A")
		A_timer = max(300,900 - ((round((A_territory.len/start_state.num_territories)*200, 1) - 60) * 15)) * modifier
	if(gang=="B")
		B_timer = max(300,900 - ((round((B_territory.len/start_state.num_territories)*200, 1) - 60) * 15)) * modifier
	if(gang && dominator)
		var/area/domloc = get_area(dominator.loc)
		captain_announce("Network breach detected in [initial(domloc.name)]. The [gang_name(gang)] Gang is attempting to seize control of the station!")
		set_security_level("delta")
		//SSshuttle.emergencyNoEscape = 1

///////////////////////////////////////////////////////////////////////////
//This equips the bosses with their gear, and makes the clown not clumsy//
///////////////////////////////////////////////////////////////////////////
/datum/game_mode/proc/equip_gang(mob/living/carbon/human/mob)
	if(!istype(mob))
		return

	if (mob.mind)
		if (mob.mind.assigned_role == "Clown")
			to_chat(mob, "Your training has allowed you to overcome your clownish nature, allowing you to wield weapons without harming yourself.")
			mob.mutations.Remove(CLUMSY)

	var/obj/item/device/gangtool/gangtool = new(mob)
	var/obj/item/toy/crayon/spraycan/gang/SC = new(mob)

	var/list/slots = list (
		"backpack" = slot_in_backpack,
		"left pocket" = slot_l_store,
		"right pocket" = slot_r_store,
		"left hand" = slot_l_hand,
		"right hand" = slot_r_hand,
	)

	. = 0

	var/where = mob.equip_in_one_of_slots(gangtool, slots)
	if (!where)
		to_chat(mob, "Your Syndicate benefactors were unfortunately unable to get you a Gangtool.")
		. += 1
	else
		gangtool.register_device(mob)
		to_chat(mob, "The <b>Gangtool</b> in your [where] will allow you to purchase items, send messages to your gangsters and recall the emergency shuttle from anywhere on the station.")
		to_chat(mob, "You can also promote your gang members to <b>lieutenant</b> by having them use an unregistered gangtool. Unlike regular gangsters, Lieutenants cannot be deconverted and are able to use recruitment pens and gangtools.")

	var/where2 = mob.equip_in_one_of_slots(SC, slots)
	if (!where2)
		to_chat(mob, "Your Syndicate benefactors were unfortunately unable to get you a territory spraycan to start.")
		. += 1
	else
		to_chat(mob, "The <b>territory spraycan</b> in your [where2] can be used to claim areas of the station for your gang. The more territory your gang controls, the more influence you get. All gangsters can use these, so distribute them to grow your influence faster.")
	mob.update_icons()

	return .


//Used by recallers when purchasing a gang outfit. First time a gang outfit is purchased the buyer decides a gang style which is stored so gang outfits are uniform
/datum/game_mode/proc/gang_outfit(mob/user,obj/item/device/gangtool/gangtool,gang)
	if(!user || !gangtool || !gang)
		return 0
	if(!gangtool.can_use(user))
		return 0

	if(gangtool.can_use(user) && (((gang == "A") ? gang_points.A : gang_points.B) >= 1))
		new /obj/item/device/kevlar_kit(user.loc)
		return 1
	return 0

/////////////////////////////////////////////
//Checks if the either gang have won or not//
/////////////////////////////////////////////
/datum/game_mode/gang/check_win()
	var/winner = 0

	if(isnum(A_timer))
		if(A_timer < 0)
			winner += 1
	if(isnum(B_timer))
		if(B_timer < 0)
			winner += 2

	if(winner)
		if(winner == 3) //Edge Case: If both dominators activate at the same time
			domination("A",0.5)
			domination("B",0.5)
			captain_announce("Multiple station takeover attempts have made simultaneously. Conflicting hostile runtimes appears to have delayed both attempts.")
		else if(winner == 1)
			finished = "A" //Gang A wins
		else if(winner == 2)
			finished = "B" //Gang B wins

///////////////////////////////
//Checks if the round is over//
///////////////////////////////
/datum/game_mode/gang/check_finished()
	if(finished)
		return 1
	return ..() //Check for evacuation/nuke

///////////////////////////////////////////
//Deals with converting players to a gang//
///////////////////////////////////////////
/datum/game_mode/proc/add_gangster(datum/mind/gangster_mind, gang, check = 1)
	if(gangster_mind in (A_bosses | A_gang | B_bosses | B_gang))
		return 0
	if(check && ismindshielded(gangster_mind.current)) //Check to see if the potential gangster is implanted
		return 1
	if(gang == "A")
		A_gang += gangster_mind
	else
		B_gang += gangster_mind
	to_chat(gangster_mind.current, "<FONT size=3 color=red><B>You are now a member of the [gang=="A" ? gang_name("A") : gang_name("B")] Gang!</B></FONT>")
	to_chat(gangster_mind.current, "<font color='red'>Help your bosses take over the station by claiming territory with <b>special spraycans</b> only they can provide. Simply spray on any unclaimed area of the station.</font>")
	to_chat(gangster_mind.current, "<font color='red'>You can identify your bosses by their <b>red \[G\] icon</b>.</font>")
	gangster_mind.current.attack_log += "\[[time_stamp()]\] <font color='red'>Has been converted to the [gang=="A" ? "[gang_name("A")] Gang (A)" : "[gang_name("B")] Gang (B)"]!</font>"
	gangster_mind.special_role = "[gang=="A" ? "[gang_name("A")] Gang (A)" : "[gang_name("B")] Gang (B)"]"
	update_gang_icons_added(gangster_mind,gang)
	return 2
////////////////////////////////////////////////////////////////////
//Deals with players reverting to neutral (Not a gangster anymore)//
////////////////////////////////////////////////////////////////////
/datum/game_mode/proc/remove_gangster(datum/mind/gangster_mind, beingborged, silent, exclude_bosses=0)
	var/gang

	if(!exclude_bosses)
		if(gangster_mind in A_bosses)
			A_bosses -= gangster_mind
			gang = "A"

		if(gangster_mind in B_bosses)
			B_bosses -= gangster_mind
			gang = "B"

	if(gangster_mind in A_gang)
		A_gang -= gangster_mind
		gang = "A"

	if(gangster_mind in B_gang)
		B_gang -= gangster_mind
		gang = "B"

	if(!gang) //not a valid gangster
		return

	gangster_mind.special_role = null
	if(silent < 2)
		gangster_mind.current.attack_log += "\[[time_stamp()]\] <font color='red'>Has reformed and defected from the [gang=="A" ? "[gang_name("A")] Gang (A)" : "[gang_name("B")] Gang (B)"]!</font>"

		if(beingborged)
			if(!silent)
				gangster_mind.current.visible_message("The frame beeps contentedly from the MMI before initalizing it.")
			to_chat(gangster_mind.current, "<FONT size=3 color=red><B>The frame's firmware detects and deletes your criminal behavior! You are no longer a gangster!</B></FONT>")
			message_admins("[key_name_admin(gangster_mind.current)] <A HREF='?_src_=holder;adminmoreinfo=\ref[gangster_mind.current]'>?</A> has been borged while being a member of the [gang=="A" ? "[gang_name("A")] Gang (A)" : "[gang_name("B")] Gang (B)"] Gang. They are no longer a gangster.")
		else
			if(!silent)
				gangster_mind.current.Paralyse(5)
				gangster_mind.current.visible_message("<FONT size=3><B>[gangster_mind.current] looks like they've given up the life of crime!<B></font>")
			to_chat(gangster_mind.current, "<FONT size=3 color=red><B>You have been reformed! You are no longer a gangster!</B><BR>You try as hard as you can, but you can't seem to recall any of the identities of your former gangsters...</FONT>")

	update_gang_icons_removed(gangster_mind)


/////////////////////////////////////////////////////////////////////////////////////////////////
//Keeps track of players having the correct icons////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/datum/game_mode/proc/update_all_gang_icons()
	var/list/all_gangsters = A_bosses + B_bosses + A_gang + B_gang

	//Delete all gang icons
	for(var/datum/mind/mind in all_gangsters)
		if(!mind.current || !mind.current.client)
			continue
		for(var/image/I in mind.current.client)
			if(I.icon_state == "gang_boss" || I.icon_state == "gangsters")
				mind.current.client.images -= I
				qdel(I)

		update_gang_icons("A")
		update_gang_icons("B")

/datum/game_mode/proc/update_gang_icons(gang)
	var/list/all_gangsters
	var/list/bosses
	if(gang == "A")
		all_gangsters = A_bosses + A_gang
		bosses = A_bosses
	else if(gang == "B")
		all_gangsters = B_bosses + B_gang
		bosses = B_bosses
	else
		to_chat(world, "ERROR: Invalid gang in update_gang_icons()")

	for(var/datum/mind/mind in all_gangsters)
		if(!mind.current || !mind.current.client)
			continue
		for(var/datum/mind/mind2 in all_gangsters)
			if(!mind2.current)
				continue
			var/I
			if(mind2 in bosses)
				I = image('icons/mob/mob.dmi', loc = mind2.current, icon_state = "gang_boss")
			else
				I = image('icons/mob/mob.dmi', loc = mind2.current, icon_state = "gangster")
			mind.current.client.images += I
			I = null

/////////////////////////////////////////////////
//Assigns icons when a new gangster is recruited//
/////////////////////////////////////////////////
/datum/game_mode/proc/update_gang_icons_added(datum/mind/recruit_mind, gang)
	var/list/all_gangsters
	var/list/bosses
	if(gang == "A")
		all_gangsters = A_bosses + A_gang
		bosses = A_bosses
	else if(gang == "B")
		all_gangsters = B_bosses + B_gang
		bosses = B_bosses
	if(!gang)
		to_chat(world, "ERROR: Invalid gang in update_gang_icons_added()")

	for(var/datum/mind/mind in all_gangsters)
		if(!recruit_mind.current || !recruit_mind.current.client || !mind.current)
			return
		var/I
		if(mind in bosses)
			I = image('icons/mob/mob.dmi', loc = mind.current, icon_state = "gang_boss")
		else
			I = image('icons/mob/mob.dmi', loc = mind.current, icon_state = "gangster")
		recruit_mind.current.client.images += I
		I = null
		if(!mind.current || !mind.current.client || !recruit_mind.current)
			continue
		var/K
		if(recruit_mind in bosses)
			K = image('icons/mob/mob.dmi', loc = recruit_mind.current, icon_state = "gang_boss")
		else
			K = image('icons/mob/mob.dmi', loc = recruit_mind.current, icon_state = "gangster")
		mind.current.client.images += K
		K = null

////////////////////////////////////////
//Keeps track of deconverted gangsters//
////////////////////////////////////////
/datum/game_mode/proc/update_gang_icons_removed(datum/mind/defector_mind)
	var/list/all_gangsters = A_bosses + B_bosses + A_gang + B_gang

	for(var/datum/mind/mind in all_gangsters)
		if(!mind.current || !mind.current.client)
			continue
		for(var/image/I in mind.current.client.images)
			if((I.icon_state == "gangster" || I.icon_state == "gang_boss") && I.loc == defector_mind.current)
				mind.current.client.images -= I
				qdel(I)

	if(!defector_mind.current.client)
		return
	for(var/image/I in defector_mind.current.client.images)
		if(I.icon_state == "gangster" || I.icon_state == "gang_boss")
			defector_mind.current.client.images -= I
			qdel(I)
//////////////////////////////////////////////////////////////////////
//Announces the end of the game with all relavent information stated//
//////////////////////////////////////////////////////////////////////
/datum/game_mode/gang/declare_completion()
	completion_text += "<B>Gang mode resume:</B><BR>"
	if(!finished)
		completion_text += "<FONT size=3 color=red><B>The station was [station_was_nuked ? "destroyed!" : "evacuated before either gang could claim it!"]</B></FONT>"
	else
		completion_text += "<FONT size=3 color=red><B>The [finished=="A" ? gang_name("A") : gang_name("B")] Gang successfully performed a hostile takeover of the station!!</B></FONT>"
		score["roleswon"]++
	..()
	return 1

/datum/game_mode/proc/auto_declare_completion_gang()
	var/winner
	var/text = ""
	var/datum/game_mode/gang/game_mode = ticker.mode
	if(istype(game_mode))
		if(game_mode.finished)
			winner = game_mode.finished
		else
			winner = "Draw"
	if(A_bosses.len || A_gang.len || B_bosses.len || B_gang.len)
		text += printlogo("gang", "gangsters")

		if(A_bosses.len || A_gang.len)
			if(winner)
				text += "<BR><B>The [gang_name("A")] Gang was [winner=="A" ? "<font color=green>victorious</font>" : "<font color=red>defeated</font>"] with [round((A_territory.len/start_state.num_territories)*100, 1)]% control of the station!</B>"
			text += "<BR><B>The [gang_name("A")] Gang Bosses were:</B>"
			text += gang_membership_report(A_bosses)
			text += "<BR><B>The [gang_name("A")] Gangsters were:</B>"
			text += gang_membership_report(A_gang)
			text += "<BR>"

		if(B_bosses.len || B_gang.len)
			if(winner)
				text += "<BR><B>The [gang_name("B")] Gang was [winner=="B" ? "<font color=green>victorious</font>" : "<font color=red>defeated</font>"] with [round((B_territory.len/start_state.num_territories)*100, 1)]% control of the station!</B>"
			text += "<BR>The [gang_name("B")] Gang Bosses were:"
			text += gang_membership_report(B_bosses)
			text += "<BR>The [gang_name("B")] Gangsters were:"
			text += gang_membership_report(B_gang)
			text += "<BR>"
		text += "<HR>"
	return text

/datum/game_mode/proc/gang_membership_report(list/membership)
	var/text = ""
	var/tempstate = end_icons.len
	for(var/datum/mind/gangster in membership)
		if(gangster.current)
			var/icon/flat = getFlatIcon(gangster.current,exact=1)
			end_icons += flat
			tempstate = end_icons.len
			text += {"<BR><img src="logo_[tempstate].png"> <B>[gangster.key]</B> was <B>[gangster.name]</B> ("}
			if(gangster.current.stat == DEAD || isbrain(gangster.current))
				text += "died"
				flat.Turn(90)
				end_icons[tempstate] = flat
			else if(gangster.current.z != ZLEVEL_STATION)
				text += "fled the station"
			else
				text += "survived"
			if(gangster.current.real_name != gangster.name)
				text += " as <B>[gangster.current.real_name]</B>"
		else
			var/icon/sprotch = icon('icons/effects/blood.dmi', "gibbearcore")
			end_icons += sprotch
			tempstate = end_icons.len
			text += {"<BR><img src="logo_[tempstate].png"> [gangster.key] was [gangster.name] ("}
			text += "body destroyed"
		text += ")"
	return text


//////////////////////////////////////////////////////////
//Handles influence, territories, and the victory checks//
//////////////////////////////////////////////////////////

/datum/gang_points
	var/A = 15
	var/B = 15
	var/next_point_interval = 1800
	var/next_point_time

/datum/gang_points/proc/start()
	next_point_time = world.time + next_point_interval
	spawn(next_point_interval)
		income()

/datum/gang_points/proc/income()
	var/A_added_names = ""
	var/B_added_names = ""
	var/A_lost_names = ""
	var/B_lost_names = ""

	//Process lost territories
	for(var/area in ticker.mode.A_territory_lost)
		if(A_lost_names == "")
			A_lost_names += ":<br>"
		else
			A_lost_names += ", "
		A_lost_names += "[ticker.mode.A_territory_lost[area]], "
		ticker.mode.A_territory -= area

	for(var/area in ticker.mode.B_territory_lost)
		if(B_lost_names == "")
			B_lost_names += ":<br>"
		else
			B_lost_names += ", "
		B_lost_names += "[ticker.mode.B_territory_lost[area]], "
		ticker.mode.B_territory -= area

	var/datum/game_mode/gang/gangmode
	if(istype(ticker.mode, /datum/game_mode/gang))
		gangmode = ticker.mode

	//Count uniformed gangsters
	var/A_uniformed = 0
	var/B_uniformed = 0
	for(var/datum/mind/gangmind in (ticker.mode.A_gang|ticker.mode.A_bosses|ticker.mode.B_gang|ticker.mode.B_bosses))
		if(ishuman(gangmind.current))
			var/mob/living/carbon/human/gangster = gangmind.current
			//Gangster must be alive and on station
			if((gangster.stat == DEAD) || (gangster.z > ZLEVEL_STATION))
				continue

			var/obj/item/clothing/outfit
			var/obj/item/clothing/gang_outfit
			if(gangster.wear_suit)
				outfit = gangster.wear_suit
				if(outfit.gang)
					gang_outfit = outfit

			if(gang_outfit)
				to_chat(gangster, "<span class='notice'>The [gang_name(gang_outfit.gang)] Gang's influence grows as you wear [gang_outfit].</span>")
				if(gang_outfit.gang == "A")
					A_uniformed ++
				else
					B_uniformed ++

	//Calculate and report influence growth
	ticker.mode.message_gangtools(ticker.mode.A_tools,"*---------*<br><b>[gang_name("A")] Gang Status Report:</b>")
	var/A_message = ""
	if(gangmode && isnum(gangmode.A_timer))
		var/new_time = max(300,gangmode.A_timer - ((ticker.mode.A_territory.len + A_uniformed) * 2))
		if(new_time < gangmode.A_timer)
			A_message += "Takeover shortened by [gangmode.A_timer - new_time] seconds for defending [ticker.mode.A_territory.len] territories and [A_uniformed] uniformed gangsters.<BR>"
			gangmode.A_timer = new_time
		A_message += "[gangmode.A_timer] seconds remain in hostile takeover."
	else
		var/A_new = min(999,A + 15 + (A_uniformed * 2) + ticker.mode.A_territory.len)
		if(A_new != A)
			A_message += "Gang influence has increased by [A_new - A] for defending [ticker.mode.A_territory.len] territories and [A_uniformed] uniformed gangsters.<BR>"
		A = A_new
		A_message += "Your gang now has [A] influence."
	ticker.mode.message_gangtools(ticker.mode.A_tools,A_message,0)

	ticker.mode.message_gangtools(ticker.mode.B_tools,"<b>[gang_name("B")] Gang Status Report:</b>")
	var/B_message = ""
	if(gangmode && isnum(gangmode.B_timer))
		var/new_time = max(300,gangmode.B_timer - ((ticker.mode.B_territory.len + B_uniformed) * 2))
		if(new_time < gangmode.B_timer)
			A_message += "Takeover shortened by [gangmode.B_timer - new_time] seconds for defending [ticker.mode.B_territory.len] territories and [B_uniformed] uniformed gangsters.<BR>"
			gangmode.B_timer = new_time
		B_message += "[gangmode.B_timer] seconds remain hostile takeover."
	else
		var/B_new = min(999,B + 15 + (B_uniformed * 2) + ticker.mode.B_territory.len)
		if(B_new != B)
			A_message += "Gang influence has increased by [B_new - B] for defending [ticker.mode.B_territory.len] territories and [B_uniformed] uniformed gangsters.<BR>"
		B = B_new
		B_message += "Your gang now has [B] influence."
	ticker.mode.message_gangtools(ticker.mode.B_tools,B_message,0)


	//Remove territories they already own from the buffer, so if they got tagged over, they can still earn income if they tag it back before the next status report
	ticker.mode.A_territory_new -= ticker.mode.A_territory
	ticker.mode.B_territory_new -= ticker.mode.B_territory

	//Process new territories
	for(var/area in ticker.mode.A_territory_new)
		if(A_added_names == "")
			A_added_names += ":<br>"
		else
			A_added_names += ", "
		A_added_names += "[ticker.mode.A_territory_new[area]]"
		ticker.mode.A_territory += area

	for(var/area in ticker.mode.B_territory_new)
		if(B_added_names == "")
			B_added_names += ":<br>"
		else
			B_added_names += ", "
		B_added_names += "[ticker.mode.B_territory_new[area]]"
		ticker.mode.B_territory += area

	//Report territory changes
	ticker.mode.message_gangtools(ticker.mode.A_tools,"<b>[ticker.mode.A_territory_new.len] new territories</b><BR>[A_added_names]",0)
	ticker.mode.message_gangtools(ticker.mode.B_tools,"<b>[ticker.mode.B_territory_new.len] new territories</b><BR>[B_added_names]",0,)
	ticker.mode.message_gangtools(ticker.mode.A_tools,"<b>[ticker.mode.A_territory_lost.len] territories lost</b><BR>[A_lost_names]",0)
	ticker.mode.message_gangtools(ticker.mode.B_tools,"<b>[ticker.mode.B_territory_lost.len] territories lost</b><BR>[B_lost_names]",0)

	//Clear the lists
	ticker.mode.A_territory_new = list()
	ticker.mode.B_territory_new = list()
	ticker.mode.A_territory_lost = list()
	ticker.mode.B_territory_lost = list()

	var/A_control = round((ticker.mode.A_territory.len/start_state.num_territories)*100, 1)
	var/B_control = round((ticker.mode.B_territory.len/start_state.num_territories)*100, 1)
	ticker.mode.message_gangtools((ticker.mode.A_tools),"Your gang now has <b>[A_control]% control</b> of the station.<BR>*---------*",0)
	ticker.mode.message_gangtools((ticker.mode.B_tools),"Your gang now has <b>[B_control]% control</b> of the station.<BR>*---------*",0)

	//Increase outfit stock
	for(var/obj/item/device/gangtool/tool in (ticker.mode.A_tools | ticker.mode.B_tools))
		tool.outfits = min(tool.outfits+2,5)

	//Restart the counter
	start()

////////////////////////////////////////////////
//Sends a message to the boss via his gangtool//
////////////////////////////////////////////////

/datum/game_mode/proc/message_gangtools(list/gangtools,message,beep=1,warning)
	if(!gangtools.len || !message)
		return
	for(var/obj/item/device/gangtool/tool in gangtools)
		var/mob/living/mob = get(tool.loc,/mob/living)
		if(mob && mob.mind && mob.stat == CONSCIOUS)
			if(((tool.gang == "A") && ((mob.mind in A_gang) || (mob.mind in A_bosses))) || ((tool.gang == "B") && ((mob.mind in B_gang) || (mob.mind in B_bosses))))
				to_chat(mob, "<span class='[warning ? "warning" : "notice"]'>[bicon(tool)] [message]</span>")
				if(beep)
					playsound(mob.loc, 'sound/machines/twobeep.ogg', 50, 1)

////KEVLAR KIT FOR MODYFIYING GANG SUITS
/obj/item/device/kevlar_kit
	name = "Makeshift kevlar kit"
	desc = "Makeshift kevlar plates and tools, which can be used to make makeshift armor"
	icon_state = "modkit"
	var/list/forbidden_types = list(
		/obj/item/clothing/suit/space,
		/obj/item/clothing/suit/armor,
		/obj/item/clothing/suit/storage
		)

/obj/item/device/kevlar_kit/afterattack(obj/O, mob/user)
	if(get_dist(src,O)>1)
		return
	if(!istype(O, /obj/item/clothing/suit))
		to_chat(user, "<span class='notice'>[O] can not be modified.</span>")
		return
	var/obj/item/clothing/suit/outfit = O
	if(is_type_in_list(outfit, forbidden_types))
		to_chat(user, "<span class='notice'>There is already armor plates in [O].</span>")
		return
	if(outfit.gang_mogified)
		to_chat(user, "<span class='notice'>You can't modify [O].</span>")
		return
	outfit.armor = list(melee = 20, bullet = 30, laser = 10, energy = 10, bomb = 20, bio = 0, rad = 0)
	outfit.gang = TRUE
	outfit.gang_mogified = TRUE
	playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)
	to_chat(user, "<span class='notice'>You add kevlar armor plates to [O].</span>")
	outfit = null
	qdel(src)

/mob/living/carbon/human/proc/gang_convert()
	set name = "Gang-Convert"
	set category = "IC"
	var/list/gang_restricted_jobs = list("Star Vigil Officer", "Star Vigil Sergeant", "Detective", "AI", "Cyborg", "Captain", "Head of Personnel", "Star Vigil Commander", "Chief Engineer", "Research Director", "Chief Medical Officer", "Internal Affairs Agent")

	if(!mind.can_gang_convert)
		to_chat(src, "<span class='notice'>It is not yet time!</span>")
	var/list/possible = list()
	for (var/mob/living/carbon/human/P in oview(src))
		if(!stat && P.client && P.mind && !P.mind.special_role && !ismindshielded(P))
			var/instance = FALSE
			for(var/job in gang_restricted_jobs)
				if(job == P.job)
					instance = TRUE
			if(!instance)
				possible += P
	if(!possible.len)
		to_chat(src, "\red There doesn't appear to be anyone available for you to convert here.")
		return
	var/mob/living/carbon/human/M = input("Select a person to convert", null) as mob in possible
	if(!M)
		return
	var/gang_letter
	if(mind in ticker.mode.A_bosses)
		gang_letter = "A"
	else if(mind in ticker.mode.B_bosses)
		gang_letter = "B"
	var/choice = alert(M,"Asked by [src]: Do you want to join the gang?","Align Thyself with the gang!","No!","Yes!")
	if(choice == "Yes!")
		var/recruitable = ticker.mode.add_gangster(M.mind, gang_letter)
		switch(recruitable)
			if(2)
				var/cooldown = 0
				if(gang_letter == "A")
					cooldown = max(100,((ticker.mode.A_gang.len - ticker.mode.B_gang.len)*400))
				else if (gang_letter == "B")
					cooldown = max(100,((ticker.mode.A_gang.len - ticker.mode.B_gang.len)*400))
				cooldown += world.time
				addtimer(CALLBACK(src, .proc/lift_convert_cooldown),cooldown)
				mind.can_gang_convert = FALSE
				to_chat(M, "<span class='notice'>You join the gang!</span>")
				to_chat(src, "<span class='warning'>[M] joins the gang!</span>")
			if(1)
				to_chat(src, "<span class='warning'>This mind is resistant to recruitment!</span>")
			else
				to_chat(src, "<span class='warning'>This mind has already been recruited into a gang!</span>")
	else if(choice == "No!")
		to_chat(M, "<span class='warning'>You reject this offer!</span>")
		to_chat(src, "<span class='warning'>[M] rejected your offer!</span>")
	QDEL_NULL(possible)

/mob/living/carbon/human/proc/lift_convert_cooldown()
	mind.can_gang_convert = TRUE
	to_chat(src, "<span class='notice'>You feel, that it is time to recruit somebody to our gang.</span>")
