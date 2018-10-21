/datum/reagent/space_drugs
	name = "Space drugs"
	id = "space_drugs"
	description = "An illegal chemical compound used as drug."
	reagent_state = LIQUID
	color = "#60a584" // rgb: 96, 165, 132
	custom_metabolism = REAGENTS_METABOLISM * 0.5
	overdose = REAGENTS_OVERDOSE
	restrict_species = list(IPC, DIONA)

/datum/reagent/space_drugs/on_general_digest(mob/living/M)
	..()
	M.druggy = max(M.druggy, 15)
	if(isturf(M.loc) && !istype(M.loc, /turf/space))
		if(M.canmove && !M.restrained())
			if(prob(10))
				step(M, pick(cardinal))
	if(prob(7))
		M.emote(pick("twitch","drool","moan","giggle"))

/datum/reagent/serotrotium
	name = "Serotrotium"
	id = "serotrotium"
	description = "A chemical compound that promotes concentrated production of the serotonin neurotransmitter in humans."
	reagent_state = LIQUID
	color = "#202040" // rgb: 20, 20, 40
	custom_metabolism = REAGENTS_METABOLISM * 0.25
	overdose = REAGENTS_OVERDOSE
	restrict_species = list(IPC, DIONA)

/datum/reagent/serotrotium/on_general_digest(mob/living/M)
	..()
	if(ishuman(M))
		if(prob(7))
			M.emote(pick("twitch","drool","moan","gasp"))

/datum/reagent/nicotine
	name = "Nicotine"
	id = "nicotine"
	description = "A highly addictive stimulant extracted from the tobacco plant."
	reagent_state = LIQUID
	color = "#181818" // rgb: 24, 24, 24
	custom_metabolism = 0.005
	restrict_species = list(IPC, DIONA)
	var/alert_time = 0

/datum/reagent/nicotine/on_mob_life(mob/living/M)
	if(!..())
		return
	if(volume >= 0.85)
		if(world.time > (alert_time + 90 SECONDS))
			to_chat(M, pick("<span class='danger'>You feel dizzy and weak</span>"))
			alert_time = world.time
			if(prob(60))
				M.adjustOxyLoss(1)
	if(volume < 0.7)
		if(prob(10))
			M.AdjustStunned(-1)
			M.AdjustWeakened(-1)
	if(volume > 1)
		if(prob(80))
			M.adjustOxyLoss(1)
			M.drowsyness = min(40, (M.drowsyness + 2))
	return TRUE

/datum/reagent/toxin/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	description = "A powerful hallucinogen, it can cause fatal effects in users."
	reagent_state = LIQUID
	color = "#B31008" // rgb: 139, 166, 233
	toxpwr = 0
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE

/datum/reagent/toxin/mindbreaker/on_general_digest(mob/living/M)
	..()
	M.hallucination += 10

/datum/reagent/toxin/stoxin
	name = "Sleep Toxin"
	id = "stoxin"
	description = "An effective hypnotic used to treat insomnia."
	reagent_state = LIQUID
	color = "#E895CC" // rgb: 232, 149, 204
	toxpwr = 0
	custom_metabolism = 0.1
	overdose = REAGENTS_OVERDOSE
	restrict_species = list(IPC, DIONA)

/datum/reagent/toxin/stoxin/on_general_digest(mob/living/M)
	..()
	if(!data)
		data = 1
	switch(data)
		if(1 to 12)
			if(prob(5))
				M.emote("yawn")
		if(12 to 15)
			M.eye_blurry = max(M.eye_blurry, 10)
		if(15 to 49)
			if(prob(50))
				M.Weaken(2)
			M.drowsyness  = max(M.drowsyness, 20)
		if(50 to INFINITY)
			M.Weaken(20)
			M.drowsyness  = max(M.drowsyness, 30)
	data++
