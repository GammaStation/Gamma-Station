/obj/effect/proc_holder/magic/click_on/scan
	name = "Scan"
	desc = ""
	mana_cost = 400
	types_to_click = list("mobs")


/obj/effect/proc_holder/magic/click_on/scan/check_mob_cast(mob/target)
	if(!ishuman(target))
		to_chat(owner.current, "<span class='wizard'>This spell is intended to be used only on humans!</span>")
		return TRUE


/obj/effect/proc_holder/magic/click_on/scan/cast_on_mob(mob/living/carbon/human/target)
	var/dat = "<font color='blue'><B>Target Statistics:</B></FONT><BR>" //Blah obvious
	var/t1
	switch(target.stat) // obvious, see what their status is
		if(0)
			t1 = "Conscious"
		if(1)
			t1 = "Unconscious"
		else
			t1 = "*dead*"
	dat += text("[]\tHealth %: [] ([])</FONT><BR>", (target.health > 50 ? "<font color='blue'>" : "<font color='red'>"), target.health, t1)
	if(target.mind && target.mind.changeling && target.fake_death)
		dat += text("<font color='red'>Abnormal bio-chemical activity detected!</font><BR>")

	if(target.virus2.len)
		dat += text("<font color='red'>Viral pathogen detected in blood stream.</font><BR>")

	dat += text("[]\t-Brute Damage %: []</FONT><BR>", (target.getBruteLoss() < 60 ? "<font color='blue'>" : "<font color='red'>"), target.getBruteLoss())
	dat += text("[]\t-Respiratory Damage %: []</FONT><BR>", (target.getOxyLoss() < 60 ? "<font color='blue'>" : "<font color='red'>"), target.getOxyLoss())
	dat += text("[]\t-Toxin Content %: []</FONT><BR>", (target.getToxLoss() < 60 ? "<font color='blue'>" : "<font color='red'>"), target.getToxLoss())
	dat += text("[]\t-Burn Severity %: []</FONT><BR><BR>", (target.getFireLoss() < 60 ? "<font color='blue'>" : "<font color='red'>"), target.getFireLoss())

	dat += text("[]\tRadiation Level %: []</FONT><BR>", (target.radiation < 10 ?"<font color='blue'>" : "<font color='red'>"), target.radiation)
	dat += text("[]\tGenetic Tissue Damage %: []</FONT><BR>", (target.getCloneLoss() < 1 ?"<font color='blue'>" : "<font color='red'>"), target.getCloneLoss())
	dat += text("[]\tApprox. Brain Damage %: []</FONT><BR>", (target.getBrainLoss() < 1 ?"<font color='blue'>" : "<font color='red'>"), target.getBrainLoss())
	dat += text("Paralysis Summary %: [] ([] seconds left!)<BR>", target.paralysis, round(target.paralysis / 4))
	dat += text("Body Temperature: [target.bodytemperature-T0C]&deg;C ([target.bodytemperature*1.8-459.67]&deg;F)<BR><HR>")

	if(target.has_brain_worms())
		dat += "Large growth detected in frontal lobe, possibly cancerous. Surgical removal is recommended.<BR/>"

	if(target.vessel)
		var/blood_volume = round(target.vessel.get_reagent_amount("blood"))
		var/blood_percent =  blood_volume / 560
		blood_percent *= 100
		dat += text("[]\tBlood Level %: [] ([] units)</FONT><BR>", (blood_volume > 448 ?"<font color='blue'>" : "<font color='red'>"), blood_percent, blood_volume)
	if(target.reagents)
		dat += text("Inaprovaline units: [] units<BR>", target.reagents.get_reagent_amount("inaprovaline"))
		dat += text("Soporific (Sleep Toxin): [] units<BR>", target.reagents.get_reagent_amount("stoxin"))
		dat += text("[]\tDermaline: [] units</FONT><BR>", (target.reagents.get_reagent_amount("dermaline") < 30 ? "<font color='black'>" : "<font color='red'>"), target.reagents.get_reagent_amount("dermaline"))
		dat += text("[]\tBicaridine: [] units<BR>", (target.reagents.get_reagent_amount("bicaridine") < 30 ? "<font color='black'>" : "<font color='red'>"), target.reagents.get_reagent_amount("bicaridine"))
		dat += text("[]\tDexalin: [] units<BR>", (target.reagents.get_reagent_amount("dexalin") < 30 ? "<font color='black'>" : "<font color='red'>"), target.reagents.get_reagent_amount("dexalin"))

	for(var/datum/disease/D in target.viruses)
		if(!D.hidden[SCANNER])
			dat += text("<font color='red'><B>Warning: [D.form] Detected</B>\nName: [D.name].\nType: [D.spread].\nStage: [D.stage]/[D.max_stages].\nPossible Cure: [D.cure]</FONT><BR>")
	dat += "<HR><table border='1'>"
	dat += "<tr>"
	dat += "<th>Body Part</th>"
	dat += "<th>Burn Damage</th>"
	dat += "<th>Brute Damage</th>"
	dat += "<th>Other Wounds</th>"
	dat += "</tr>"

	for(var/obj/item/organ/external/BP in target.bodyparts)
		dat += "<tr>"
		var/AN = ""
		var/open = ""
		var/infected = ""
		var/imp = ""
		var/bled = ""
		var/robot = ""
		var/splint = ""
		var/arterial_bleeding = ""
		var/lung_ruptured = ""
		if(BP.status & ORGAN_ARTERY_CUT)
			arterial_bleeding = "<br>Arterial bleeding"
		if(istype(BP, /obj/item/organ/external/chest) && target.is_lung_ruptured())
			lung_ruptured = "Lung ruptured:"
		if(BP.status & ORGAN_SPLINTED)
			splint = "Splinted:"
		if(BP.status & ORGAN_BLEEDING)
			bled = "Bleeding:"
		if(BP.status & ORGAN_BROKEN)
			AN = "[BP.broken_description]:"
		if(BP.status & ORGAN_ROBOT)
			robot = "Prosthetic:"
		if(BP.open)
			open = "Open:"
		switch (BP.germ_level)
			if (INFECTION_LEVEL_ONE to INFECTION_LEVEL_ONE_PLUS)
				infected = "Mild Infection:"
			if (INFECTION_LEVEL_ONE_PLUS to INFECTION_LEVEL_ONE_PLUS_PLUS)
				infected = "Mild Infection+:"
			if (INFECTION_LEVEL_ONE_PLUS_PLUS to INFECTION_LEVEL_TWO)
				infected = "Mild Infection++:"
			if (INFECTION_LEVEL_TWO to INFECTION_LEVEL_TWO_PLUS)
				infected = "Acute Infection:"
			if (INFECTION_LEVEL_TWO_PLUS to INFECTION_LEVEL_TWO_PLUS_PLUS)
				infected = "Acute Infection+:"
			if (INFECTION_LEVEL_TWO_PLUS_PLUS to INFECTION_LEVEL_THREE)
				infected = "Acute Infection++:"
			if (INFECTION_LEVEL_THREE to INFINITY)
				infected = "Septic:"

		var/unknown_body = 0
		for(var/I in BP.implants)
			unknown_body++

		if(unknown_body || BP.hidden)
			imp += "Unknown body present:"
		if(!AN && !open && !infected & !imp)
			AN = "None:"
		if(!(BP.status & ORGAN_DESTROYED))
			dat += "<td>[BP.name]</td><td>[BP.burn_dam]</td><td>[BP.brute_dam]</td><td>[robot][bled][AN][splint][open][infected][imp][arterial_bleeding][lung_ruptured]</td>"
		else
			dat += "<td>[BP.name]</td><td>-</td><td>-</td><td>Not Found</td>"
		dat += "</tr>"
	for(var/obj/item/organ/internal/IO in target.organs)
		var/mech = ""
		if(IO.robotic == 1)
			mech = "Assisted:"
		if(IO.robotic == 2)
			mech = "Mechanical:"

		var/infection = "None"
		switch (IO.germ_level)
			if (INFECTION_LEVEL_ONE to INFECTION_LEVEL_ONE_PLUS)
				infection = "Mild Infection:"
			if (INFECTION_LEVEL_ONE_PLUS to INFECTION_LEVEL_ONE_PLUS_PLUS)
				infection = "Mild Infection+:"
			if (INFECTION_LEVEL_ONE_PLUS_PLUS to INFECTION_LEVEL_TWO)
				infection = "Mild Infection++:"
			if (INFECTION_LEVEL_TWO to INFECTION_LEVEL_TWO_PLUS)
				infection = "Acute Infection:"
			if (INFECTION_LEVEL_TWO_PLUS to INFECTION_LEVEL_TWO_PLUS_PLUS)
				infection = "Acute Infection+:"
			if (INFECTION_LEVEL_TWO_PLUS_PLUS to INFECTION_LEVEL_THREE)
				infection = "Acute Infection++:"
			if (INFECTION_LEVEL_THREE to INFINITY)
				infection = "Necrotic:"

		dat += "<tr>"
		dat += "<td>[IO.name]</td><td>N/A</td><td>[IO.damage]</td><td>[infection]:[mech]</td><td></td>"
		dat += "</tr>"
	dat += "</table>"
	if(target.sdisabilities & BLIND)
		dat += text("<font color='red'>Cataracts detected.</font><BR>")
	if(target.sdisabilities & NEARSIGHTED)
		dat += text("<font color='red'>Retinal misalignment detected.</font><BR>")

	dat += "<HR>"
	if(target.mind)
		dat += "<B>[target.mind.current.real_name]'s Memory:</B><BR>"
		dat += target.mind.memory

		if(target.mind.objectives.len>0)
			dat += "<HR><B>Objectives:</B><BR>"

			var/obj_count = 1
			for(var/datum/objective/objective in target.mind.objectives)
				dat += "<B>Objective #[obj_count]</B>: [objective.explanation_text]<BR>"
				obj_count++

	owner.current << browse(entity_ja(dat), "window=wizardscan;size=430x600")