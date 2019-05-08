#define ANTIDEPRESSANT_MESSAGE_DELAY 5*60*10
/datum/reagent/srejuvenate
	name = "Soporific Rejuvenant"
	id = "stoxin2"
	description = "Put people to sleep, and heals them."
	reagent_state = LIQUID
	color = "#c8a5dc" // rgb: 200, 165, 220
	custom_metabolism = REAGENTS_METABOLISM * 0.5
	overdose = REAGENTS_OVERDOSE
	restrict_species = list(IPC, DIONA)

/datum/reagent/srejuvenate/on_general_digest(mob/living/M)
	..()
	if(M.losebreath >= 10)
		M.losebreath = max(10, M.losebreath-10)
	if(!data)
		data = 1
	data++
	switch(data)
		if(1 to 15)
			M.eye_blurry = max(M.eye_blurry, 10)
		if(15 to 25)
			M.drowsyness  = max(M.drowsyness, 20)
		if(25 to INFINITY)
			M.sleeping += 1
			M.adjustOxyLoss(-M.getOxyLoss())
			M.SetWeakened(0)
			M.SetStunned(0)
			M.SetParalysis(0)
			M.dizziness = 0
			M.drowsyness = 0
			M.stuttering = 0
			M.confused = 0
			M.jitteriness = 0

/datum/reagent/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	description = "Inaprovaline is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients."
	reagent_state = LIQUID
	color = "#00bfff" // rgb: 200, 165, 220
	custom_metabolism = REAGENTS_METABOLISM * 0.5
	overdose = REAGENTS_OVERDOSE * 2
	restrict_species = list(IPC, DIONA)

/datum/reagent/inaprovaline/on_general_digest(mob/living/M)
	..()
	if(M.losebreath >= 10)
		M.losebreath = max(10, M.losebreath-5)

/datum/reagent/inaprovaline/on_vox_digest(mob/living/M)
	..()
	M.adjustToxLoss(REAGENTS_METABOLISM)
	return FALSE // General digest proc shouldn't be called.

/datum/reagent/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	description = "Ryetalyn can cure all genetic abnomalities via a catalytic process."
	reagent_state = SOLID
	color = "#004000" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	custom_metabolism = 0

/datum/reagent/ryetalyn/on_general_digest(mob/living/M)
	..()
	M.remove_any_mutations()
	holder.del_reagent(id)

/datum/reagent/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller."
	reagent_state = LIQUID
	color = "#c8a5dc"
	overdose = 60
	restrict_species = list(IPC, DIONA)

/datum/reagent/paracetamol/on_general_digest(mob/living/M)
	..()
	if(volume > overdose)
		M.hallucination = max(M.hallucination, 2)

/datum/reagent/tramadol
	name = "Tramadol"
	id = "tramadol"
	description = "A simple, yet effective painkiller."
	reagent_state = LIQUID
	color = "#cb68fc"
	overdose = 30
	custom_metabolism = 0.025
	restrict_species = list(IPC, DIONA)

/datum/reagent/tramadol/on_general_digest(mob/living/M)
	..()
	if(volume > overdose)
		M.hallucination = max(M.hallucination, 2)

/datum/reagent/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	description = "An effective and very addictive painkiller."
	reagent_state = LIQUID
	color = "#800080"
	overdose = 20
	custom_metabolism = 0.025
	restrict_species = list(IPC, DIONA)

/datum/reagent/oxycodone/on_general_digest(mob/living/M)
	..()
	if(volume > overdose)
		M.druggy = max(M.druggy, 10)
		M.hallucination = max(M.hallucination, 3)

/datum/reagent/virus_food
	name = "Virus Food"
	id = "virusfood"
	description = "A mixture of water, milk, and oxygen. Virus cells can use this mixture to reproduce."
	reagent_state = LIQUID
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#899613" // rgb: 137, 150, 19

/datum/reagent/virus_food/on_general_digest(mob/living/M)
	..()
	M.nutrition += nutriment_factor * REM

/datum/reagent/virus_vood/on_skrell_digest(mob/living/M)
	..()
	M.adjustToxLoss(2 * REM)
	return FALSE

/datum/reagent/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	description = "Sterilizes wounds in preparation for surgery."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220

//makes you squeaky clean
/datum/reagent/sterilizine/reaction_mob(mob/living/M, method=TOUCH, volume)
	if (method == TOUCH)
		M.germ_level -= min(volume*20, M.germ_level)

/datum/reagent/sterilizine/reaction_obj(var/obj/O, var/volume)
	O.germ_level -= min(volume*20, O.germ_level)

/datum/reagent/sterilizine/reaction_turf(var/turf/T, var/volume)
	T.germ_level -= min(volume*20, T.germ_level)

/datum/reagent/leporazine
	name = "Leporazine"
	id = "leporazine"
	description = "Leporazine can be use to stabilize an individuals body temperature."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	taste_message = null

/datum/reagent/leporazine/on_general_digest(mob/living/M)
	..()
	if(M.bodytemperature > BODYTEMP_NORMAL)
		M.bodytemperature = max(BODYTEMP_NORMAL, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(BODYTEMP_NORMAL, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/kelotane
	name = "Kelotane"
	id = "kelotane"
	description = "Kelotane is a drug used to treat burns."
	reagent_state = LIQUID
	color = "#ffc600" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	taste_message = null
	restrict_species = list(IPC, DIONA)

/datum/reagent/kelotane/on_general_digest(mob/living/M)
	..()
	M.heal_bodypart_damage(0,2 * REM)

/datum/reagent/dermaline
	name = "Dermaline"
	id = "dermaline"
	description = "Dermaline is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue."
	reagent_state = LIQUID
	color = "#ff8000" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE * 0.5
	taste_message = null
	restrict_species = list(IPC, DIONA)

/datum/reagent/dermaline/on_general_digest(mob/living/M)
	..()
	M.heal_bodypart_damage(0,3 * REM)

/datum/reagent/dexalin
	name = "Dexalin"
	id = "dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation."
	reagent_state = LIQUID
	color = "#0080ff" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	taste_message = "oxygen"
	restrict_species = list(IPC, DIONA)

/datum/reagent/dexalin/on_general_digest(mob/living/M)
	..()
	M.adjustOxyLoss(-2 * REM)

	if(holder.has_reagent("lexorin"))
		holder.remove_reagent("lexorin", 2 * REM)

/datum/reagent/dexalin/on_vox_digest(mob/living/M) // Now dexalin does not remove lexarin from Vox. For the better or the worse.
	..()
	M.adjustToxLoss(2 * REM)
	return FALSE

/datum/reagent/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	description = "Dexalin Plus is used in the treatment of oxygen deprivation. It is highly effective."
	reagent_state = LIQUID
	color = "#0040ff" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE * 0.5
	taste_message = "ability to breath"
	restrict_species = list(IPC, DIONA)

/datum/reagent/dexalinp/on_general_digest(mob/living/M)
	..()
	M.adjustOxyLoss(-M.getOxyLoss())

	if(holder.has_reagent("lexorin"))
		holder.remove_reagent("lexorin", 2 * REM)

/datum/reagent/dexalinp/on_vox_digest(mob/living/M) // Now dexalin plus does not remove lexarin from Vox. For the better or the worse.
	..()
	M.adjustToxLoss(6 * REM) // Let's just say it's thrice as poisonous.
	return FALSE

/datum/reagent/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	reagent_state = LIQUID
	color = "#00b080" // rgb: 200, 165, 220
	taste_message = null
	restrict_species = list(IPC, DIONA)

/datum/reagent/tricordrazine/on_general_digest(mob/living/M)
	..()
	if(M.getOxyLoss())
		M.adjustOxyLoss(-1 * REM)
	if(M.getBruteLoss() && prob(80))
		M.heal_bodypart_damage(1 * REM, 0)
	if(M.getFireLoss() && prob(80))
		M.heal_bodypart_damage(0, 1 * REM)
	if(M.getToxLoss() && prob(80))
		M.adjustToxLoss(-1 * REM)

/datum/reagent/anti_toxin
	name = "Anti-Toxin (Dylovene)"
	id = "anti_toxin"
	description = "Dylovene is a broad-spectrum antitoxin."
	reagent_state = LIQUID
	color = "#00a000" // rgb: 200, 165, 220
	taste_message = null
	restrict_species = list(IPC, DIONA)

/datum/reagent/anti_toxin/on_general_digest(mob/living/M)
	..()
	M.reagents.remove_all_type(/datum/reagent/toxin, REM, 0, 1)
	M.drowsyness = max(M.drowsyness - 2 * REM, 0)
	M.hallucination = max(0, M.hallucination - 5 * REM)
	M.adjustToxLoss(-2 * REM)

/datum/reagent/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	id = "adminordrazine"
	description = "It's magic. We don't have to explain it."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	taste_message = "admin abuse"

/datum/reagent/adminordrazine/on_general_digest(mob/living/M)
	..()
	M.reagents.remove_all_type(/datum/reagent/toxin, 5 * REM, 0, 1)
	M.setCloneLoss(0)
	M.setOxyLoss(0)
	M.radiation = 0
	M.heal_bodypart_damage(5,5)
	M.adjustToxLoss(-5)
	M.hallucination = 0
	M.setBrainLoss(0)
	M.disabilities = 0
	M.sdisabilities = 0
	M.eye_blurry = 0
	M.eye_blind = 0
	M.SetWeakened(0)
	M.SetStunned(0)
	M.SetParalysis(0)
	M.silent = 0
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.confused = 0
	M.sleeping = 0
	M.jitteriness = 0
	for(var/datum/disease/D in M.viruses)
		D.spread = "Remissive"
		D.stage--
		if(D.stage < 1)
			D.cure()

/datum/reagent/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	description = "Synaptizine is used to treat various diseases."
	reagent_state = LIQUID
	color = "#99ccff" // rgb: 200, 165, 220
	custom_metabolism = 0.01
	overdose = REAGENTS_OVERDOSE
	restrict_species = list(IPC, DIONA)

/datum/reagent/synaptizine/on_general_digest(mob/living/M)
	..()
	M.drowsyness = max(M.drowsyness - 5, 0)
	M.AdjustParalysis(-1)
	M.AdjustStunned(-1)
	M.AdjustWeakened(-1)
	if(holder.has_reagent("mindbreaker"))
		holder.remove_reagent("mindbreaker", 5)
	M.hallucination = max(0, M.hallucination - 10)
	if(prob(60))
		M.adjustToxLoss(1)

/datum/reagent/hyronalin
	name = "Hyronalin"
	id = "hyronalin"
	description = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."
	reagent_state = LIQUID
	color = "#408000" // rgb: 200, 165, 220
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE
	taste_message = null

/datum/reagent/hyronalin/on_general_digest(mob/living/M)
	..()
	M.radiation = max(M.radiation - 3 * REM, 0)

/datum/reagent/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	reagent_state = LIQUID
	color = "#008000" // rgb: 200, 165, 220
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE
	taste_message = null

/datum/reagent/arithrazine/on_general_digest(mob/living/M)
	..()
	M.radiation = max(M.radiation - 7 * REM, 0)
	M.adjustToxLoss(-1 * REM)
	if(prob(15))
		M.take_bodypart_damage(1, 0)

/datum/reagent/alkysine
	name = "Alkysine"
	id = "alkysine"
	description = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
	reagent_state = LIQUID
	color = "#8b00ff" // rgb: 200, 165, 220
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE
	taste_message = null

/datum/reagent/alkysine/on_general_digest(mob/living/M)
	..()
	M.adjustBrainLoss(-3 * REM)

/datum/reagent/imidazoline
	name = "Imidazoline"
	id = "imidazoline"
	description = "Heals eye damage"
	reagent_state = LIQUID
	color = "#a0dbff" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	taste_message = "carrot"
	restrict_species = list(IPC, DIONA)

/datum/reagent/imidazoline/on_general_digest(mob/living/M)
	..()
	M.eye_blurry = max(M.eye_blurry - 5, 0)
	M.eye_blind = max(M.eye_blind - 5, 0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/IO = H.organs_by_name[O_EYES]
		if(istype(IO))
			if(IO.damage > 0)
				IO.damage = max(IO.damage - 1, 0)

/datum/reagent/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	description = "Used to encourage recovery of organs and nervous systems. Medicate cautiously."
	reagent_state = LIQUID
	color = "#561ec3" // rgb: 200, 165, 220
	overdose = 10
	taste_message = null
	restrict_species = list(IPC, DIONA)

/datum/reagent/peridaxon/on_general_digest(mob/living/M)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M

		//Peridaxon is hard enough to get, it's probably fair to make this all organs
		for(var/obj/item/organ/internal/IO in H.organs)
			if(IO.damage > 0)
				IO.damage = max(IO.damage - 0.20, 0)

/datum/reagent/kyphotorin
	name = "Kyphotorin"
	id = "kyphotorin"
	description = "Used nanites to encourage recovery of body parts and bones. Medicate cautiously."
	reagent_state = LIQUID
	color = "#551a8b" // rgb: 85, 26, 139
	overdose = 5.1
	custom_metabolism = 0.07
	var/obj/item/organ/external/External
	taste_message = "machines"
	restrict_species = list(IPC, DIONA)

/datum/reagent/kyphotorin/on_general_digest(mob/living/M)
	..()
	if(!ishuman(M) || volume > overdose)
		return
	var/mob/living/carbon/human/H = M
	if(H.nutrition < 200) // if nanites don't have enough resources, they stop working and still spend
		H.make_jittery(100)
		volume += 0.07
		return
	H.jitteriness = max(0,H.jitteriness - 100)
	External = H.find_damaged_bodypart(External)
	H.nutrition -= 3
	H.apply_effect(3, WEAKEN)
	H.apply_damages(0,0,1,4,0,5)
	H.regen_bodyparts(External, FALSE)

/datum/reagent/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma."
	reagent_state = LIQUID
	color = "#bf0000" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	taste_message = null
	restrict_species = list(IPC, DIONA)

/datum/reagent/bicaridine/on_general_digest(mob/living/M, alien)
	..()
	M.heal_bodypart_damage(2 * REM, 0)

/datum/reagent/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	description = "Hyperzine is a highly effective, long lasting, muscle stimulant."
	reagent_state = LIQUID
	color = "#ff4f00" // rgb: 200, 165, 220
	custom_metabolism = 0.03
	overdose = REAGENTS_OVERDOSE * 0.5
	taste_message = "speed"
	restrict_species = list(IPC, DIONA)

/datum/reagent/hyperizine/on_general_digest(mob/living/M)
	..()
	if(prob(5))
		M.emote(pick("twitch","blink_r","shiver"))

/datum/reagent/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
	reagent_state = LIQUID
	color = "#80bfff" // rgb: 200, 165, 220
	taste_message = null

/datum/reagent/cryoxadone/on_general_digest(mob/living/M)
	..()
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-1)
		M.adjustOxyLoss(-1)
		M.heal_bodypart_damage(1, 1)
		M.adjustToxLoss(-1)

/datum/reagent/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	description = "A liquid compound similar to that used in the cloning process. Can be used to 'finish' the cloning process when used in conjunction with a cryo tube."
	reagent_state = LIQUID
	color = "#8080ff" // rgb: 200, 165, 220
	taste_message = null

/datum/reagent/clonexadone/on_general_digest(mob/living/M)
	..()
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-3)
		M.adjustOxyLoss(-3)
		M.heal_bodypart_damage(3, 3)
		M.adjustToxLoss(-3)

/datum/reagent/rezadone
	name = "Rezadone"
	id = "rezadone"
	description = "A powder derived from fish toxin, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	overdose = REAGENTS_OVERDOSE
	taste_message = null

/datum/reagent/rezadone/on_general_digest(mob/living/M)
	..()
	if(!data)
		data = 1
	data++
	switch(data)
		if(1 to 15)
			M.adjustCloneLoss(-1)
			M.heal_bodypart_damage(1, 1)
		if(15 to 35)
			M.adjustCloneLoss(-2)
			M.heal_bodypart_damage(2, 1)
			M.status_flags &= ~DISFIGURED
		if(35 to INFINITY)
			M.adjustToxLoss(1)
			M.make_dizzy(5)
			M.make_jittery(5)

/datum/reagent/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	description = "An all-purpose antiviral agent."
	reagent_state = LIQUID
	color = "#FFFFFF" // rgb: 200, 165, 220
	custom_metabolism = 0.01
	overdose = REAGENTS_OVERDOSE
	taste_message = null

/datum/reagent/ethylredoxrazine // FUCK YOU, ALCOHOL
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	description = "A powerful oxidizer that reacts with ethanol."
	reagent_state = SOLID
	color = "#605048" // rgb: 96, 80, 72
	overdose = REAGENTS_OVERDOSE
	taste_message = null

/datum/reagent/ethylredoxrazine/on_general_digest(mob/living/M)
	..()
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.confused = 0
	M.reagents.remove_all_type(/datum/reagent/consumable/ethanol, 1 * REM, 0, 1)

/datum/reagent/nanites2
	name = "Friendly Nanites"
	id = "nanites2"
	description = "Friendly microscopic construction robots."
	reagent_state = LIQUID
	color = "#535E66" //rgb: 83, 94, 102
	taste_message = "nanomachines, son"

/datum/reagent/nanobots
	name = "Nanobots"
	id = "nanobots"
	description = "Microscopic robots intended for use in humans. Must be loaded with further chemicals to be useful."
	reagent_state = LIQUID
	color = "#3E3959" //rgb: 62, 57, 89
	taste_message = "nanomachines, son"

//Great healing powers. Metabolizes extremely slowly, but gets used up when it heals damage.
//Dangerous in amounts over 5 units, healing that occurs while over 5 units adds to a counter. That counter affects gib chance. Guaranteed gib over 20 units.
/datum/reagent/mednanobots
	name = "Medical Nanobots"
	id = "mednanobots"
	description = "Microscopic robots intended for use in humans. Configured for rapid healing upon infiltration into the body."
	reagent_state = LIQUID
	color = "#593948" //rgb: 89, 57, 72
	custom_metabolism = 0.005
	var/spawning_horror = 0
	var/percent_machine = 0
	taste_message = "nanomachines, son"
	restrict_species = list(IPC, DIONA)

/datum/reagent/mednanobots/on_general_digest(mob/living/M)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		switch(volume)
			if(1 to 5)
				var/obj/item/organ/external/BP = H.bodyparts_by_name[BP_CHEST] // it was H.get_bodypart(????) with nothing as arg, so its always a chest?
				for(var/datum/wound/W in BP.wounds)
					BP.wounds -= W
					H.visible_message("<span class='warning'>[H]'s wounds close up in the blink of an eye!</span>")
				if(H.getOxyLoss() > 0 && prob(90))
					if(holder.has_reagent("mednanobots"))
						H.adjustOxyLoss(-4)
						holder.remove_reagent("mednanobots", 0.1)  //The number/40 means that every time it heals, it uses up number/40ths of a unit, meaning each unit heals 40 damage

				if(H.getBruteLoss() > 0 && prob(90))
					if(holder.has_reagent("mednanobots"))
						H.heal_bodypart_damage(5, 0)
						holder.remove_reagent("mednanobots", 0.125)

				if(H.getFireLoss() > 0 && prob(90))
					if(holder.has_reagent("mednanobots"))
						H.heal_bodypart_damage(0, 5)
						holder.remove_reagent("mednanobots", 0.125)

				if(H.getToxLoss() > 0 && prob(50))
					if(holder.has_reagent("mednanobots"))
						H.adjustToxLoss(-2)
						holder.remove_reagent("mednanobots", 0.05)

				if(H.getCloneLoss() > 0 && prob(60))
					if(holder.has_reagent("mednanobots"))
						H.adjustCloneLoss(-2)
						holder.remove_reagent("mednanobots", 0.05)

				if(percent_machine > 5)
					if(holder.has_reagent("mednanobots"))
						percent_machine -= 1
						if(prob(20))
							to_chat(M, pick("You feel more like yourself again."))
				if(H.dizziness != 0)
					H.dizziness = max(0, H.dizziness - 15)
				if(H.confused != 0)
					H.confused = max(0, H.confused - 5)
				for(var/datum/disease/D in M.viruses)
					D.spread = "Remissive"
					D.stage--
					if(D.stage < 1)
						D.cure()
			if(5 to 20)		//Danger zone healing. Adds to a human mob's "percent machine" var, which is directly translated into the chance that it will turn horror each tick that the reagent is above 5u.
				var/obj/item/organ/external/BP = H.bodyparts_by_name[BP_CHEST]
				for(var/datum/wound/W in BP.wounds)
					BP.wounds -= W
					H.visible_message("<span class='warning'>[H]'s wounds close up in the blink of an eye!</span>")
				if(H.getOxyLoss() > 0 && prob(90))
					if(holder.has_reagent("mednanobots"))
						H.adjustOxyLoss(-4)
						holder.remove_reagent("mednanobots", 0.1)  //The number/40 means that every time it heals, it uses up number/40ths of a unit, meaning each unit heals 40 damage
						percent_machine += 0.5
						if(prob(20))
							to_chat(M, pick("<span class='warning'>Something shifts inside you...</span>", "<span class='warning'>You feel different, somehow...</span>"))

				if(H.getBruteLoss() > 0 && prob(90))
					if(holder.has_reagent("mednanobots"))
						H.heal_bodypart_damage(5, 0)
						holder.remove_reagent("mednanobots", 0.125)
						percent_machine += 0.5
						if(prob(20))
							to_chat(M, pick("<span class='warning'> Something shifts inside you...</span>", "<span class='warning'>You feel different, somehow...</span>"))

				if(H.getFireLoss() > 0 && prob(90))
					if(holder.has_reagent("mednanobots"))
						H.heal_bodypart_damage(0, 5)
						holder.remove_reagent("mednanobots", 0.125)
						percent_machine += 0.5
						if(prob(20))
							to_chat(M, pick("<span class='warning'>Something shifts inside you...</span>", "<span class='warning'>You feel different, somehow...</span>"))

				if(H.getToxLoss() > 0 && prob(50))
					if(holder.has_reagent("mednanobots"))
						H.adjustToxLoss(-2)
						holder.remove_reagent("mednanobots", 0.05)
						percent_machine += 0.5
						if(prob(20))
							to_chat(M, pick("<span class='warning'>Something shifts inside you...</span>", "<span class='warning'>You feel different, somehow...</span>"))

				if(H.getCloneLoss() > 0 && prob(60))
					if(holder.has_reagent("mednanobots"))
						H.adjustCloneLoss(-2)
						holder.remove_reagent("mednanobots", 0.05)
						percent_machine += 0.5
						if(prob(20))
							to_chat(M, pick("<span class='warning'>Something shifts inside you...</span>", "<span class='warning'>You feel different, somehow...</span>"))

				if(H.dizziness != 0)
					H.dizziness = max(0, H.dizziness - 15)
				if(H.confused != 0)
					H.confused = max(0, H.confused - 5)
				for(var/datum/disease/D in M.viruses)
					D.spread = "Remissive"
					D.stage--
					if(D.stage < 1)
						D.cure()
				if(prob(percent_machine))
					holder.add_reagent("mednanobots", 20)
					to_chat(M, pick("<b><span class='warning'>Your body lurches!</b></span>"))
			if(20 to INFINITY)
				spawning_horror = 1
				to_chat(M, pick("<b><span class='warning'>Something doesn't feel right...</span></b>", "<b><span class='warning'>Something is growing inside you!</span></b>", "<b><span class='warning'>You feel your insides rearrange!</span></b>"))
				spawn(60)
					if(spawning_horror)
						to_chat(M, pick( "<b><span class='warning'>Something bursts out from inside you!</span></b>"))
						message_admins("[key_name(H)] has gibbed and spawned a new cyber horror due to nanobots. (<A HREF='?_src_=holder;adminmoreinfo=\ref[H]'>?</A>)")
						log_game("[key_name(H)] has gibbed and spawned a new cyber horror due to nanobots")
						new /mob/living/simple_animal/hostile/cyber_horror(H.loc)
						spawning_horror = 0
						H.gib()
	else
		holder.del_reagent("mednanobots")

/datum/reagent/antidepressant/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	description = "Improves the ability to concentrate."
	reagent_state = LIQUID
	color = "#bf80bf"
	custom_metabolism = 0.01
	data = 0
	restrict_species = list(IPC, DIONA)

/datum/reagent/antidepressant/methylphenidate/on_general_digest(mob/living/M)
	..()
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(M, "<span class='warning'>You lose focus..</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, "<span class='notice'>Your mind feels focused and undivided.</span>")

/datum/reagent/antidepressant/citalopram
	name = "Citalopram"
	id = "citalopram"
	description = "Stabilizes the mind a little."
	reagent_state = LIQUID
	color = "#ff80ff"
	custom_metabolism = 0.01
	data = 0
	restrict_species = list(IPC, DIONA)

/datum/reagent/antidepressant/citalopram/on_general_digest(mob/living/M)
	..()
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(M, "<span class='warning'>Your mind feels a little less stable.</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			to_chat(M, "<span class='notice'>Your mind feels stable.. a little stable.</span>")

/datum/reagent/antidepressant/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	description = "Stabilizes the mind greatly, but has a chance of adverse effects."
	reagent_state = LIQUID
	color = "#ff80bf"
	custom_metabolism = 0.01
	data = 0
	restrict_species = list(IPC, DIONA)

/datum/reagent/antidepressant/paroxetine/on_general_digest(mob/living/M)
	..()
	if(volume <= 0.1 && data != -1)
		data = -1
		to_chat(M, "<span class='warning'>Your mind feels much less stable.</span>")
	else
		if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
			data = world.time
			if(prob(90))
				to_chat(M, "<span class='notice'>Your mind feels much more stable.</span>")
			else
				to_chat(M, "<span class='warning'>Your mind breaks apart.</span>")
				M.hallucination += 200

