datum/preferences/proc/SetSkills(mob/user)
	if(SKILLS == null)
		setup_skills()

	if(skills.len == 0)
		ZeroSkills()

	. =  "<table cellspacing='0' width='100%'>"
	. += 	"<tr>"
	. += 		"<td width='50%'>"
	. += 			"<table width='100%'>"
	. += 				"<tr><td colspan='2'><b>Select your skills:</b></td></tr>"
	. += 				"Current skill level: <b>[GetSkillClass(used_skillpoints)]</b> ([used_skillpoints])<br>"
	. += 				"<a href=\"byond://?src=\ref[user];preference=skills;preconfigured=1;\">Use preconfigured skillset</a><br>"

	. += "<table>"

	for(var/V in SKILLS)
		. += "<tr><th colspan = 5><b>[V]</b>"
		. += "</th></tr>"
		for(var/datum/skill/S in SKILLS[V])
			var/level = skills[S.ID]
			. += "<tr style='text-align:left;'>"
			. += "<th><a href='byond://?src=\ref[user];preference=skills;skillinfo=\ref[S]'>[S.name]</a></th>"
			. += "<th><a href='byond://?src=\ref[user];preference=skills;setskill=\ref[S];newvalue=[SKILL_NONE]'><font color=[(level == SKILL_NONE) ? "red" : "black"]>\[Untrained\]</font></a></th>"
			// secondary skills don't have an amateur level
			if(S.secondary)
				. += "<th></th>"
			else
				. += "<th><a href='byond://?src=\ref[user];preference=skills;setskill=\ref[S];newvalue=[SKILL_BASIC]'><font color=[(level == SKILL_BASIC) ? "red" : "black"]>\[Amateur\]</font></a></th>"
			. += "<th><a href='byond://?src=\ref[user];preference=skills;setskill=\ref[S];newvalue=[SKILL_ADEPT]'><font color=[(level == SKILL_ADEPT) ? "red" : "black"]>\[Trained\]</font></a></th>"
			. += "<th><a href='byond://?src=\ref[user];preference=skills;setskill=\ref[S];newvalue=[SKILL_EXPERT]'><font color=[(level == SKILL_EXPERT) ? "red" : "black"]>\[Professional\]</font></a></th>"
			. += "</tr>"
	. += "</table>"

	return

/datum/preferences/proc/process_link_skills(mob/user, list/href_list)
	if(href_list["preference"] == "skills")
		if(href_list["cancel"])
			user << browse(null, "window=show_skills")
			ShowChoices(user)
		else if(href_list["skillinfo"])
			var/datum/skill/S = locate(href_list["skillinfo"])
			var/HTML = "<b>[S.name]</b><br>[S.desc]"
			user << browse(HTML, "window=\ref[user]skillinfo")
		else if(href_list["setskill"])
			var/datum/skill/S = locate(href_list["setskill"])
			var/value = text2num(href_list["newvalue"])
			skills[S.ID] = value
			used_skillpoints=CalculateSkillPoints(skills)
			SetSkills(user)
		else if(href_list["preconfigured"])
			var/selected = input(user, "Select a skillset", "Skillset") as null|anything in SKILL_PRE
			if(!selected) return

			ZeroSkills(1)
			for(var/V in SKILL_PRE[selected])
				if(V == "field")
					skill_specialization = SKILL_PRE[selected]["field"]
					continue
				skills[V] = SKILL_PRE[selected][V]
			used_skillpoints=CalculateSkillPoints(skills)

			SetSkills(user)
		else if(href_list["setspecialization"])
			skill_specialization = href_list["setspecialization"]
			used_skillpoints=CalculateSkillPoints(skills)
			SetSkills(user)
		else
			SetSkills(user)
		return 1

