datum/reagent/nitroglycerin
	name = "Nitroglycerin"
	id = "nitroglycerin"
	description = "Nitroglycerin is a heavy, colorless, oily, explosive liquid obtained by nitrating glycerol."
	reagent_state = LIQUID
	color = "#808080" // rgb: 128, 128, 128
	taste_message = "oil"
	custom_metabolism = 0.01

/datum/reagent/fuel
	name = "Welding fuel"
	id = "fuel"
	description = "Required for welders. Flamable."
	reagent_state = LIQUID
	color = "#660000" // rgb: 102, 0, 0
	overdose = REAGENTS_OVERDOSE
	taste_message = "motor oil"

/datum/reagent/fuel/reaction_obj(var/obj/O, var/volume)
	var/turf/the_turf = get_turf(O)
	if(!the_turf)
		return //No sense trying to start a fire if you don't have a turf to set on fire. --NEO
	new /obj/effect/decal/cleanable/liquid_fuel(the_turf, volume)

/datum/reagent/fuel/reaction_turf(var/turf/T, var/volume)
	new /obj/effect/decal/cleanable/liquid_fuel(T, volume)

/datum/reagent/fuel/on_general_digest(mob/living/M)
	..()
	M.adjustToxLoss(1)

/datum/reagent/fuel/reaction_mob(mob/living/M, method=TOUCH, volume)//Splashing people with welding fuel to make them easy to ignite!
	if(!istype(M, /mob/living))
		return
	if(method == TOUCH)
		M.adjust_fire_stacks(volume / 10)