
/datum/reagent/toxin
	name = "Toxin"
	id = "toxin"
	description = "A toxic chemical."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	var/toxpwr = 0.7 // Toxins are really weak, but without being treated, last very long.
	custom_metabolism = 0.1
	taste_message = "bitterness"

/datum/reagent/toxin/on_general_digest(mob/living/M)
	..()
	if(toxpwr)
		M.adjustToxLoss(toxpwr * REM)

/datum/reagent/slimetoxin
	name = "Mutation Toxin"
	id = "mutationtoxin"
	description = "A corruptive toxin produced by slimes."
	reagent_state = LIQUID
	color = "#13bc5e" // rgb: 19, 188, 94
	overdose = REAGENTS_OVERDOSE

/datum/reagent/slimetoxin/on_general_digest(mob/living/M)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.dna && !H.dna.mutantrace)
			to_chat(M, "<span class='warning'>Your flesh rapidly mutates!</span>")
			H.dna.mutantrace = "slime"
			H.update_mutantrace()

/datum/reagent/aslimetoxin
	name = "Advanced Mutation Toxin"
	id = "amutationtoxin"
	description = "An advanced corruptive toxin produced by slimes."
	reagent_state = LIQUID
	color = "#13bc5e" // rgb: 19, 188, 94
	overdose = REAGENTS_OVERDOSE

/datum/reagent/aslimetoxin/on_general_digest(mob/living/M)
	..()
	if(istype(M, /mob/living/carbon) && M.stat != DEAD)
		to_chat(M, "<span class='warning'>Your flesh rapidly mutates!</span>")
		if(M.monkeyizing)
			return
		M.monkeyizing = 1
		M.canmove = 0
		M.icon = null
		M.overlays.Cut()
		M.invisibility = 101
		for(var/obj/item/W in M)
			if(istype(W, /obj/item/weapon/implant))	//TODO: Carn. give implants a dropped() or something
				qdel(W)
				continue
			W.layer = initial(W.layer)
			W.loc = M.loc
			W.dropped(M)
		var/mob/living/carbon/slime/new_mob = new /mob/living/carbon/slime(M.loc)
		new_mob.a_intent = "hurt"
		new_mob.universal_speak = 1
		if(M.mind)
			M.mind.transfer_to(new_mob)
		else
			new_mob.key = M.key
		qdel(M)

/datum/reagent/cryptobiolin
	name = "Cryptobiolin"
	id = "cryptobiolin"
	description = "Cryptobiolin causes confusion and dizzyness."
	reagent_state = LIQUID
	color = "#000055" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	custom_metabolism = REAGENTS_METABOLISM * 0.5
	taste_message = null
	restrict_species = list(IPC, DIONA)

/datum/reagent/cryptobiolin/on_general_digest(mob/living/M)
	..()
	M.make_dizzy(1)
	if(!M.confused)
		M.confused = 1
	M.confused = max(M.confused, 20)

/datum/reagent/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	restrict_species = list(IPC, DIONA)

/datum/reagent/impedrezene/on_general_digest(mob/living/M)
	..()
	M.jitteriness = max(M.jitteriness - 5, 0)
	if(prob(80))
		M.adjustBrainLoss(1 * REM)
	if(prob(50))
		M.drowsyness = max(M.drowsyness, 3)
	if(prob(10))
		M.emote("drool")

/datum/reagent/toxin/amatoxin
	name = "Amatoxin"
	id = "amatoxin"
	description = "A powerful poison derived from certain species of mushroom."
	reagent_state = LIQUID
	color = "#792300" // rgb: 121, 35, 0
	toxpwr = 1

/datum/reagent/toxin/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	description = "Might cause unpredictable mutations. Keep away from children."
	reagent_state = LIQUID
	color = "#13BC5E" // rgb: 19, 188, 94
	toxpwr = 0

/datum/reagent/toxin/mutagen/reaction_mob(mob/living/carbon/M, method=TOUCH, volume)
	if(!..())
		return
	if(!istype(M) || !M.dna)
		return  //No robots, AIs, aliens, Ians or other mobs should be affected by this.
	src = null
	if((method==TOUCH && prob(33)) || method==INGEST)
		randmuti(M)
		if(prob(98))
			randmutb(M)
		else
			randmutg(M)
		domutcheck(M, null)
		M.UpdateAppearance()

/datum/reagent/toxin/mutagen/on_general_digest(mob/living/M)
	..()
	M.apply_effect(10, IRRADIATE, 0)

/datum/reagent/toxin/phoron
	name = "Phoron"
	id = "phoron"
	description = "Phoron in its liquid form."
	reagent_state = LIQUID
	color = "#ef0097" // rgb: 231, 27, 0
	toxpwr = 3

/datum/reagent/toxin/phoron/on_general_digest(mob/living/M)
	..()
	if(holder.has_reagent("inaprovaline"))
		holder.remove_reagent("inaprovaline", 2 * REM)

/datum/reagent/toxin/phoron/reaction_obj(var/obj/O, var/volume)
	src = null
	/*if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/egg/slime))
		var/obj/item/weapon/reagent_containers/food/snacks/egg/slime/egg = O
		if (egg.grown)
			egg.Hatch()*/
	if((!O) || (!volume))	return 0
	if(volume < 0) return 0
	if(volume > 300) return 0

	var/turf/simulated/T = get_turf(O)
	if(!istype(T))
		return
	T.assume_gas("phoron", volume, T20C)

/datum/reagent/toxin/phoron/reaction_turf(var/turf/simulated/T, var/volume)
	if(volume < 0) return
	if(volume > 300) return

	if(!istype(T))
		return
	T.assume_gas("phoron", volume, T20C)

/datum/reagent/toxin/phoron/reaction_mob(mob/living/M, method=TOUCH, volume)//Splashing people with plasma is stronger than fuel!
	if(!istype(M, /mob/living))
		return
	if(method == TOUCH)
		M.adjust_fire_stacks(volume / 5)

/datum/reagent/toxin/lexorin
	name = "Lexorin"
	id = "lexorin"
	description = "Lexorin temporarily stops respiration. Causes tissue damage."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	toxpwr = 0
	overdose = REAGENTS_OVERDOSE
	restrict_species = list(IPC, DIONA)

/datum/reagent/toxin/lexorin/on_general_digest(mob/living/M)
	..()
	if(prob(33))
		M.take_bodypart_damage(1 * REM, 0)
	M.adjustOxyLoss(3)
	if(prob(20))
		M.emote("gasp")

/datum/reagent/toxin/slimejelly
	name = "Slime Jelly"
	id = "slimejelly"
	description = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence. SO REAL."
	reagent_state = LIQUID
	color = "#801E28" // rgb: 128, 30, 40
	toxpwr = 0

/datum/reagent/toxin/slimejelly/on_general_digest(mob/living/M)
	..()
	if(prob(10))
		to_chat(M, "\red Your insides are burning!")
		M.adjustToxLoss(rand(20,60) * REM)
	else if(prob(40))
		M.heal_bodypart_damage(5 * REM, 0)

/datum/reagent/toxin/cyanide //Fast and Lethal
	name = "Cyanide"
	id = "cyanide"
	description = "A highly toxic chemical."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	toxpwr = 4
	custom_metabolism = 0.4

/datum/reagent/toxin/cyanide/on_general_digest(mob/living/M)
	..()
	M.adjustOxyLoss(4 * REM)
	M.sleeping += 1

/datum/reagent/toxin/minttoxin
	name = "Mint Toxin"
	id = "minttoxin"
	description = "Useful for dealing with undesirable customers."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	toxpwr = 0

/datum/reagent/toxin/minttoxin/on_general_digest(mob/living/M)
	..()
	if(FAT in M.mutations)
		M.gib()

/datum/reagent/toxin/carpotoxin
	name = "Carpotoxin"
	id = "carpotoxin"
	description = "A deadly neurotoxin produced by the dreaded space carp."
	reagent_state = LIQUID
	color = "#003333" // rgb: 0, 51, 51
	toxpwr = 2

/datum/reagent/toxin/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	toxpwr = 0.5
	restrict_species = list(IPC, DIONA)

/datum/reagent/toxin/zombiepowder/on_general_digest(mob/living/M)
	..()
	M.status_flags |= FAKEDEATH
	M.adjustOxyLoss(0.5 * REM)
	M.Weaken(10)
	M.silent = max(M.silent, 10)
	M.tod = worldtime2text()

/datum/reagent/toxin/zombiepowder/Destroy()
	if(holder && ismob(holder.my_atom))
		var/mob/M = holder.my_atom
		M.status_flags &= ~FAKEDEATH
	return ..()

/datum/reagent/toxin/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
	reagent_state = LIQUID
	color = "#49002E" // rgb: 73, 0, 46
	toxpwr = 1

			// Clear off wallrot fungi
/datum/reagent/toxin/plantbgone/reaction_turf(var/turf/T, var/volume)
	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/W = T
		if(W.rotting)
			W.rotting = 0
			for(var/obj/effect/E in W) if(E.name == "Wallrot")
				qdel(E)

			for(var/mob/O in viewers(W, null))
				O.show_message(text("\blue The fungi are completely dissolved by the solution!"), 1)

/datum/reagent/toxin/plantbgone/reaction_obj(var/obj/O, var/volume)
	if(istype(O,/obj/structure/alien/weeds))
		var/obj/structure/alien/weeds/alien_weeds = O
		alien_weeds.health -= rand(15,35) // Kills alien weeds pretty fast
		alien_weeds.healthcheck()
	else if(istype(O,/obj/effect/glowshroom)) //even a small amount is enough to kill it
		qdel(O)
	else if(istype(O,/obj/effect/spacevine))
		if(prob(50)) del(O) //Kills kudzu too.
	// Damage that is done to growing plants is separately at code/game/machinery/hydroponics at obj/item/hydroponics

/datum/reagent/toxin/plantbgone/reaction_mob(mob/living/M, method=TOUCH, volume)
	src = null
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(!C.wear_mask) // If not wearing a mask
			C.adjustToxLoss(2) // 4 toxic damage per application, doubled for some reason
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.dna)
					if(H.species.flags[IS_PLANT]) //plantmen take a LOT of damage
						H.adjustToxLoss(50)

/datum/reagent/toxin/chloralhydrate
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	description = "A powerful sedative."
	reagent_state = SOLID
	color = "#000067" // rgb: 0, 0, 103
	toxpwr = 0
	custom_metabolism = 0.1 //Default 0.2
	overdose = 15
	overdose_dam = 6
	restrict_species = list(IPC, DIONA)

/datum/reagent/toxin/chloralhydrate/on_general_digest(mob/living/M)
	..()
	if(!data)
		data = 1
	data++
	switch(data)
		if(1)
			M.confused += 2
			M.drowsyness += 2
		if(2 to 199)
			M.Weaken(30)
		if(200 to INFINITY)
			M.sleeping += 1

datum/reagent/toxin/potassium_chloride
	name = "Potassium Chloride"
	id = "potassium_chloride"
	description = "A delicious salt that stops the heart when injected into cardiac muscle."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255,255,255
	toxpwr = 0
	overdose = 30

/datum/reagent/toxin/potassium_chloride/on_general_digest(mob/living/M)
	..()
	if(M.stat != UNCONSCIOUS)
		if (volume >= overdose)
			if(M.losebreath >= 10)
				M.losebreath = max(10, M.losebreath - 10)
			M.adjustOxyLoss(2)
			M.Weaken(10)

/datum/reagent/toxin/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	id = "potassium_chlorophoride"
	description = "A specific chemical based on Potassium Chloride to stop the heart for surgery. Not safe to eat!"
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255,255,255
	toxpwr = 2
	overdose = 20

/datum/reagent/toxin/potassium_chlorophoride/on_general_digest(mob/living/M)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.stat != UNCONSCIOUS)
			if(H.losebreath >= 10)
				H.losebreath = max(10, M.losebreath - 10)
			H.adjustOxyLoss(2)
			H.Weaken(10)

/datum/reagent/toxin/beer2//disguised as normal beer for use by emagged brobots
	name = "Beer"
	id = "beer2"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water. The fermentation appears to be incomplete." //If the players manage to analyze this, they deserve to know something is wrong.
	reagent_state = LIQUID
	color = "#FBBF0D" // rgb: 251, 191, 13
	custom_metabolism = 0.15 // Sleep toxins should always be consumed pretty fast
	overdose = REAGENTS_OVERDOSE * 0.5
	restrict_species = list(IPC, DIONA)

/datum/reagent/toxin/beer2/on_general_digest(mob/living/M)
	..()
	if(!data)
		data = 1
	switch(data)
		if(1)
			M.confused += 2
			M.drowsyness += 2
		if(2 to 50)
			M.sleeping += 1
		if(51 to INFINITY)
			M.sleeping += 1
			M.adjustToxLoss((data - 50) * REM)
	data++

/datum/reagent/toxin/mutetoxin //the new zombie powder. @ TG Port
	name = "Mute Toxin"
	id = "mutetoxin"
	description = "A toxin that temporarily paralyzes the vocal cords."
	color = "#F0F8FF" // rgb: 240, 248, 255
	custom_metabolism = 0.4
	toxpwr = 0

/datum/reagent/toxin/mutetoxin/on_general_digest(mob/living/M)
	..()
	M.silent = max(M.silent, 3)

/datum/reagent/toxin/acid
	name = "Sulphuric acid"
	id = "sacid"
	description = "A very corrosive mineral acid with the molecular formula H2SO4."
	reagent_state = LIQUID
	color = "#DB5008" // rgb: 219, 80, 8
	toxpwr = 1
	var/meltprob = 10

/datum/reagent/toxin/acid/on_general_digest(mob/living/M)
	..()
	M.take_bodypart_damage(0, 1 * REM)

/datum/reagent/toxin/acid/reaction_mob(mob/living/M, method=TOUCH, volume)//magic numbers everywhere
	if(!istype(M, /mob/living))
		return
	if(method == TOUCH)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			if(H.head)
				if(prob(meltprob) && !H.head.unacidable)
					to_chat(H, "<span class='danger'>Your headgear melts away but protects you from the acid!</span>")
					qdel(H.head)
					H.update_inv_head()
					H.update_hair()
				else
					to_chat(H, "<span class='warning'>Your headgear protects you from the acid.</span>")
				return

			if(H.wear_mask)
				if(prob(meltprob) && !H.wear_mask.unacidable)
					to_chat(H, "<span class='danger'>Your mask melts away but protects you from the acid!</span>")
					qdel(H.wear_mask)
					H.update_inv_wear_mask()
					H.update_hair()
				else
					to_chat(H, "<span class='warning'>Your mask protects you from the acid.</span>")
				return

			if(H.glasses) //Doesn't protect you from the acid but can melt anyways!
				if(prob(meltprob) && !H.glasses.unacidable)
					to_chat(H, "<span class='danger'>Your glasses melts away!</span>")
					qdel(H.glasses)
					H.update_inv_glasses()

		else if(ismonkey(M))
			var/mob/living/carbon/monkey/MK = M
			if(MK.wear_mask)
				if(!MK.wear_mask.unacidable)
					to_chat(MK, "<span class='danger'>Your mask melts away but protects you from the acid!</span>")
					qdel(MK.wear_mask)
					MK.update_inv_wear_mask()
				else
					to_chat(MK, "<span class='warning'>Your mask protects you from the acid.</span>")
				return

		if(!M.unacidable)
			if(istype(M, /mob/living/carbon/human) && volume >= 10)
				var/mob/living/carbon/human/H = M
				var/obj/item/organ/external/BP = H.bodyparts_by_name[BP_HEAD]
				if(BP)
					BP.take_damage(4 * toxpwr, 2 * toxpwr)
					if(prob(meltprob)) //Applies disfigurement
						H.emote("scream",,, 1)
						H.status_flags |= DISFIGURED
			else
				M.take_bodypart_damage(min(6 * toxpwr, volume * toxpwr)) // uses min() and volume to make sure they aren't being sprayed in trace amounts (1 unit != insta rape) -- Doohl
	else
		if(!M.unacidable)
			M.take_bodypart_damage(min(6 * toxpwr, volume * toxpwr))

/datum/reagent/toxin/acid/reaction_obj(var/obj/O, var/volume)
	if((istype(O,/obj/item) || istype(O,/obj/effect/glowshroom)) && prob(meltprob * 3))
		if(!O.unacidable)
			var/obj/effect/decal/cleanable/molten_item/I = new/obj/effect/decal/cleanable/molten_item(O.loc)
			I.desc = "Looks like this was \an [O] some time ago."
			for(var/mob/M in viewers(5, O))
				to_chat(M, "\red \the [O] melts.")
			qdel(O)

/datum/reagent/toxin/acid/polyacid
	name = "Polytrinic acid"
	id = "pacid"
	description = "Polytrinic acid is a an extremely corrosive chemical substance."
	reagent_state = LIQUID
	color = "#8E18A9" // rgb: 142, 24, 169
	toxpwr = 2
	meltprob = 30

/datum/reagent/alphaamanitin
	name = "Alpha-amanitin"
	id = "alphaamanitin"
	description = "Deadly rapidly degrading toxin derived from certain species of mushrooms."
	color = "#792300" //rgb: 121, 35, 0
	custom_metabolism = 0.5

/datum/reagent/alphaamanitin/on_general_digest(mob/living/M)
	..()

	M.adjustToxLoss(6)
	M.adjustOxyLoss(2)
	M.adjustBrainLoss(2)

/datum/reagent/aflatoxin
	name = "Aflatoxin"
	id = "aflatoxin"
	description = "Deadly toxin delayed action. Causes general poisoning and damage the structure of DNA."
	reagent_state = LIQUID
	color = "#792300" //rgb: 59, 8, 5
	custom_metabolism = 0.05

/datum/reagent/aflatoxin/on_general_digest(mob/living/M)
	..()

	if(!data)
		data = 1

	if(data >= 165)
		M.adjustToxLoss(4)
		M.apply_effect(5*REM,IRRADIATE,0)
	data++

/datum/reagent/chefspecial	//From VG. Only for traitors
	name = "Chef's Special"
	id = "chefspecial"
	description = "An extremely toxic chemical that will surely end in death."
	reagent_state = LIQUID
	color = "#792300" //rgb: 207, 54, 0
	custom_metabolism = 0.01
	data = 1 //Used as a tally
	taste_message = "DEATH"
	restrict_species = list(IPC, DIONA)

/datum/reagent/chefspecial/on_general_digest(mob/living/M)
	..()

	if(!data)
		data = 1

	if(data >= 165)
		M.death(0)
		M.attack_log += "\[[time_stamp()]\]<font color='red'>Died a quick and painless death by <font color='green'>Chef Excellence's Special Sauce</font>.</font>"
	data++

/datum/reagent/dioxin
	name = "Dioxin"
	id = "dioxin"
	description = "A powerful poison with a cumulative effect."
	reagent_state = LIQUID
	color = "#792300" //rgb: 207, 54, 0
	custom_metabolism = 0 //No metabolism

/datum/reagent/dioxin/on_general_digest(mob/living/M)
	..()
	if(!data)
		data = 1

	if(data >= 130)
		M.make_jittery(2)
		M.make_dizzy(2)
		switch (volume)
			if(10 to 20)
				if(prob(5))
					M.emote(pick("twitch","giggle"))
				if(data >=180)
					M.adjustToxLoss(1)
			if(20 to 30)
				if(prob(10))
					M.emote(pick("twitch","giggle"))
				M.adjustToxLoss(3)
				M.adjustBrainLoss(2)
			if(30 to INFINITY)
				if(prob(20))
					M.emote(pick("twitch","giggle"))
				M.adjustToxLoss(3)
				M.adjustBrainLoss(2)
				if(ishuman(M) && prob(5))
					var/mob/living/carbon/human/H = M
					var/obj/item/organ/internal/heart/IO = H.organs_by_name[O_HEART]
					if(istype(IO))
						IO.take_damage(10, 0)
	data++

/datum/reagent/Destroy() // This should only be called by the holder, so it's already handled clearing its references
	. = ..()
	holder = null


/datum/reagent/mulligan
	name = "Mulligan Toxin"
	id = "mulligan"
	description = "This toxin will rapidly change the DNA of human beings. Commonly used by Syndicate spies and assassins in need of an emergency ID change."
	reagent_state = LIQUID
	color = "#5EFF3B" //RGB: 94, 255, 59
	custom_metabolism = 1000

/datum/reagent/mulligan/on_general_digest(mob/living/carbon/human/H)
	..()
	if(istype(H))
		return
	to_chat(H,"<span class='warning'><b>You grit your teeth in pain as your body rapidly mutates!</b></span>")
	H.visible_message("<b>[H]</b> suddenly transforms!")
	H.gender = pick(MALE, FEMALE)
	if(H.gender == MALE)
		H.name = pick(first_names_male)
	else
		H.name = pick(first_names_female)
	H.name += " [pick(last_names)]"
	H.real_name = H.name
	var/datum/preferences/A = new()	//Randomize appearance for the human
	A.randomize_appearance_for(H)

/datum/reagent/toxin/harvester
	name = "Harvester Toxin"
	id = "harvester"
	description = "A toxic cloud."
	color = "#9C3636"
	toxpwr = 0
	custom_metabolism = 1

/datum/reagent/toxin/harvester/on_general_digest(mob/living/carbon/M)
	..()
	if(!data)
		data = 1
	if(!volume)
		volume = 1
	if(volume > 5)
		M.Weaken(4)

/datum/reagent/toxin/spore
	name = "Spore Toxin"
	id = "spore"
	description = "A toxic spore cloud which blocks vision when ingested."
	color = "#9ACD32"
	toxpwr = 0.5

/datum/reagent/toxin/spore/on_general_digest(mob/living/M)
		..()
		M.damageoverlaytemp = 60
		M.eye_blurry = max(M.eye_blurry, 3)

/datum/reagent/shadowling_blindness_smoke //Blinds non-shadowlings, heals shadowlings/thralls
	name = "Odd Black Liquid"
	id = "blindness_smoke"
	description = "<::ERROR::> CANNOT ANALYZE REAGENT <::ERROR::>"
	color = "#000000" //Complete black (RGB: 0, 0, 0)
	//metabolization_rate = 100 //lel
	custom_metabolism = 100

/datum/reagent/shadowling_blindness_smoke/on_general_digest(mob/living/M)
	..()
	if(!is_shadow_or_thrall(M))
		to_chat(M, "<span class='warning bold'>You breathe in the black smoke, and your eyes burn horribly!</span>")
		M.eye_blind = 5
		if(prob(25))
			M.visible_message("<b>[M]</b> claws at their eyes!")
			M.Stun(3)
	else
		to_chat(M, "<span class='notice bold'>You breathe in the black smoke, and you feel revitalized!</span>")
		M.heal_bodypart_damage(2, 2)
		M.adjustOxyLoss(-2)
		M.adjustToxLoss(-2)