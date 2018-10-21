/datum/reagent/blood
	data = new/list("donor"=null,"viruses"=null,"blood_DNA"=null,"blood_type"=null,"resistances"=null,"trace_chem"=null, "antibodies" = null)
	name = "Blood"
	id = "blood"
	reagent_state = LIQUID
	color = "#c80000" // rgb: 200, 0, 0
	taste_message = "<span class='warning'>blood</span>"

/datum/reagent/blood/reaction_mob(mob/M, method=TOUCH, volume)
	var/datum/reagent/blood/self = src
	src = null
	if(self.data && self.data["viruses"])
		for(var/datum/disease/D in self.data["viruses"])
			//var/datum/disease/virus = new D.type(0, D, 1)
			// We don't spread.
			if(D.spread_type == SPECIAL || D.spread_type == NON_CONTAGIOUS) continue

			if(method == TOUCH)
				M.contract_disease(D)
			else //injected
				M.contract_disease(D, 1, 0)
	if(self.data && self.data["virus2"] && istype(M, /mob/living/carbon))//infecting...
		var/list/vlist = self.data["virus2"]
		if (vlist.len)
			for (var/ID in vlist)
				var/datum/disease2/disease/V = vlist[ID]

				if(method == TOUCH)
					infect_virus2(M,V.getcopy())
				else
					infect_virus2(M,V.getcopy(),1) //injected, force infection!
	if(self.data && self.data["antibodies"] && istype(M, /mob/living/carbon))//... and curing
		var/mob/living/carbon/C = M
		C.antibodies |= self.data["antibodies"]

/datum/reagent/blood/on_diona_digest(mob/living/M)
	..() // Should be put in these procs, in case a xeno of sorts has a reaction to ALL reagents.
	M.adjustCloneLoss(-REM)
	return FALSE // Returning false would mean that generic digestion proc won't be used.

/datum/reagent/blood/reaction_turf(var/turf/simulated/T, var/volume)//splash the blood all over the place
	if(!istype(T))
		return
	var/datum/reagent/blood/self = src
	src = null
	if(!(volume >= 3))
		return
	//var/datum/disease/D = self.data["virus"]
	if(!self.data["donor"] || istype(self.data["donor"], /mob/living/carbon/human))
		var/obj/effect/decal/cleanable/blood/blood_prop = locate() in T //find some blood here
		if(!blood_prop) //first blood!
			blood_prop = new(T)
			blood_prop.blood_DNA[self.data["blood_DNA"]] = self.data["blood_type"]

		for(var/datum/disease/D in self.data["viruses"])
			var/datum/disease/newVirus = D.Copy(1)
			blood_prop.viruses += newVirus
			newVirus.holder = blood_prop

		if(self.data["virus2"])
			blood_prop.virus2 = virus_copylist(self.data["virus2"])


	else if(istype(self.data["donor"], /mob/living/carbon/monkey))
		var/obj/effect/decal/cleanable/blood/blood_prop = locate() in T
		if(!blood_prop)
			blood_prop = new(T)
			blood_prop.blood_DNA["Non-Human DNA"] = "A+"
		for(var/datum/disease/D in self.data["viruses"])
			var/datum/disease/newVirus = D.Copy(1)
			blood_prop.viruses += newVirus
			newVirus.holder = blood_prop

	else if(istype(self.data["donor"], /mob/living/carbon/alien))
		var/obj/effect/decal/cleanable/blood/xeno/blood_prop = locate() in T
		if(!blood_prop)
			blood_prop = new(T)
			blood_prop.blood_DNA["UNKNOWN DNA STRUCTURE"] = "X*"
		for(var/datum/disease/D in self.data["viruses"])
			var/datum/disease/newVirus = D.Copy(1)
			blood_prop.viruses += newVirus
			newVirus.holder = blood_prop

/datum/reagent/vaccine
//data must contain virus type
	name = "Vaccine"
	id = "vaccine"
	reagent_state = LIQUID
	color = "#c81040" // rgb: 200, 16, 64
	taste_message = "health"

/datum/reagent/vaccine/reaction_mob(mob/M, method=TOUCH, volume)
	var/datum/reagent/vaccine/self = src
	src = null
	if(self.data&&method == INGEST)
		for(var/datum/disease/D in M.viruses)
			if(istype(D, /datum/disease/advance))
				var/datum/disease/advance/A = D
				if(A.GetDiseaseID() == self.data)
					D.cure()
			else
				if(D.type == self.data)
					D.cure()

			M.resistances += self.data

/datum/reagent/water
	name = "Water"
	id = "water"
	description = "A ubiquitous chemical substance that is composed of hydrogen and oxygen."
	reagent_state = LIQUID
	color = "#0064c8" // rgb: 0, 100, 200
	custom_metabolism = 0.01
	taste_message = null

/datum/reagent/water/reaction_turf(var/turf/simulated/T, var/volume)
	spawn_fluid(T, volume) // so if will spawn even in space, just for pure visuals
	if (!istype(T))
		return
	src = null
	if(volume >= 3)
		T.make_wet_floor(WATER_FLOOR)

	for(var/mob/living/carbon/slime/M in T)
		M.adjustToxLoss(rand(15,20))

	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles )
		lowertemp.temperature = max( min(lowertemp.temperature-2000,lowertemp.temperature / 2) ,0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

/datum/reagent/water/reaction_obj(var/obj/O, var/volume)
	src = null
	var/turf/T = get_turf(O)
	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles )
		lowertemp.temperature = max( min(lowertemp.temperature-2000,lowertemp.temperature / 2) ,0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)
	if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/monkeycube))
		var/obj/item/weapon/reagent_containers/food/snacks/monkeycube/cube = O
		if(!cube.wrapped)
			cube.Expand()

/datum/reagent/water/on_diona_digest(mob/living/M)
	..()
	M.nutrition += REM
	return FALSE

/datum/reagent/water/holywater
	name = "Holy Water"
	id = "holywater"
	description = "An ashen-obsidian-water mix, this solution will alter certain sections of the brain's rationality."
	color = "#e0e8ef" // rgb: 224, 232, 239
	custom_metabolism = REAGENTS_METABOLISM * 10

/datum/reagent/water/holywater/on_general_digest(mob/living/M)
	if(!..())
		return
	if(holder.has_reagent("unholywater"))
		holder.remove_reagent("unholywater", 2 * REM)
		return
	if(ishuman(M))
		if((M.mind in ticker.mode.cult) && prob(10))
			ticker.mode.remove_cultist(M.mind)
			M.visible_message("<span class='notice'>[M]'s eyes blink and become clearer.</span>",
			"<span class='notice'>A cooling sensation from inside you brings you an untold calmness.</span>")

/datum/reagent/water/holywater/reaction_obj(obj/O, volume)
	src = null
	if(istype(O, /obj/item/weapon/dice/ghost))
		var/obj/item/weapon/dice/ghost/G = O
		var/obj/item/weapon/dice/cleansed = new G.normal_type(G.loc)
		if(istype(G, /obj/item/weapon/dice/ghost/d00))
			cleansed.result = (G.result/10)+1
		else
			cleansed.result = G.result
		cleansed.icon_state = "[initial(cleansed.icon_state)][cleansed.result]"
		if(istype(O.loc, /mob/living)) // Just for the sake of me feeling better.
			var/mob/living/M = O.loc
			M.drop_from_inventory(O)
		qdel(O)
	else if(istype(O, /obj/item/candle/ghost))
		var/obj/item/candle/ghost/G = O
		var/obj/item/candle/cleansed = new /obj/item/candle(G.loc)
		if(G.lit) // Haha, but wouldn't water actually extinguish it?
			cleansed.light("")
		cleansed.wax = G.wax
		if(istype(O.loc, /mob/living))
			var/mob/living/M = O.loc
			M.drop_from_inventory(O)
		qdel(O)
	else if(istype(O, /obj/item/weapon/game_kit/chaplain))
		var/obj/item/weapon/game_kit/chaplain/G = O
		var/obj/item/weapon/game_kit/random/cleansed = new /obj/item/weapon/game_kit/random(G.loc)
		cleansed.board_stat = G.board_stat
		if(istype(O.loc, /mob/living))
			var/mob/living/M = O.loc
			M.drop_from_inventory(O)
		qdel(O)
	else if(istype(O, /obj/item/weapon/pen/ghost))
		var/obj/item/weapon/pen/ghost/G = O
		new /obj/item/weapon/pen(G.loc)
		if(istype(O.loc, /mob/living))
			var/mob/living/M = O.loc
			M.drop_from_inventory(O)
		qdel(O)
	else if(istype(O, /obj/item/weapon/storage/fancy/black_candle_box))
		var/obj/item/weapon/storage/fancy/black_candle_box/G = O
		G.teleporter_delay++ // Basically adds half a minute delay

/datum/reagent/lube
	name = "Space Lube"
	id = "lube"
	description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. giggity."
	reagent_state = LIQUID
	color = "#009ca8" // rgb: 0, 156, 168
	overdose = REAGENTS_OVERDOSE
	taste_message = "oil"

/datum/reagent/lube/reaction_turf(var/turf/simulated/T, var/volume)
	if (!istype(T))
		return
	src = null
	if(volume >= 1)
		T.make_wet_floor(LUBE_FLOOR)

/datum/reagent/plasticide
	name = "Plasticide"
	id = "plasticide"
	description = "Liquid plastic, do not eat."
	reagent_state = LIQUID
	color = "#cf3600" // rgb: 207, 54, 0
	custom_metabolism = 0.01
	taste_message = "plastic"

/datum/reagent/plasticide/on_general_digest(mob/living/M)
	..()
	// Toxins are really weak, but without being treated, last very long.
	M.adjustToxLoss(0.2)

/datum/reagent/oxygen
	name = "Oxygen"
	id = "oxygen"
	description = "A colorless, odorless gas."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	taste_message = null
	custom_metabolism = 0.01

/datum/reagent/oxygen/on_vox_digest(mob/living/M)
	..()
	M.adjustToxLoss(REAGENTS_METABOLISM)
	holder.remove_reagent(id, REAGENTS_METABOLISM) //By default it slowly disappears.
	return FALSE

/datum/reagent/copper
	name = "Copper"
	id = "copper"
	description = "A highly ductile metal."
	color = "#6E3B08" // rgb: 110, 59, 8
	taste_message = null
	custom_metabolism = 0.01

/datum/reagent/nitrogen
	name = "Nitrogen"
	id = "nitrogen"
	description = "A colorless, odorless, tasteless gas."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	taste_message = null
	custom_metabolism = 0.01

/datum/reagent/nitrogen/on_diona_digest(mob/living/M)
	..()
	M.adjustBruteLoss(-REM)
	M.adjustOxyLoss(-REM)
	M.adjustToxLoss(-REM)
	M.adjustFireLoss(-REM)
	M.nutrition += REM
	return FALSE

/datum/reagent/nitrogen/on_vox_digest(mob/living/M)
	..()
	M.adjustOxyLoss(-2 * REM)
	holder.remove_reagent(id, REAGENTS_METABOLISM) //By default it slowly disappears.
	return FALSE

/datum/reagent/hydrogen
	name = "Hydrogen"
	id = "hydrogen"
	description = "A colorless, odorless, nonmetallic, tasteless, highly combustible diatomic gas."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	taste_message = null
	custom_metabolism = 0.01

/datum/reagent/potassium
	name = "Potassium"
	id = "potassium"
	description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
	reagent_state = SOLID
	color = "#A0A0A0" // rgb: 160, 160, 160
	taste_message = "bad ideas"
	custom_metabolism = 0.01

/datum/reagent/mercury
	name = "Mercury"
	id = "mercury"
	description = "A chemical element."
	reagent_state = LIQUID
	color = "#484848" // rgb: 72, 72, 72
	overdose = REAGENTS_OVERDOSE
	taste_message = "druggie poison"
	restrict_species = list(IPC, DIONA)

/datum/reagent/mercury/on_general_digest(mob/living/M)
	..()
	if(M.canmove && !M.restrained() && istype(M.loc, /turf/space))
		step(M, pick(cardinal))
	if(prob(5))
		M.emote(pick("twitch","drool","moan"))
	M.adjustBrainLoss(2)

/datum/reagent/sulfur
	name = "Sulfur"
	id = "sulfur"
	description = "A chemical element with a pungent smell."
	reagent_state = SOLID
	color = "#BF8C00" // rgb: 191, 140, 0
	taste_message = "impulsive decisions"
	custom_metabolism = 0.01

/datum/reagent/carbon
	name = "Carbon"
	id = "carbon"
	description = "A chemical element, the builing block of life."
	reagent_state = SOLID
	color = "#1C1300" // rgb: 30, 20, 0
	taste_message = "like a pencil or something"
	custom_metabolism = 0.01

/datum/reagent/carbon/reaction_turf(var/turf/T, var/volume)
	src = null
	if(!istype(T, /turf/space))
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, T)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(T)
			dirtoverlay.alpha = volume * 30
		else
			dirtoverlay.alpha = min(dirtoverlay.alpha + volume * 30, 255)

/datum/reagent/chlorine
	name = "Chlorine"
	id = "chlorine"
	description = "A chemical element with a characteristic odour."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	overdose = REAGENTS_OVERDOSE
	taste_message = "characteristic taste"

/datum/reagent/chlorine/on_general_digest(mob/living/M)
	..()
	M.take_bodypart_damage(1 * REM, 0)

/datum/reagent/fluorine
	name = "Fluorine"
	id = "fluorine"
	description = "A highly-reactive chemical element."
	reagent_state = GAS
	color = "#808080" // rgb: 128, 128, 128
	overdose = REAGENTS_OVERDOSE
	taste_message = "toothpaste"

/datum/reagent/fluorine/on_general_digest(mob/living/M)
	..()
	M.adjustToxLoss(REM)

/datum/reagent/sodium
	name = "Sodium"
	id = "sodium"
	description = "A chemical element, readily reacts with water."
	reagent_state = SOLID
	color = "#808080" // rgb: 128, 128, 128
	taste_message = "horrible misjudgement"
	custom_metabolism = 0.01

/datum/reagent/phosphorus
	name = "Phosphorus"
	id = "phosphorus"
	description = "A chemical element, the backbone of biological energy carriers."
	reagent_state = SOLID
	color = "#832828" // rgb: 131, 40, 40
	taste_message = "misguided choices"
	custom_metabolism = 0.01

/datum/reagent/phosphorus/on_diona_digest(mob/living/M)
	..()
	M.adjustBruteLoss(-REM)
	M.adjustOxyLoss(-REM)
	M.adjustToxLoss(-REM)
	M.adjustFireLoss(-REM)
	M.nutrition += REM
	return FALSE

/datum/reagent/lithium
	name = "Lithium"
	id = "lithium"
	description = "A chemical element, used as antidepressant."
	reagent_state = SOLID
	color = "#808080" // rgb: 128, 128, 128
	overdose = REAGENTS_OVERDOSE
	taste_message = "happiness"
	restrict_species = list(IPC, DIONA)

/datum/reagent/lithium/on_general_digest(mob/living/M)
	..()
	if(M.canmove && !M.restrained() && istype(M.loc, /turf/space))
		step(M, pick(cardinal))
	if(prob(5))
		M.emote(pick("twitch","drool","moan"))

/datum/reagent/sugar
	name = "Sugar"
	id = "sugar"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255, 255, 255
	taste_message = "sweetness"

/datum/reagent/sugar/on_general_digest(mob/living/M)
	..()
	M.nutrition += REM

/datum/reagent/glycerol
	name = "Glycerol"
	id = "glycerol"
	description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity."
	reagent_state = LIQUID
	color = "#808080" // rgb: 128, 128, 128
	taste_message = "sweetness"
	custom_metabolism = 0.01

/datum/reagent/radium
	name = "Radium"
	id = "radium"
	description = "Radium is an alkaline earth metal. It is extremely radioactive."
	reagent_state = SOLID
	color = "#C7C7C7" // rgb: 199,199,199
	taste_message = "bonehurting juice"

/datum/reagent/radium/on_general_digest(mob/living/M)
	..()
	M.apply_effect(2 * REM,IRRADIATE, 0)
	// radium may increase your chances to cure a disease
	if(istype(M,/mob/living/carbon)) // make sure to only use it on carbon mobs
		var/mob/living/carbon/C = M
		if(C.virus2.len)
			for(var/ID in C.virus2)
				var/datum/disease2/disease/V = C.virus2[ID]
				if(prob(5))
					if(prob(50))
						M.radiation += 50 // curing it that way may kill you instead
						var/mob/living/carbon/human/H
						if(istype(C,/mob/living/carbon/human))
							H = C
						if(!H || (H.species && !H.species.flags[RAD_ABSORB]))
							M.adjustToxLoss(100)
					M:antibodies |= V.antigen

/datum/reagent/radium/reaction_turf(var/turf/T, var/volume)
	src = null
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)

/datum/reagent/thermite
	name = "Thermite"
	id = "thermite"
	description = "Thermite produces an aluminothermic reaction known as a thermite reaction. Can be used to melt walls."
	reagent_state = SOLID
	color = "#673910" // rgb: 103, 57, 16

/datum/reagent/thermite/reaction_turf(var/turf/T, var/volume)
	src = null
	if(volume >= 5)
		if(istype(T, /turf/simulated/wall))
			var/turf/simulated/wall/W = T
			W.thermite = 1
			W.overlays += image('icons/effects/effects.dmi',icon_state = "#673910")

/datum/reagent/thermite/on_general_digest(mob/living/M)
	..()
	M.adjustFireLoss(1)

/datum/reagent/iron
	name = "Iron"
	id = "iron"
	description = "Pure iron is a metal."
	reagent_state = SOLID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE
	taste_message = "metal"

/datum/reagent/gold
	name = "Gold"
	id = "gold"
	description = "Gold is a dense, soft, shiny metal and the most malleable and ductile metal known."
	reagent_state = SOLID
	color = "#F7C430" // rgb: 247, 196, 48
	taste_message = "bling"

/datum/reagent/silver
	name = "Silver"
	id = "silver"
	description = "A soft, white, lustrous transition metal, it has the highest electrical conductivity of any element and the highest thermal conductivity of any metal."
	reagent_state = SOLID
	color = "#D0D0D0" // rgb: 208, 208, 208
	taste_message = "sub-par bling"

/datum/reagent/uranium
	name ="Uranium"
	id = "uranium"
	description = "A silvery-white metallic chemical element in the actinide series, weakly radioactive."
	reagent_state = SOLID
	color = "#B8B8C0" // rgb: 184, 184, 192
	taste_message = "bonehurting juice"

/datum/reagent/uranium/on_general_digest(mob/living/M)
	..()
	M.apply_effect(1, IRRADIATE, 0)

/datum/reagent/uranium/reaction_turf(var/turf/T, var/volume)
	src = null
	if(volume >= 3)
		if(!istype(T, /turf/space))
			var/obj/effect/decal/cleanable/greenglow/glow = locate(/obj/effect/decal/cleanable/greenglow, T)
			if(!glow)
				new /obj/effect/decal/cleanable/greenglow(T)

/datum/reagent/aluminum
	name = "Aluminum"
	id = "aluminum"
	description = "A silvery white and ductile member of the boron group of chemical elements."
	reagent_state = SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168
	taste_message = null

/datum/reagent/silicon
	name = "Silicon"
	id = "silicon"
	description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
	reagent_state = SOLID
	color = "#A8A8A8" // rgb: 168, 168, 168
	taste_message = "a CPU"

/datum/reagent/space_cleaner
	name = "Space cleaner"
	id = "cleaner"
	description = "A compound used to clean things. Now with 50% more sodium hypochlorite!"
	reagent_state = LIQUID
	color = "#A5F0EE" // rgb: 165, 240, 238
	overdose = REAGENTS_OVERDOSE
	taste_message = "floor cleaner"

/datum/reagent/space_cleaner/reaction_obj(var/obj/O, var/volume)
	if(istype(O,/obj/effect/decal/cleanable))
		qdel(O)
	else
		if(O)
			O.clean_blood()

/datum/reagent/space_cleaner/reaction_turf(var/turf/T, var/volume)
	if(volume >= 1)
		if(istype(T, /turf/simulated))
			var/turf/simulated/S = T
			S.dirt = 0
		T.clean_blood()
		for(var/obj/effect/decal/cleanable/C in T.contents)
			src.reaction_obj(C, volume)
			qdel(C)

		for(var/mob/living/carbon/slime/M in T)
			M.adjustToxLoss(rand(5,10))

/datum/reagent/space_cleaner/reaction_mob(mob/M, method=TOUCH, volume)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(H.lip_style)
				H.lip_style = null
				H.update_body()
		if(C.r_hand)
			C.r_hand.clean_blood()
		if(C.l_hand)
			C.l_hand.clean_blood()
		if(C.wear_mask)
			if(C.wear_mask.clean_blood())
				C.update_inv_wear_mask()
		if(ishuman(M))
			var/mob/living/carbon/human/H = C
			if(H.head)
				if(H.head.clean_blood())
					H.update_inv_head()
			if(H.wear_suit)
				if(H.wear_suit.clean_blood())
					H.update_inv_wear_suit()
			else if(H.w_uniform)
				if(H.w_uniform.clean_blood())
					H.update_inv_w_uniform()
			if(H.shoes)
				if(H.shoes.clean_blood())
					H.update_inv_shoes()
			else
				H.clean_blood(1)
				return
		M.clean_blood()

/datum/reagent/nanites
	name = "Nanomachines"
	id = "nanites"
	description = "Microscopic construction robots."
	reagent_state = LIQUID
	color = "#535E66" // rgb: 83, 94, 102
	taste_message = "nanomachines, son"

/datum/reagent/nanites/reaction_mob(mob/M, method=TOUCH, volume)
	src = null
	if( (prob(10) && method==TOUCH) || method==INGEST)
		M.contract_disease(new /datum/disease/robotic_transformation(0),1)

/datum/reagent/xenomicrobes
	name = "Xenomicrobes"
	id = "xenomicrobes"
	description = "Microbes with an entirely alien cellular structure."
	reagent_state = LIQUID
	color = "#535E66" // rgb: 83, 94, 102
	taste_message = "something alien"

/datum/reagent/xenomicrobes/reaction_mob(mob/M, method=TOUCH, volume)
	src = null
	if( (prob(10) && method==TOUCH) || method==INGEST)
		M.contract_disease(new /datum/disease/xeno_transformation(0),1)

/datum/reagent/fluorosurfactant//foam precursor
	name = "Fluorosurfactant"
	id = "fluorosurfactant"
	description = "A perfluoronated sulfonic acid that forms a foam when mixed with water."
	reagent_state = LIQUID
	color = "#9E6B38" // rgb: 158, 107, 56
	taste_message = null

/datum/reagent/foaming_agent// Metal foaming agent. This is lithium hydride. Add other recipes (e.g. LiH + H2O -> LiOH + H2) eventually.
	name = "Foaming agent"
	id = "foaming_agent"
	description = "A agent that yields metallic foam when mixed with light metal and a strong acid."
	reagent_state = SOLID
	color = "#664B63" // rgb: 102, 75, 99
	taste_message = null

/datum/reagent/ammonia
	name = "Ammonia"
	id = "ammonia"
	description = "A caustic substance commonly used in fertilizer or household cleaners."
	reagent_state = GAS
	color = "#404030" // rgb: 64, 64, 48
	taste_message = "floor cleaner"

/datum/reagent/ultraglue
	name = "Ultra Glue"
	id = "glue"
	description = "An extremely powerful bonding agent."
	color = "#FFFFCC" // rgb: 255, 255, 204
	taste_message = null

/datum/reagent/diethylamine
	name = "Diethylamine"
	id = "diethylamine"
	description = "A secondary amine, mildly corrosive."
	reagent_state = LIQUID
	color = "#604030" // rgb: 96, 64, 48

/datum/reagent/diethylamine/on_diona_digest(mob/living/M)
	..()
	M.nutrition += 2 * REM
	return FALSE

/datum/reagent/diethylamine/reaction_mob(mob/M, method = TOUCH, volume)
	if(volume >= 1 && ishuman(M))
		var/mob/living/carbon/human/H = M
		var/list/species_hair = list()
		if(!(H.head && ((H.head.flags & BLOCKHAIR) || (H.head.flags & HIDEEARS))))
			for(var/i in hair_styles_list)
				var/datum/sprite_accessory/hair/tmp_hair = hair_styles_list[i]
				if(i == "Bald")
					continue
				if(H.species.name in tmp_hair.species_allowed)
					species_hair += i
			if(species_hair.len)
				H.h_style = pick(species_hair)
		var/list/species_facial_hair = list()
		if(!((H.wear_mask && (H.wear_mask.flags & MASKCOVERSMOUTH)) || (H.head && (H.head.flags & MASKCOVERSMOUTH))))
			for(var/i in facial_hair_styles_list) // In case of a not so far future.
				var/datum/sprite_accessory/hair/tmp_hair = facial_hair_styles_list[i]
				if(i == "Shaved")
					continue
				if(H.species.name in tmp_hair.species_allowed)
					species_facial_hair += i
			if(species_facial_hair.len)
				H.f_style = pick(species_facial_hair)
		H.update_hair()

/////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////// Chemlights ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/reagent/luminophore_temp //Temporary holder of vars used in mixing colors
	name = "Luminophore"
	id = "luminophore"
	description = "Uh, some kind of drink."
	reagent_state = LIQUID
	nutriment_factor = 0.2
	color = "#ffffff"
	custom_metabolism = 0.2
	taste_message = "bitterness"

/datum/reagent/luminophore
	name = "Luminophore"
	id = "luminophore"
	description = "Uh, some kind of drink."
	reagent_state = LIQUID
	color = "#ffffff"
	custom_metabolism = 0.2
	taste_message = "bitterness"

/datum/reagent/luminophore/on_general_digest(mob/living/M)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.vomit()
		H.apply_effect(1,IRRADIATE,0)

/datum/reagent/hair_dye
	name = "Hair Dye"
	id = "whitehairdye"
	description = "A compound used to dye hair. Any hair."
	data = new/list("r_color"=255,"g_color"=255,"b_color"=255)
	reagent_state = LIQUID
	color = "#FFFFFF" // to see rgb just look into data!
	taste_message = "liquid colour"

/datum/reagent/hair_dye/red
	name = "Red Hair Dye"
	id = "redhairdye"
	data = list("r_color"=255,"g_color"=0,"b_color"=0)
	color = "#FF0000"

/datum/reagent/hair_dye/green
	name = "Green Hair Dye"
	id = "greenhairdye"
	data = list("r_color"=0,"g_color"=255,"b_color"=0)
	color = "#00FF00"

/datum/reagent/hair_dye/blue
	name = "Blue Hair Dye"
	id = "bluehairdye"
	data = list("r_color"=0,"g_color"=0,"b_color"=255)
	color = "#0000FF"

/datum/reagent/hair_dye/black
	name = "Black Hair Dye"
	id = "blackhairdye"
	data = list("r_color"=0,"g_color"=0,"b_color"=0)
	color = "#000000"

/datum/reagent/hair_dye/brown
	name = "Brown Hair Dye"
	id = "brownhairdye"
	data = list("r_color"=50,"g_color"=0,"b_color"=0)
	color = "#500000"

/datum/reagent/hair_dye/blond
	name = "Blond Hair Dye"
	id = "blondhairdye"
	data = list("r_color"=255,"g_color"=225,"b_color"=135)
	color = "#FFE187"

/datum/chemical_reaction/hair_dye
	name = "Hair Dye"
	id = "whitehairdye"
	result = "whitehairdye"
	required_reagents = list("lube" = 1, "sodiumchloride" = 1)
	result_amount = 2

/datum/chemical_reaction/hair_dye/red
	name = "Red Hair Dye"
	id = "redhairdye"
	result = "redhairdye"
	required_reagents = list("hairdye" = 1, "iron" = 1)
	result_amount = 1 // They don't mix, instead they react.

/datum/chemical_reaction/hair_dye/blue
	name = "Blue Hair Dye"
	id = "bluehairdye"
	result = "bluehairdye"
	required_reagents = list("hairdye" = 1, "copper" = 1)
	result_amount = 1

/datum/chemical_reaction/hair_dye/green
	name = "Green Hair Dye"
	id = "greenhairdye"
	result = "greenhairdye"
	required_reagents = list("hairdye" = 1, "chlorine" = 1)
	result_amount = 1

/datum/chemical_reaction/hair_dye/black
	name = "Black Hair Dye"
	id = "blackhairdye"
	result = "blackhairdye"
	required_reagents = list("hairdye" = 1, "carbon" = 1)
	result_amount = 1

/datum/chemical_reaction/hair_dye/brown
	name = "Brown Hair Dye"
	id = "brownhairdye"
	result = "brownhairdye"
	required_reagents = list("hairdye" = 1, "sulfur" = 1)
	result_amount = 1

/datum/chemical_reaction/hair_dye/blond
	name = "Blond Hair Dye"
	id = "blondhairdye"
	result = "blondhairdye"
	required_reagents = list("hairdye" = 1, "sugar" = 1)
	result_amount = 1

/datum/reagent/hair_dye/reaction_mob(mob/M, method=TOUCH, volume)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/r_tweak = ((data["r_color"] * volume) / 10) // volume of 10 basically just replaces the color alltogether, a potent hair dye this is.
		var/g_tweak = ((data["g_color"] * volume) / 10)
		var/b_tweak = ((data["b_color"] * volume) / 10)
		var/volume_coefficient = max((10-volume)/10, 0)
		if(H.client && volume >= 5 && !H.glasses)
			H.eye_blurry = max(H.eye_blurry, volume)
			H.eye_blind = max(H.eye_blind, 1)
		if(volume >= 10 && H.species && H.species.flags[HAS_SKIN_COLOR])
			if(!H.wear_suit && !H.w_uniform && !H.shoes && !H.head && !H.wear_mask) // You either paint the full body, or beard/hair
				H.r_skin = Clamp(round(H.r_skin*max((100-volume)/100, 0) + r_tweak*0.1), 0, 255) // Full body painting is costly! Hence, *0.1
				H.g_skin = Clamp(round(H.g_skin*max((100-volume)/100, 0) + g_tweak*0.1), 0, 255)
				H.b_skin = Clamp(round(H.b_skin*max((100-volume)/100, 0) + b_tweak*0.1), 0, 255)
				H.r_hair = Clamp(round(H.r_hair*max((100-volume)/100, 0) + r_tweak*0.1), 0, 255) // If you're painting full body, all the painting is costly.
				H.g_hair = Clamp(round(H.g_hair*max((100-volume)/100, 0) + g_tweak*0.1), 0, 255)
				H.b_hair = Clamp(round(H.b_hair*max((100-volume)/100, 0) + b_tweak*0.1), 0, 255)
				H.r_facial = Clamp(round(H.r_facial*max((100-volume)/100, 0) + r_tweak*0.1), 0, 255)
				H.g_facial = Clamp(round(H.g_facial*max((100-volume)/100, 0) + g_tweak*0.1), 0, 255)
				H.b_facial = Clamp(round(H.b_facial*max((100-volume)/100, 0) + b_tweak*0.1), 0, 255)
		else if(H.species && H.species.name in list(HUMAN, UNATHI, TAJARAN))
			if(!(H.head && (H.head.flags & HEADCOVERSMOUTH)) && H.h_style != "Bald")
				H.r_hair = Clamp(round(H.r_hair*volume_coefficient + r_tweak), 0, 255)
				H.g_hair = Clamp(round(H.g_hair*volume_coefficient + g_tweak), 0, 255)
				H.b_hair = Clamp(round(H.b_hair*volume_coefficient + b_tweak), 0, 255)
			if(!(H.wear_mask && (H.wear_mask.flags & MASKCOVERSMOUTH)) && H.f_style != "Shaved")
				H.r_facial = Clamp(round(H.r_facial*volume_coefficient + r_tweak), 0, 255)
				H.g_facial = Clamp(round(H.g_facial*volume_coefficient + g_tweak), 0, 255)
				H.b_facial = Clamp(round(H.b_facial*volume_coefficient + b_tweak), 0, 255)
		if(!H.head && !H.wear_mask && H.h_style == "Bald" && H.f_style == "Shaved" && volume >= 5)
			H.lip_style = "spray_face"
			H.lip_color = color
		H.update_hair()
		H.update_body()

/datum/reagent/ectoplasm
	name = "Ectoplasm"
	id = "ectoplasm"
	description = "A spooky scary substance to explain ghosts and stuff."
	reagent_state = LIQUID
	taste_message = "spooky ghosts"
	data = 1
	color = "#FFA8E4" // rgb: 255, 168, 228

/datum/reagent/ectoplasm/on_mob_life(mob/living/M)
	M.hallucination += 1
	M.make_jittery(2)
	switch(data)
		if(1 to 15)
			M.make_jittery(2)
			M.hallucination = max(M.hallucination, 3)
			if(prob(1))
				to_chat(src, "<span class='warning'>You see... [pick(nightmares)] ...</span>")
				M.emote("faint") // Seeing ghosts ain't an easy thing for your mind.
		if(15 to 45)
			M.make_jittery(4)
			M.druggy = max(M.druggy, 15)
			M.hallucination = max(M.hallucination, 10)
			if(prob(5))
				to_chat(src, "<span class='warning'>You see... [pick(nightmares)] ...</span>")
				M.emote("faint")
		if(45 to 90)
			M.make_jittery(8)
			M.druggy = max(M.druggy, 30)
			M.hallucination = max(M.hallucination, 60)
			if(prob(10))
				to_chat(src, "<span class='warning'>You see... [pick(nightmares)] ...</span>")
				M.emote("faint")
		if(90 to 180)
			M.make_jittery(8)
			M.druggy = max(M.druggy, 35)
			M.hallucination = max(M.hallucination, 60)
			if(prob(10))
				to_chat(src, "<span class='warning'>You see... [pick(nightmares)] ...</span>")
				M.emote("faint")
			if(prob(5))
				M.adjustBrainLoss(5)
		if(180 to INFINITY)
			M.adjustBrainLoss(100)
	data++

/datum/reagent/water/unholywater
	name = "Unholy Water"
	id = "unholywater"
	description = "A corpsen-ectoplasmic-water mix, this solution could alter concepts of reality itself."
	data = 1
	color = "#C80064" // rgb: 200,0, 100
	custom_metabolism = REAGENTS_METABOLISM * 10

/datum/reagent/water/unholywater/on_mob_life(mob/living/M)
	if(!..())
		return
	if(iscultist(M) && prob(10))
		switch(data)
			if(1 to 30)
				M.heal_bodypart_damage(1, 1)
			if(30 to 60)
				M.heal_bodypart_damage(2, 2)
			if(60 to INFINITY)
				M.heal_bodypart_damage(3, 3)
	else if(!iscultist(M))
		switch(data)
			if(1 to 20)
				M.make_jittery(3)
			if(20 to 40)
				M.make_jittery(6)
				if(prob(15))
					M.sleeping += 1
			if(40 to 80)
				M.make_jittery(12)
				if(prob(30))
					M.sleeping += 1
			if(80 to INFINITY)
				M.sleeping += 1
	data++

/datum/reagent/water/unholywater/reaction_obj(obj/O, volume)
	src = null
	if(istype(O, /obj/item/weapon/dice))
		var/obj/item/weapon/dice/N = O
		var/obj/item/weapon/dice/cursed = new N.accursed_type(N.loc)
		if(istype(N, /obj/item/weapon/dice/d00))
			cursed.result = (N.result/10)+1
		else
			cursed.result = N.result
		cursed.icon_state = "[initial(cursed.icon_state)][cursed.result]"
		if(istype(O.loc, /mob/living)) // Just for the sake of me feeling better.
			var/mob/living/M = O.loc
			M.drop_from_inventory(O)
		qdel(O)
	else if(istype(O, /obj/item/candle) && !istype(O, /obj/item/candle/ghost))
		var/obj/item/candle/N = O
		var/obj/item/candle/ghost/cursed = new /obj/item/candle/ghost(N.loc)
		if(N.lit) // Haha, but wouldn't water actually extinguish it?
			cursed.light("")
		cursed.wax = N.wax
		if(istype(O.loc, /mob/living))
			var/mob/living/M = O.loc
			M.drop_from_inventory(O)
		qdel(O)
	else if(istype(O, /obj/item/weapon/game_kit) && !istype(O, /obj/item/weapon/game_kit/chaplain))
		var/obj/item/weapon/game_kit/N = O
		var/obj/item/weapon/game_kit/random/cursed = new /obj/item/weapon/game_kit/chaplain(N.loc)
		cursed.board_stat = N.board_stat
		if(istype(O.loc, /mob/living))
			var/mob/living/M = O.loc
			M.drop_from_inventory(O)
		qdel(O)
	else if(istype(O, /obj/item/weapon/pen) && !istype(O, /obj/item/weapon/pen/ghost))
		var/obj/item/weapon/pen/N = O
		new /obj/item/weapon/pen/ghost(N.loc)
		if(istype(O.loc, /mob/living))
			var/mob/living/M = O.loc
			M.drop_from_inventory(O)
		qdel(O)
	else if(istype(O, /obj/item/weapon/storage/fancy/black_candle_box))
		var/obj/item/weapon/storage/fancy/black_candle_box/G = O
		G.teleporter_delay-- // Basically removes half a minute of delay.

/datum/chemical_reaction/unholywater
	name = "Unholy Water"
	id = "unholywater"
	result = "unholywater"
	required_reagents = list("water" = 1, "ectoplasm" = 1)
	result_amount = 1 		// Because rules of logic shouldn't apply here either.

/proc/pretty_string_from_reagent_list(list/reagent_list)
	//Convert reagent list to a printable string for logging etc
	var/result = "| "
	for (var/datum/reagent/R in reagent_list)
		result += "[R.name], [R.volume] | "

	return result

/datum/reagent/antibodies	// pure concentrated antibodies
	data = list("antibodies"=0)
	name = "Antibodies"
	id = "antibodies"
	reagent_state = LIQUID
	color = "#0050F0"

/datum/reagent/antibodies/reaction_mob(mob/M, method=TOUCH, volume)
	if(istype(M,/mob/living/carbon))
		if(src.data && method == INGEST)
			if(M:virus2) if(src.data["antibodies"] & M:virus2.antigen)
				M:virus2.dead = 1
			M:antibodies |= src.data["antibodies"]

// iterate over the list of antigens and see what matches
/proc/antigens2string(antigens)
	var/code = ""
	for(var/V in ANTIGENS) if(text2num(V) & antigens) code += ANTIGENS[V]
	return code

/datum/reagent/paint
	name = "Paint"
	id = "paint_"
	reagent_state = 2
	color = "#808080"
	description = "This paint will only adhere to floor tiles."

/datum/reagent/paint/red
	name = "Red Paint"
	id = "paint_red"
	color = "#FE191A"

/datum/reagent/paint/green
	name = "Green Paint"
	color = "#18A31A"
	id = "paint_green"

/datum/reagent/paint/blue
	name = "Blue Paint"
	color = "#247CFF"
	id = "paint_blue"

/datum/reagent/paint/yellow
	name = "Yellow Paint"
	color = "#FDFE7D"
	id = "paint_yellow"

/datum/reagent/paint/violet
	name = "Violet Paint"
	color = "#CC0099"
	id = "paint_violet"

/datum/reagent/paint/black
	name = "Black Paint"
	color = "#333333"
	id = "paint_black"

/datum/reagent/paint/white
	name = "White Paint"
	color = "#F0F8FF"
	id = "paint_white"

/datum/reagent/paint/reaction_turf(turf/T, volume)
	if(!istype(T) || istype(T, /turf/space))
		return
	var/ind = "[initial(T.icon)][color]"
	if(!cached_icons[ind])
		var/icon/overlay = new/icon(initial(T.icon))
		overlay.Blend(color,ICON_MULTIPLY)
		overlay.SetIntensity(1.4)
		T.icon = overlay
		cached_icons[ind] = T.icon
	else
		T.icon = cached_icons[ind]

/datum/reagent/paint_remover
	name = "Paint Remover"
	id = "paint_remover"
	description = "Paint remover is used to remove floor paint from floor tiles."
	reagent_state = 2
	color = "#808080"

/datum/reagent/paint_remover/reaction_turf(turf/T, volume)
	if(istype(T) && T.icon != initial(T.icon))
		T.icon = initial(T.icon)

/datum/reagent/coolant
	name = "Coolant"
	id = "coolant"
	description = "Industrial cooling substance."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
