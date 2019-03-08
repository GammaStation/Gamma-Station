/*
	Datum-based species. Should make for much cleaner and easier to maintain mutantrace code.
*/

/datum/species
	var/name                     // Species name.

	var/icobase = 'icons/mob/human_races/r_human.dmi'    // Normal icon set.
	var/deform = 'icons/mob/human_races/r_def_human.dmi' // Mutated icon set.
	var/damage_mask = TRUE
	var/def_eye_icon = "eyes"
	var/eyes = list("default" = "eyes")                                    // Possible icons for eyes.
	var/eye_glow = FALSE

	// Combat vars.
	var/total_health = 100                               // Point at which the mob will enter crit.
	var/unarmed                                          // For empty hand harm-intent attack
	var/unarmed_type = /datum/unarmed_attack
	var/brute_mod = 1                                    // Physical damage multiplier (0 == immunity).
	var/burn_mod = 1                                     // Burn damage multiplier.
	var/oxy_mod = 1                                      // Oxyloss multiplier.
	var/tox_mod = 1                                      // Toxloss multiplier.
	var/brain_mod = 1                                    // Brainloss multiplier.
	var/speed_mod =  0                                   // How fast or slow specific specie.
	var/siemens_coefficient = 1                          // How conductive is the specie.

	var/primitive                     // Lesser form, if any (ie. monkey for humans)
	var/tail                          // Name of tail image in species effects icon file.
	var/language                      // Default racial language, if any.
	var/list/additional_languages = list() // Additional languages, to the primary. These can not be the forced ones.
	var/force_racial_language = FALSE // If TRUE, racial language will be forced by default when speaking.
	var/attack_verb = "punch"         // Empty hand hurt intent verb.
	var/punch_damage = 0              // Extra empty hand attack damage.
	var/mutantrace                    // Safeguard due to old code.
	var/list/butcher_drops = list(/obj/item/weapon/reagent_containers/food/snacks/meat/human = 5)

	var/list/restricted_inventory_slots = list() // Slots that the race does not have due to biological differences.

	var/breath_type = "oxygen"           // Non-oxygen gas breathed, if any.
	var/poison_type = "phoron"           // Poisonous air.
	var/exhale_type = "carbon_dioxide"   // Exhaled gas type.

	var/cold_level_1 = 260  // Cold damage level 1 below this point.
	var/cold_level_2 = 200  // Cold damage level 2 below this point.
	var/cold_level_3 = 120  // Cold damage level 3 below this point.

	var/heat_level_1 = 360  // Heat damage level 1 above this point.
	var/heat_level_2 = 400  // Heat damage level 2 above this point.
	var/heat_level_3 = 1000 // Heat damage level 3 above this point.

	var/body_temperature = 310.15	//non-IS_SYNTHETIC species will try to stabilize at this temperature. (also affects temperature processing)
	var/synth_temp_gain = 0			//IS_SYNTHETIC species will gain this much temperature every second

	var/metabolism_mod = METABOLISM_FACTOR
	var/taste_sensitivity = TASTE_SENSITIVITY_NORMAL //the most widely used factor; humans use a different one
	var/dietflags = 0	// Make sure you set this, otherwise it won't be able to digest a lot of foods
	var/custom_metabolism = 1.0

	var/darksight = 2
	var/nighteyes = 0
	var/hazard_high_pressure = HAZARD_HIGH_PRESSURE   // Dangerously high pressure.
	var/warning_high_pressure = WARNING_HIGH_PRESSURE // High pressure warning.
	var/warning_low_pressure = WARNING_LOW_PRESSURE   // Low pressure warning.
	var/hazard_low_pressure = HAZARD_LOW_PRESSURE     // Dangerously low pressure.

	var/list/flags = list()       // Various specific features.
	var/list/abilities = list()	// For species-derived or admin-given powers
	var/list/ignore_gene_icons = list() // Some species may want to ignore a visual of gene or two.

	var/datum/dirt_cover/blood_color = /datum/dirt_cover/red_blood //Red.
	var/flesh_color = "#FFC896" //Pink.
	var/base_color      //Used when setting species.

	//Used in icon caching.
	var/race_key = 0
	var/icon/icon_template

	/* Species-specific sprites, concept stolen from Paradise//vg/.
	ex:
	sprite_sheets = list(
		"held" = 'icons/mob/path',
		"uniform" = 'icons/mob/path',
		"suit" = 'icons/mob/path',
		"belt" = 'icons/mob/path'
		"head" = 'icons/mob/path',
		"back" = 'icons/mob/path',
		"mask" = 'icons/mob/path',
		"ears" = 'icons/mob/path',
		"eyes" = 'icons/mob/path',
		"feet" = 'icons/mob/path',
		"gloves" = 'icons/mob/path'
		)
	If index term exists and icon_override is not set, this sprite sheet will be used.
	*/

	var/list/sprite_sheets = list()

	// This is default organs set which is mostly used upon mob creation.
	// Keep in mind that position of organ is important in those lists.
	// If hand connects to chest, then chest should go first.
	var/list/has_bodypart = list(
		 BP_CHEST  = /obj/item/organ/external/chest
		,BP_GROIN  = /obj/item/organ/external/groin
		,BP_HEAD   = /obj/item/organ/external/head
		,BP_L_ARM  = /obj/item/organ/external/l_arm
		,BP_R_ARM  = /obj/item/organ/external/r_arm
		,BP_L_LEG  = /obj/item/organ/external/l_leg
		,BP_R_LEG  = /obj/item/organ/external/r_leg
		)

	var/list/has_organ = list(
		 O_HEART   = /obj/item/organ/internal/heart
		,O_BRAIN   = /obj/item/organ/internal/brain
		,O_EYES    = /obj/item/organ/internal/eyes
		,O_LUNGS   = /obj/item/organ/internal/lungs
		,O_LIVER   = /obj/item/organ/internal/liver
		,O_KIDNEYS = /obj/item/organ/internal/kidneys
		)

	var/def_gender = MALE // I'm sorry mate, but the default pawn looks male.
	var/genders = list(MALE, FEMALE)
	var/has_gendered_icons = TRUE // if TRUE = use icon_state with _f or _m for respective gender (see get_icon() external organ proc).

/datum/species/New()
	unarmed = new unarmed_type()

	if(!has_organ[O_HEART])
		flags[NO_BLOOD] = TRUE // this status also uncaps vital body parts damage, since such species otherwise will be very hard to kill.

/datum/species/proc/create_organs(mob/living/carbon/human/H) //Handles creation of mob organs.

	for(var/type in has_bodypart)
		var/path = has_bodypart[type]
		new path(null, H)

	for(var/type in has_organ)
		var/path = has_organ[type]
		new path(null, H)

	if(flags[IS_SYNTHETIC])
		for(var/obj/item/organ/external/BP in H.bodyparts)
			if(BP.status & (ORGAN_CUT_AWAY | ORGAN_DESTROYED))
				continue
			BP.status |= ORGAN_ROBOT
		for(var/obj/item/organ/internal/IO in H.organs)
			IO.mechanize()

/datum/species/proc/handle_post_spawn(mob/living/carbon/human/H) //Handles anything not already covered by basic species assignment.
	return

/datum/species/proc/on_gain(mob/living/carbon/human/H)
	return

/datum/species/proc/on_loose(mob/living/carbon/human/H)
	return

/datum/species/proc/regen(mob/living/carbon/human/H, light_amount) // Perhaps others will regenerate in different ways?
	return

/datum/species/proc/call_digest_proc(mob/living/M, datum/reagent/R) // Humans don't have a seperate proc, but need to return TRUE so general proc is called.
	return TRUE

/datum/species/proc/on_emp_act(mob/living/M, emp_severity)
	return

/datum/species/proc/handle_death(mob/living/carbon/human/H) //Handles any species-specific death events (such nymph spawns).
	if(flags[IS_SYNTHETIC])
 //H.make_jittery(200) //S-s-s-s-sytem f-f-ai-i-i-i-i-lure-ure-ure-ure
		H.h_style = ""
		spawn(100)
			//H.is_jittery = 0
			//H.jitteriness = 0
			H.update_hair()
	return

/datum/species/proc/on_life(mob/living/carbon/human/H)
	return

/datum/species/proc/before_job_equip(mob/living/carbon/human/H, datum/job/J) // Do we really need this proc? Perhaps.
	return

/datum/species/proc/after_job_equip(mob/living/carbon/human/H, datum/job/J)
	var/obj/item/weapon/storage/box/SK
	if(J.title in list("Shaft Miner", "Chief Engineer", "Station Engineer", "Atmospheric Technician"))
		SK = new /obj/item/weapon/storage/box/engineer(H)
	else
		SK = new /obj/item/weapon/storage/box/survival(H)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(SK, slot_r_hand)
	else
		H.equip_to_slot_or_del(SK, slot_in_backpack)

/datum/species/human
	name = HUMAN
	language = "Sol Common"
	primitive = /mob/living/carbon/monkey
	unarmed_type = /datum/unarmed_attack/punch
	dietflags = DIET_OMNI

	flags = list(
	 HAS_SKIN_TONE = TRUE
	,HAS_LIPS = TRUE
	,HAS_UNDERWEAR = TRUE
	,HAS_HAIR = TRUE
	)

	//If you wanted to add a species-level ability:
	/*abilities = list(/client/proc/test_ability)*/

/datum/species/unathi
	name = UNATHI
	icobase = 'icons/mob/human_races/r_lizard.dmi'
	deform = 'icons/mob/human_races/r_def_lizard.dmi'
	language = "Sinta'unathi"
	tail = "sogtail"
	unarmed_type = /datum/unarmed_attack/claws
	dietflags = DIET_CARN
	primitive = /mob/living/carbon/monkey/unathi
	darksight = 3

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	heat_level_1 = 420 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000

	brute_mod = 0.80
	burn_mod = 0.90
	speed_mod = 0.7

	flags = list(
	 IS_WHITELISTED = TRUE
	,HAS_LIPS = TRUE
	,HAS_UNDERWEAR = TRUE
	,HAS_TAIL = TRUE
	,HAS_SKIN_COLOR = TRUE
	,NO_MINORCUTS = TRUE
	)

	flesh_color = "#34AF10"
	base_color = "#066000"

/datum/species/unathi/call_digest_proc(mob/living/M, datum/reagent/R)
	return R.on_unathi_digest(M)

/datum/species/unathi/after_job_equip(mob/living/carbon/human/H, datum/job/J)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H), slot_shoes, 1)

/datum/species/tajaran
	name = TAJARAN
	icobase = 'icons/mob/human_races/r_tajaran.dmi'
	deform = 'icons/mob/human_races/r_def_tajaran.dmi'
	language = "Siik'maas"
	additional_languages = list("Siik'tajr")
	tail = "tajtail"
	unarmed_type = /datum/unarmed_attack/claws
	dietflags = DIET_OMNI
	taste_sensitivity = TASTE_SENSITIVITY_SHARP
	darksight = 8
	nighteyes = 1

	cold_level_1 = 200 //Default 260
	cold_level_2 = 140 //Default 200
	cold_level_3 = 80 //Default 120

	heat_level_1 = 330 //Default 360
	heat_level_2 = 380 //Default 400
	heat_level_3 = 800 //Default 1000

	primitive = /mob/living/carbon/monkey/tajara

	brute_mod = 1.20
	burn_mod = 1.20
	speed_mod = -0.7

	flags = list(
	 IS_WHITELISTED = TRUE
	,HAS_LIPS = TRUE
	,HAS_UNDERWEAR = TRUE
	,HAS_TAIL = TRUE
	,HAS_SKIN_COLOR = TRUE
	,HAS_HAIR = TRUE
	)

	flesh_color = "#AFA59E"
	base_color = "#333333"

/datum/species/tajaran/call_digest_proc(mob/living/M, datum/reagent/R)
	return R.on_tajaran_digest(M)

/datum/species/tajaran/after_job_equip(mob/living/carbon/human/H, datum/job/J)
	..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H), slot_shoes, 1)

/datum/species/skrell
	name = SKRELL
	icobase = 'icons/mob/human_races/r_skrell.dmi'
	deform = 'icons/mob/human_races/r_def_skrell.dmi'
	language = "Skrellian"
	primitive = /mob/living/carbon/monkey/skrell
	unarmed_type = /datum/unarmed_attack/punch
	dietflags = DIET_HERB
	metabolism_mod = SKRELL_METABOLISM_FACTOR
	taste_sensitivity = TASTE_SENSITIVITY_DULL

	siemens_coefficient = 1.3 // Because they are wet and slimy.

	flags = list(
	 IS_WHITELISTED = TRUE
	,HAS_LIPS = TRUE
	,HAS_UNDERWEAR = TRUE
	,HAS_SKIN_COLOR = TRUE
	)

	has_organ = list(
		O_HEART   = /obj/item/organ/internal/heart,
		O_BRAIN   = /obj/item/organ/internal/brain,
		O_EYES    = /obj/item/organ/internal/eyes,
		O_LUNGS   = /obj/item/organ/internal/lungs/skrell,
		O_LIVER   = /obj/item/organ/internal/liver,
		O_KIDNEYS = /obj/item/organ/internal/kidneys
		)

	def_eye_icon = "skrell_eyes"
	eyes = list("default" = "skrell_eyes")
	blood_color = /datum/dirt_cover/purple_blood
	flesh_color = "#8CD7A3"

/datum/species/skrell/call_digest_proc(mob/living/M, datum/reagent/R)
	return R.on_skrell_digest(M)

/datum/species/vox
	name = VOX
	icobase = 'icons/mob/human_races/r_vox.dmi'
	deform = 'icons/mob/human_races/r_def_vox.dmi'
	language = "Vox-pidgin"
	force_racial_language = TRUE
	unarmed_type = /datum/unarmed_attack/claws	//I dont think it will hurt to give vox claws too.
	dietflags = DIET_OMNI

	warning_low_pressure = 50
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	def_eye_icon = "vox_eyes"
	eyes = list("default" = "vox_eyes")

	breath_type = "nitrogen"
	poison_type = "oxygen"

	flags = list(
		NO_SCAN = TRUE
	)

	blood_color = /datum/dirt_cover/blue_blood
	flesh_color = "#808D11"

	sprite_sheets = list(
		"suit" = 'icons/mob/species/vox/suit.dmi',
		"head" = 'icons/mob/species/vox/head.dmi',
		"mask" = 'icons/mob/species/vox/masks.dmi',
		"feet" = 'icons/mob/species/vox/shoes.dmi',
		"gloves" = 'icons/mob/species/vox/gloves.dmi'
		)

/datum/species/vox/call_digest_proc(mob/living/M, datum/reagent/R)
	return R.on_vox_digest(M)

/datum/species/vox/after_job_equip(mob/living/carbon/human/H, datum/job/J)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vox(src), slot_wear_mask)
	if(!H.r_hand)
		H.equip_to_slot_or_del(new /obj/item/weapon/tank/nitrogen(src), slot_r_hand)
		H.internal = H.r_hand
	else if(!H.l_hand)
		H.equip_to_slot_or_del(new /obj/item/weapon/tank/nitrogen(src), slot_l_hand)
		H.internal = H.l_hand
	H.internals.icon_state = "internal1"

/datum/species/vox/on_gain(mob/living/carbon/human/H)
	if(name != VOX_ARMALIS)
		H.leap_icon = new /obj/screen/leap()
		H.leap_icon.screen_loc = "CENTER+3:20,SOUTH:5"

		if(H.hud_used)
			H.hud_used.adding += H.leap_icon
		if(H.client)
			H.client.screen += H.leap_icon

	else
		H.verbs += /mob/living/carbon/human/proc/gut

	return ..()

/datum/species/vox/on_loose(mob/living/carbon/human/H)
	if(name != VOX_ARMALIS)
		if(H.leap_icon)
			if(H.hud_used)
				H.hud_used.adding -= H.leap_icon
			if(H.client)
				H.client.screen -= H.leap_icon
			QDEL_NULL(H.leap_icon)

	else
		H.verbs -= /mob/living/carbon/human/proc/gut

	return ..()

/datum/species/vox/armalis
	name = VOX_ARMALIS
	icobase = 'icons/mob/human_races/r_armalis.dmi'
	deform = 'icons/mob/human_races/r_armalis.dmi'
	damage_mask = FALSE
	language = "Vox-pidgin"
	unarmed_type = /datum/unarmed_attack/claws/armalis
	dietflags = DIET_OMNI	//should inherit this from vox, this is here just in case

	warning_low_pressure = 50
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	heat_level_1 = 2000
	heat_level_2 = 3000
	heat_level_3 = 4000

	brute_mod = 0.2
	burn_mod = 0.2

	def_eye_icon = "blank_eyes"
	eyes = list("default" = "blank_eyes")
	breath_type = "nitrogen"
	poison_type = "oxygen"

	flags = list(
	 NO_SCAN = TRUE
	,NO_BLOOD = TRUE
	,HAS_TAIL = TRUE
	,NO_PAIN = TRUE
	,NO_FAT = TRUE
	)

	blood_color = /datum/dirt_cover/blue_blood
	flesh_color = "#808D11"
	tail = "armalis_tail"
	icon_template = 'icons/mob/human_races/r_armalis.dmi'

	sprite_sheets = list(
		"suit" = 'icons/mob/species/armalis/suit.dmi',
		"gloves" = 'icons/mob/species/armalis/gloves.dmi',
		"feet" = 'icons/mob/species/armalis/feet.dmi',
		"head" = 'icons/mob/species/armalis/head.dmi',
		"held" = 'icons/mob/species/armalis/held.dmi'
		)

/datum/species/diona
	name = DIONA
	icobase = 'icons/mob/human_races/r_diona.dmi'
	deform = 'icons/mob/human_races/r_def_plant.dmi'
	language = "Rootspeak"
	unarmed_type = /datum/unarmed_attack/diona
	dietflags = 0		//Diona regenerate nutrition in light, no diet necessary
	taste_sensitivity = TASTE_SENSITIVITY_NO_TASTE
	primitive = /mob/living/carbon/monkey/diona

	siemens_coefficient = 0.5 // Because they are plants and stuff.

	hazard_low_pressure = DIONA_HAZARD_LOW_PRESSURE

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 2000
	heat_level_2 = 3000
	heat_level_3 = 4000

	burn_mod = 1.3
	speed_mod = 7

	restricted_inventory_slots = list(slot_wear_mask, slot_glasses, slot_gloves, slot_shoes) // These are trees. Not people. Deal with the fact that they don't have these.

	body_temperature = T0C + 15		//make the plant people have a bit lower body temperature, why not
	butcher_drops = list(/obj/item/stack/sheet/wood = 5)

	flags = list(
	 IS_WHITELISTED = TRUE
	,NO_BREATHE = TRUE
	,REQUIRE_LIGHT = TRUE
	,NO_SCAN = TRUE
	,IS_PLANT = TRUE
	,RAD_ABSORB = TRUE
	,NO_BLOOD = TRUE
	,NO_PAIN = TRUE
	,NO_FINGERPRINT = TRUE
	,NO_FAT = TRUE
	)

	has_bodypart = list(
		 BP_CHEST  = /obj/item/organ/external/chest
		,BP_GROIN  = /obj/item/organ/external/groin
		,BP_HEAD   = /obj/item/organ/external/head/diona
		,BP_L_ARM  = /obj/item/organ/external/l_arm
		,BP_R_ARM  = /obj/item/organ/external/r_arm
		,BP_L_LEG  = /obj/item/organ/external/l_leg
		,BP_R_LEG  = /obj/item/organ/external/r_leg
		)

	has_organ = list(
		O_HEART   = /obj/item/organ/internal/heart,
		O_BRAIN   = /obj/item/organ/internal/brain/diona,
		O_EYES    = /obj/item/organ/internal/eyes,
		O_LUNGS   = /obj/item/organ/internal/lungs/diona,
		O_LIVER   = /obj/item/organ/internal/liver/diona,
		O_KIDNEYS = /obj/item/organ/internal/kidneys/diona
		)

	blood_color = /datum/dirt_cover/green_blood
	flesh_color = "#907E4A"


	def_gender = NEUTER
	genders = list(NEUTER, PLURAL)
	has_gendered_icons = FALSE

/datum/species/diona/regen(mob/living/carbon/human/H, light_amount)
	if(light_amount >= 5) // If you can regen organs - do so.
		for(var/obj/item/organ/internal/O in H.organs)
			if(O.damage)
				O.damage -= light_amount/5
				H.nutrition -= light_amount
				return
	if(H.nutrition > 350 && light_amount >= 4) // If you don't need to regen organs, regen bodyparts.
		if(!H.regenerating_bodypart) // If there is none currently, go ahead, find it.
			H.regenerating_bodypart = H.find_damaged_bodypart()
		if(H.regenerating_bodypart) // If it did find one.
			H.nutrition -= 1
			H.apply_damages(0,0,1,1,0,0)
			H.regen_bodyparts(0, TRUE)
			return
	if(light_amount >= 3) // If you don't need to regen bodyparts, fix up small things.
		H.adjustBruteLoss(-(light_amount))
		H.adjustToxLoss(-(light_amount))
		H.adjustOxyLoss(-(light_amount))


/datum/species/diona/call_digest_proc(mob/living/M, datum/reagent/R)
	return R.on_diona_digest(M)

/datum/species/diona/after_job_equip(mob/living/carbon/human/H, datum/job/J)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/diona_survival(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/diona_survival(H), slot_in_backpack)

/datum/species/diona/handle_death(mob/living/carbon/human/H)

	var/mob/living/carbon/monkey/diona/S = new(get_turf(H))

	if(H.mind)
		H.mind.transfer_to(S)

	for(var/mob/living/carbon/monkey/diona/D in H.contents)
		if(D.client)
			D.loc = H.loc
		else
			qdel(D)

	H.visible_message("\red[H] splits apart with a wet slithering noise!")

/datum/species/machine
	name = IPC
	icobase = 'icons/mob/human_races/r_machine.dmi'
	deform = 'icons/mob/human_races/r_machine.dmi'
	language = "Trinary"
	unarmed_type = /datum/unarmed_attack/punch
	dietflags = 0		//IPCs can't eat, so no diet
	taste_sensitivity = TASTE_SENSITIVITY_NO_TASTE

	def_eye_icon = "blank_eyes"
	eyes = list("default" = "blank_eyes")

	warning_low_pressure = 50
	hazard_low_pressure = 0

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 500		//gives them about 25 seconds in space before taking damage
	heat_level_2 = 1000
	heat_level_3 = 2000

	synth_temp_gain = 10 //this should cause IPCs to stabilize at ~80 C in a 20 C environment.

	brute_mod = 1.5
	burn_mod = 1
	siemens_coefficient = 1.3 // ROBUTT.

	butcher_drops = list(/obj/item/stack/sheet/plasteel = 3)

	flags = list(
	 IS_WHITELISTED = TRUE
	,NO_BREATHE = TRUE
	,NO_SCAN = TRUE
	,NO_BLOOD = TRUE
	,NO_PAIN = TRUE
	,IS_SYNTHETIC = TRUE
	,VIRUS_IMMUNE = TRUE
	,BIOHAZZARD_IMMUNE = TRUE
	,NO_FINGERPRINT = TRUE
	,NO_MINORCUTS = TRUE
	,RAD_IMMUNE = TRUE
	,NO_FAT = TRUE
	)

	has_bodypart = list(
		 BP_CHEST  = /obj/item/organ/external/chest
		,BP_GROIN  = /obj/item/organ/external/groin
		,BP_HEAD   = /obj/item/organ/external/head/ipc
		,BP_L_ARM  = /obj/item/organ/external/l_arm
		,BP_R_ARM  = /obj/item/organ/external/r_arm
		,BP_L_LEG  = /obj/item/organ/external/l_leg
		,BP_R_LEG  = /obj/item/organ/external/r_leg
		)

	has_organ = list(
		 O_HEART   = /obj/item/organ/internal/heart/ipc
		,O_BRAIN   = /obj/item/organ/internal/brain/ipc
		,O_EYES    = /obj/item/organ/internal/eyes/ipc
		,O_LUNGS   = /obj/item/organ/internal/lungs/ipc
		,O_LIVER   = /obj/item/organ/internal/liver/ipc
		,O_KIDNEYS = /obj/item/organ/internal/kidneys/ipc
		)

	blood_color = /datum/dirt_cover/oil
	flesh_color = "#575757"

	def_gender = NEUTER
	genders = list(MALE, FEMALE, NEUTER, PLURAL)

/datum/species/machine/after_job_equip(mob/living/carbon/human/H, datum/job/J)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ipc_survival(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ipc_survival(H), slot_in_backpack)

/datum/species/abductor
	name = ABDUCTOR
	darksight = 3
	dietflags = DIET_OMNI

	butcher_drops = list()

	icobase = 'icons/mob/human_races/r_abductor.dmi'
	deform = 'icons/mob/human_races/r_abductor.dmi'

	flags = list(
	 NO_BREATHE = TRUE
	,NO_BLOOD = TRUE
	,NO_SCAN = TRUE
	,VIRUS_IMMUNE = TRUE
	)

	blood_color = /datum/dirt_cover/gray_blood

	def_gender = NEUTER
	genders = list(NEUTER)

/datum/species/abductor/call_digest_proc(mob/living/M, datum/reagent/R)
	return R.on_abductor_digest(M)

/datum/species/skeleton
	name = SKELETON

	icobase = 'icons/mob/human_races/r_skeleton.dmi'
	deform = 'icons/mob/human_races/r_skeleton.dmi'
	damage_mask = FALSE
	dietflags = 0

	siemens_coefficient = 0

	butcher_drops = list()

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 2000
	heat_level_2 = 3000
	heat_level_3 = 4000

	flags = list(
	 NO_BREATHE = TRUE
	,NO_BLOOD = TRUE
	,NO_SCAN = TRUE
	,NO_PAIN = TRUE
	,RAD_IMMUNE = TRUE
	,VIRUS_IMMUNE = TRUE
	,BIOHAZZARD_IMMUNE = TRUE
	,NO_FINGERPRINT = TRUE
	)

	has_gendered_icons = FALSE
	def_gender = NEUTER
	genders = list(NEUTER)

/datum/species/skeleton/call_digest_proc(mob/living/M, datum/reagent/R)
	return R.on_skeleton_digest(M)

//Species unarmed attacks

/datum/unarmed_attack
	var/attack_verb = list("attack")	// Empty hand hurt intent verb.
	var/damage = 0						// Extra empty hand attack damage.
	var/attack_sound = "punch"
	var/miss_sound = 'sound/weapons/punchmiss.ogg'
	var/sharp = 0
	var/edge = 0

/datum/unarmed_attack/proc/damage_flags()
	return (sharp ? DAM_SHARP : 0) | (edge ? DAM_EDGE : 0)

/datum/unarmed_attack/punch
	attack_verb = list("punch")

/datum/unarmed_attack/diona
	attack_verb = list("lash", "bludgeon")
	damage = 5

/datum/unarmed_attack/claws
	attack_verb = list("scratch", "claw")
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	damage = 5
	sharp = 1
	edge = 1

/datum/unarmed_attack/claws/armalis
	attack_verb = list("slash", "claw")
	damage = 10	//they're huge! they should do a little more damage, i'd even go for 15-20 maybe...

/datum/species/shadowling
	name = SHADOWLING
	icobase = 'icons/mob/human_races/r_shadowling.dmi'
	deform = 'icons/mob/human_races/r_shadowling.dmi'
	language = "Sol Common"
	unarmed_type = /datum/unarmed_attack/claws
	dietflags = DIET_OMNI

	butcher_drops = list()

	warning_low_pressure = 50
	hazard_low_pressure = -1

	siemens_coefficient = 0 // Spooky shadows don't need to be hurt by your pesky electricity.

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 2000
	heat_level_2 = 3000
	heat_level_3 = 4000

	blood_color = /datum/dirt_cover/black_blood
	darksight = 8

	butcher_drops = list() // They are just shadows. Why should they drop anything?

	restricted_inventory_slots = list(slot_belt, slot_wear_id, slot_l_ear, slot_r_ear, slot_back, slot_l_store, slot_r_store)

	has_organ = list(O_HEART = /obj/item/organ/internal/heart) // A huge buff to be honest.

	flags = list(
	 NO_BREATHE = TRUE
	,NO_BLOOD = TRUE
	,NO_EMBED = TRUE
	,RAD_IMMUNE = TRUE
	,VIRUS_IMMUNE = TRUE
	,NO_FINGERPRINT = TRUE
	,NO_MINORCUTS
	)

	burn_mod = 2
	brain_mod = 0

	has_gendered_icons = FALSE
	def_gender = NEUTER
	genders = list(NEUTER, PLURAL)

/datum/species/shadowling/call_digest_proc(mob/living/M, datum/reagent/R)
	return R.on_shadowling_digest(M)

/datum/species/golem
	name = GOLEM

	icobase = 'icons/mob/human_races/r_golem.dmi'
	deform = 'icons/mob/human_races/r_golem.dmi'
	dietflags = 0 //this is ROCK

	butcher_drops = list(/obj/item/weapon/ore/diamond = 1, /obj/item/weapon/ore/slag = 3)

	total_health = 200
	oxy_mod = 0
	tox_mod = 0
	brain_mod = 0
	speed_mod = 2

	blood_color = /datum/dirt_cover/adamant_blood
	flesh_color = "#137E8F"

	flags = list(
		NO_BLOOD = TRUE,
		NO_BREATHE = TRUE,
		NO_SCAN = TRUE,
		NO_PAIN = TRUE,
		NO_EMBED = TRUE,
		RAD_IMMUNE = TRUE,
		VIRUS_IMMUNE = TRUE,
		BIOHAZZARD_IMMUNE = TRUE,
		NO_FINGERPRINT = TRUE,
		NO_MINORCUTS = TRUE
		)

	has_organ = list(
		O_BRAIN = /obj/item/organ/internal/brain
		)

	has_gendered_icons = FALSE

/datum/species/golem/on_gain(mob/living/carbon/human/H)
	H.status_flags &= ~(CANSTUN | CANWEAKEN | CANPARALYSE)
	H.dna.mutantrace = "adamantine"
	H.real_name = text("Adamantine Golem ([rand(1, 1000)])")

	for(var/x in list(H.w_uniform, H.head, H.wear_suit, H.shoes, H.wear_mask, H.gloves))
		if(x)
			H.remove_from_mob(x)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/golem, slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/golem, slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/golem, slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/golem, slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/golem, slot_wear_mask)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/golem, slot_gloves)

	return ..()

/datum/species/golem/on_loose(mob/living/carbon/human/H)
	H.status_flags |= MOB_STATUS_FLAGS_DEFAULT
	H.dna.mutantrace = null
	H.real_name = "unknown"

	for(var/x in list(H.w_uniform, H.head, H.wear_suit, H.shoes, H.wear_mask, H.gloves))
		if(x)
			var/list/golem_items = list(
				/obj/item/clothing/under/golem,
				/obj/item/clothing/head/helmet/space/golem,
				/obj/item/clothing/suit/space/golem,
				/obj/item/clothing/shoes/golem,
				/obj/item/clothing/mask/gas/golem,
				/obj/item/clothing/gloves/golem
				)

			if(is_type_in_list(x, golem_items))
				qdel(x)

	return ..()

/datum/species/golem/call_digest_proc(mob/living/M, datum/reagent/R)
	return R.on_golem_digest(M)

/datum/species/zombie
	name = ZOMBIE
	darksight = 8
	nighteyes = 1
	dietflags = DIET_OMNI

	icobase = 'icons/mob/human_races/r_zombie.dmi'
	deform = 'icons/mob/human_races/r_zombie.dmi'

	flags = list(
	NO_BREATHE = TRUE
	,HAS_LIPS = TRUE
	,HAS_UNDERWEAR = TRUE
	,NO_SCAN = TRUE
	,NO_PAIN = TRUE
	,VIRUS_IMMUNE = TRUE
	)

	brute_mod = 2
	burn_mod = 1
	oxy_mod = 0
	tox_mod = 0
	speed_mod = -0.2

	var/list/spooks = list('sound/hallucinations/growl1.ogg','sound/hallucinations/growl2.ogg','sound/hallucinations/growl3.ogg','sound/hallucinations/veryfar_noise.ogg','sound/hallucinations/wail.ogg')

/datum/species/zombie/handle_post_spawn(mob/living/carbon/human/H)
	return ..()

/datum/species/zombie/on_gain(mob/living/carbon/human/H)
	H.status_flags &= ~(CANSTUN  | CANPARALYSE) //CANWEAKEN

	H.drop_l_hand()
	H.drop_r_hand()

	H.equip_to_slot_or_del(new /obj/item/weapon/melee/zombie_hand, slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/weapon/melee/zombie_hand/right, slot_r_hand)

	add_zombie(H)

	return ..()

/datum/species/zombie/on_loose(mob/living/carbon/human/H)
	H.status_flags |= MOB_STATUS_FLAGS_DEFAULT

	if(istype(H.l_hand, /obj/item/weapon/melee/zombie_hand))
		qdel(H.l_hand)

	if(istype(H.r_hand, /obj/item/weapon/melee/zombie_hand))
		qdel(H.r_hand)

	remove_zombie(H)

	return ..()


/datum/species/zombie/tajaran
	name = ZOMBIE_TAJARAN

	icobase = 'icons/mob/human_races/r_zombie_tajaran.dmi'
	deform = 'icons/mob/human_races/r_zombie_tajaran.dmi'

	brute_mod = 2.2
	burn_mod = 1.2
	speed_mod = -0.8

	tail = "zombie_tajtail"

	flesh_color = "#AFA59E"
	base_color = "#000000"

	flags = list(
	NO_BREATHE = TRUE
	,HAS_LIPS = TRUE
	,HAS_UNDERWEAR = TRUE
	,NO_SCAN = TRUE
	,NO_PAIN = TRUE
	,VIRUS_IMMUNE = TRUE
	,HAS_TAIL = TRUE
	)

/datum/species/zombie/skrell
	name = ZOMBIE_SKRELL

	icobase = 'icons/mob/human_races/r_zombie_skrell.dmi'
	deform = 'icons/mob/human_races/r_zombie_skrell.dmi'

	def_eye_icon = "skrell_eyes"
	eyes = list("default" = "skrell_eyes")
	blood_color = /datum/dirt_cover/purple_blood
	flesh_color = "#8CD7A3"
	base_color = "#000000"

/datum/species/zombie/unathi
	name = ZOMBIE_UNATHI

	icobase = 'icons/mob/human_races/r_zombie_lizard.dmi'
	deform = 'icons/mob/human_races/r_zombie_lizard.dmi'

	brute_mod = 1.80
	burn_mod = 0.90
	speed_mod = -0.2

	tail = "zombie_sogtail"

	flesh_color = "#34AF10"
	base_color = "#000000"

	flags = list(
	NO_BREATHE = TRUE
	,HAS_LIPS = TRUE
	,HAS_UNDERWEAR = TRUE
	,NO_SCAN = TRUE
	,NO_PAIN = TRUE
	,VIRUS_IMMUNE = TRUE
	,HAS_TAIL = TRUE
	)

/datum/species/tycheon // Do keep in mind that they use nutrition as static electricity, which they can waste.
	name = "Tycheon"
	icobase = 'icons/mob/human_races/r_tycheon.dmi'
	deform = 'icons/mob/human_races/r_tycheon.dmi'
	damage_mask = FALSE

	def_eye_icon = "core" // It's also glowing.
	eyes = list("default" = "core", "round" = "round_core", "angled" = "angle_core",
	            "inner eye" = "inner_eye_core", "diplopia" = "duo_core", "quadruplopia" = "four_core",
	            "spider" = "spider_core", "pentaplopia" = "navi_core", "moonman" = "r_n_m_core",
	            "maw" = "maw_core")
	eye_glow = TRUE

	brute_mod = 3.0
	burn_mod = 3.0
	brain_mod = 0.0
	speed_mod =  -1.0
	siemens_coefficient = 0.0

	custom_metabolism = 0.0

	language = "The Perfect Control"
	additional_languages = list("The Gaping Maw")
	force_racial_language = TRUE

	butcher_drops = list()
	taste_sensitivity = 0
	dietflags = 0

	flags = list(IS_WHITELISTED = TRUE,
	             NO_BLOOD = TRUE,
	             NO_BREATHE = TRUE,
	             NO_SCAN = TRUE,
	             HAS_SKIN_COLOR = TRUE,
	             RAD_IMMUNE = TRUE,
	             VIRUS_IMMUNE = TRUE,
	             BIOHAZZARD_IMMUNE = TRUE,
	             IS_FLYING = TRUE,
	             IS_IMMATERIAL = TRUE,
	             STATICALLY_CHARGED = TRUE,
	             NO_FAT = TRUE,
	             EMP_HEAL = TRUE)
	abilities = list()

	ignore_gene_icons = list("All")
	blood_color = /datum/dirt_cover/tycheon_blood
	flesh_color = "#1F1F1F"
	base_color = "#BB1111"

	body_temperature = 300 // Which is slightly lower than the normal human being. Slight deviations from Tycheon's bodytemperature may result in... Bleh.
	cold_level_1 = 273
	cold_level_2 = 263
	cold_level_3 = 253
	// Default seems to be 293.3.
	heat_level_1 = 313
	heat_level_2 = 323
	heat_level_3 = 333

	warning_low_pressure = 90
	hazard_low_pressure = 70

	has_bodypart = list(
		 BP_CHEST  = /obj/item/organ/external/chest/tycheon
		,BP_L_ARM  = /obj/item/organ/external/l_arm/tycheon
		,BP_R_ARM  = /obj/item/organ/external/r_arm/tycheon
		,BP_L_LEG  = /obj/item/organ/external/l_leg/tycheon
		,BP_R_LEG  = /obj/item/organ/external/r_leg/tycheon
		)
	has_organ = list(
		O_BRAIN   = /obj/item/organ/internal/brain/tycheon
		)
	restricted_inventory_slots = list(slot_back, slot_wear_mask, slot_handcuffed, slot_l_hand, slot_r_hand, slot_belt, slot_l_ear, slot_r_ear, slot_glasses, slot_glasses,
	                                  slot_shoes, slot_w_uniform, slot_l_store, slot_r_store, slot_s_store, slot_in_backpack, slot_legcuffed, slot_legs, slot_tie, slot_head) // Still allows them to wear rigs, and ids.
	has_gendered_icons = FALSE
	def_gender = NEUTER
	genders = list(NEUTER, PLURAL)

/datum/species/tycheon/call_digest_proc(mob/living/M, datum/reagent/R)
	return R.on_tycheon_digest(M)

/datum/species/tycheon/on_emp_act(mob/living/carbon/human/H, emp_severity)
	switch(emp_severity)
		if(1.0)
			H.heal_overall_damage(10.0, 10.0)
		if(2.0)
			H.heal_overall_damage(1.0, 1.0)

/datum/species/tycheon/handle_death(mob/living/carbon/human/H)
	var/core_amount = 1
	switch(H.eyes) // Depending on how many cores we got, we drop different stuff.
		if("duo_core")
			core_amount = 2
		if("four_core")
			core_amount = 4
		if("spider_core")
			core_amount = 4
		if("r_n_m_core")
			core_amount = 5
		if("navi_core")
			core_amount = 5
		if("maw_core")
			core_amount = 6
	for(var/i in 1 to core_amount)
		var/obj/item/core = new /obj/item/weapon/reagent_containers/food/snacks/tycheon_core(H.loc)
		core.throw_at(get_edge_target_turf(H, pick(alldirs)), 1, core.throw_speed)
	H.gib()

/mob/living/carbon/human/proc/metal_bend()
	set name = "Bend Metal"
	set desc = "Using metal around you to do wonders."
	set category = "Tycheon"
	if(metal_bending)
		metal_bending = FALSE
		return
	metal_bending = TRUE
	var/list/list_of_metal = list()
	for(var/obj/item/stack/sheet/metal/M in view(1, src))
		list_of_metal += M
	for(var/obj/item/stack/sheet/metal/M in list_of_metal)
		metal_retracting:
			while(M.get_amount() >= 1)
				if(!metal_bending)
					return
				if(!in_range(src, M)) // Nobody would've thought, but do_after() for any reason doesn't work here.
					break metal_retracting
				if(do_after(src, 5, TRUE, M, FALSE, TRUE))
					var/obj/item/effect/kinetic_blast/K = new(get_turf(M))
					K.name = "circling metal"
					var/obj/item/effect/kinetic_blast/K2 = new(loc)
					K2.name = "circling metal"
					switch(a_intent)
						if(I_DISARM)
							if(nutrition > 207)
								electrocuting:
									for(var/mob/living/L in view(1, src))
										if(nutrition <= 207)
											break electrocuting
										L.electrocute_act(1, src, 1.0)
										nutrition -= 7
							else
								metal_bending = FALSE
								return
						if(I_GRAB)
							var/obj/item/organ/internal/brain/tycheon/core = organs_by_name[O_BRAIN]
							if(core && nutrition > 207)
								core.damage -= 1
								nutrition -= 7
							else
								metal_bending = FALSE
								return
						if(I_HURT)
							if(nutrition > 207)
								nutrition -= 7
								empulse(src, 0, 1)
							else
								metal_bending = FALSE
								return
					M.use(1)
	metal_bending = FALSE

/mob/living/carbon/human/proc/toggle_sphere()
	set name = "Toggle Iron Sphere"
	set desc = "Requires metal and charge, creates an iron sphere to protect you."
	set category = "Tycheon"
	if(metal_bending)
		metal_bending = FALSE
		return
	metal_bending = TRUE
	if(istype(wear_suit, /obj/item/clothing/suit/space/rig/tycheon))
		drop_from_inventory(wear_suit, loc)
		metal_bending = FALSE
		return
	else if(!wear_suit) // They use nutrition as their static charge, which is needed for telekinetic actions.
		if(nutrition < 250)
			to_chat(src, "<span class='warning'>Not enough static charge.</span>")
			metal_bending = FALSE
			return
		var/list/list_of_metal = list()
		for(var/obj/item/stack/sheet/metal/M in view(1, src))
			list_of_metal += M
		var/metal_harvested = 0
		metal_finding:
			for(var/obj/item/stack/sheet/metal/M in list_of_metal)
				metal_retracting:
					while(M.get_amount() >= 1)
						if(!metal_bending)
							return
						if(!in_range(src, M))
							break metal_retracting
						if(nutrition < 250)
							to_chat(src, "<span class='warning'>Not enough static charge.</span>")
							metal_bending = FALSE
							return
						if(do_after(src, 5, TRUE, M, FALSE, TRUE))
							nutrition -= 5
							var/obj/item/effect/kinetic_blast/K = new(M.loc)
							K.name = "circling metal"
							var/obj/item/effect/kinetic_blast/K2 = new(loc)
							K2.name = "circling metal"
							M.use(1)
							metal_harvested++
							if(metal_harvested >= 10)
								break metal_finding
						else // No refunds!
							metal_bending = FALSE
							return
		if(metal_harvested >= 10)
			var/obj/item/clothing/suit/space/rig/tycheon/TR = new /obj/item/clothing/suit/space/rig/tycheon(src)
			TR.refit_for_species(TYCHEON)
			equip_to_slot_or_del(TR, slot_wear_suit)
	metal_bending = FALSE

/obj/item/clothing/suit/space/rig/tycheon
	name = "iron sphere"
	icon_state = "sphere"
	item_state = "sphere"
	icon = 'icons/mob/species/tycheon/suit.dmi'
	slowdown = 3
	flags = HEADCOVERSEYES|BLOCKHAIR|HEADCOVERSMOUTH|THICKMATERIAL|PHORONGUARD|DROPDEL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HEAD|FACE|EYES
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL|HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HEAD|FACE|EYES
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HEAD|FACE|EYES
	max_heat_protection_temperature = 313 // See the tycheon species.
	min_cold_protection_temperature = 273
	armor = list(melee = 75, bullet = 10, laser = 10,energy = 100, bomb = 75, bio = 100, rad = 100, telepathy = 30)

/obj/item/clothing/suit/space/rig/tycheon/equipped(mob/user)
	if(ishuman(user))
		user.pass_flags &= ~(PASSMOB | PASSGRILLE | PASSCRAWL)
		user.status_flags |= CANPUSH

/obj/item/clothing/suit/space/rig/tycheon/dropped(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/effect/kinetic_blast/K = new(H.loc)
		K.name = "circling metal"
		new /obj/item/stack/sheet/metal(H.loc, 10, TRUE)
		H.pass_flags |= PASSMOB | PASSGRILLE | PASSCRAWL
		H.status_flags &= ~CANPUSH
		H.update_body()
	..()

/datum/species/tycheon/on_gain(mob/living/carbon/human/H)
	H.status_flags &= ~(CANSTUN | CANWEAKEN | CANPARALYSE | CANPUSH)
	H.pass_flags |= PASSTABLE | PASSMOB | PASSGRILLE | PASSBLOB | PASSCRAWL
	H.flags |= NOSLIP | NOBLOODY
	H.mutations.Add(TK)
	H.mutations.Add(REMOTE_TALK)
	H.tk_level |= TELEKINETIC_MOB_CONTROL | TELEKINETIC_HARM_WEAKEN |  TELEKINETIC_NO_VIEW_REQUIRED
	H.tk_maxrange = 15 // Before it was 8.
	H.ventcrawler = TRUE
	H.verbs += /mob/living/carbon/human/proc/toggle_sphere
	H.verbs += /mob/living/carbon/human/proc/metal_bend
	H.verbs += /mob/living/carbon/human/proc/toggle_telepathy_hear
	H.verbs += /mob/living/carbon/human/proc/quick_telepathy_say
	H.verbs += /mob/living/carbon/human/proc/force_telepathy_say
	H.verbs += /mob/living/carbon/human/proc/breath_from_tank
	H.toggle_sphere_icon = new /obj/screen/tycheon_ability/toggle_sphere(null, H)
	H.toggle_sphere_icon.screen_loc = "EAST-2:-8,SOUTH+1:-5"
	H.metal_bend_icon = new /obj/screen/tycheon_ability/bend_metal(null, H)
	H.metal_bend_icon.screen_loc = "EAST-2:-8,SOUTH+1:7"
	if(H.hud_used)
		H.hud_used.adding += H.toggle_sphere_icon
		H.hud_used.adding += H.metal_bend_icon
	if(H.client)
		H.client.screen += H.toggle_sphere_icon
		H.client.screen += H.metal_bend_icon
	return ..()

/datum/species/tycheon/on_loose(mob/living/carbon/human/H)
	H.status_flags |= MOB_STATUS_FLAGS_DEFAULT
	H.pass_flags &= ~(PASSTABLE | PASSMOB | PASSGRILLE | PASSBLOB | PASSCRAWL)
	H.flags &= ~(NOSLIP | NOBLOODY)
	H.mutations.Remove(TK)
	H.mutations.Remove(REMOTE_TALK)
	H.tk_level &= ~(TELEKINETIC_MOB_CONTROL | TELEKINETIC_HARM_WEAKEN |  TELEKINETIC_NO_VIEW_REQUIRED)
	H.tk_maxrange = 8 // Before it was 8.
	H.ventcrawler = FALSE
	H.verbs -= /mob/living/carbon/human/proc/toggle_sphere
	H.verbs -= /mob/living/carbon/human/proc/metal_bend
	H.verbs -= /mob/living/carbon/human/proc/toggle_telepathy_hear
	H.verbs -= /mob/living/carbon/human/proc/quick_telepathy_say
	H.verbs -= /mob/living/carbon/human/proc/force_telepathy_say
	H.verbs -= /mob/living/carbon/human/proc/breath_from_tank
	if(H.hud_used)
		if(H.toggle_sphere_icon)
			H.hud_used.adding -= H.toggle_sphere_icon
		if(H.metal_bend_icon)
			H.hud_used.adding -= H.metal_bend_icon
	if(H.client)
		if(H.toggle_sphere_icon)
			H.client.screen -= H.toggle_sphere_icon
		if(H.metal_bend_icon)
			H.client.screen -= H.metal_bend_icon
	QDEL_NULL(H.toggle_sphere_icon)
	QDEL_NULL(H.metal_bend_icon)
	return ..()

/mob/proc/telepathy_hear(verb, message, source, datum/language/language = null) // Makes all those nosy telepathics hear what we hear. Also, please do see game\sound.dm, I have a little bootleg hidden there for you ;).
	for(var/mob/living/M in remote_hearers)
		if(source == M)
			continue
		var/dist = get_dist(src, M)
		if(z != M.z)
			dist += 25
		if(source)
			dist += get_dist(src, source)
		if(!M.do_telepathy(dist))
			continue
		var/star_chance = 0 // A chance to censore some symbols.
		if(dist > MAX_TELEPATHY_RANGE)
			star_chance += dist
		if(M.remote_hearing.len > 3)
			star_chance += M.remote_hearing.len * 5
		star_chance += getarmor(BP_HEAD, "telepathy") + M.getarmor(BP_HEAD, "telepathy")
		if(star_chance)
			stars(message, star_chance)
		if(prob(MAX_TELEPATHY_RANGE - dist)) // The further they are, the lesser the chance to understand something.
			to_chat(src, "<span class='warning'>You feel as if somebody is eavesdropping on you.</span>")

		to_chat(M, "<span class='notice'><span class='bold'>[src]</span> [verb]:</span> [message]")
		if(language && M != src && M != source)
			language.on_message_hear(message, M, source)
		M.telepathy_hear(verb, message, source)

/mob/living/carbon/human/proc/toggle_telepathy_hear((mob/M in (view() + remote_hearing))) // Makes us hear what they hear.
	set name = "Toggle Telepathy Hear"
	set desc = "Hear anything this mob hears."
	set category = "Tycheon"

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.flags[IS_SYNTHETIC])
			to_chat(src, "<span class='notice'>They don't have a mind to eavesdrop on.</span>")
			return

	if(isrobot(M))
		to_chat(src, "<span class='notice'>They don't have a mind to eavesdrop on.</span>")
		return

	if(!M.client || M.stat)
		to_chat(src, "<span class='notice'>They don't have a mind to eavesdrop on.</span>")
		return

	if(src in M.remote_hearers)
		M.remote_hearers -= src
		remote_hearing -= M
		to_chat(src, "<span class='notice'>You stop telepathically eavesdropping on [M]")
	else
		if(remote_hearing.len > 3)
			if(alert("Listening to more than three people may distort your perception, continue?", "Yes", "No") != "Yes")
				return
		remote_hearing += M
		M.remote_hearers += src
		to_chat(src, "<span class='notice'>You start telepathically eavesdropping on [M]")

/mob/living/carbon/human/proc/quick_telepathy_say((mob/living/M in (view() + remote_hearing)))
	set name = "Project Mind(Q)"
	set desc = "Make them hear what you desire. Quickly."
	set category = "Tycheon"

	if(typing)
		return

	if(!M.client || M.stat)
		to_chat(src, "<span class='notice'>[M] doesn't have a mind to project to.</span>")
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.flags[IS_SYNTHETIC])
			to_chat(src, "<span class='notice'>[H] doesn't have a mind to project to.</span>")
			return

	if(isrobot(M))
		to_chat(src, "<span class='notice'>[M] doesn't have a mind to project to.</span>")
		return

	var/image/I = image('icons/mob/talk.dmi', M, "telepathy_typed_to", MOB_LAYER + 0.9)
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	INVOKE_ASYNC(GLOBAL_PROC, /proc/flick_overlay, I, list(client), 3 SECONDS)

	var/image/II = image('icons/mob/talk.dmi', src, "tele_typing", MOB_LAYER + 1)
	II.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

	var/list/show_to = list(M.client, client)
	for(var/client/C in show_to)
		C.images += II

	var/say = input("What do you wish to say", "Telepathic Message") as text|null
	if(!say)
		for(var/client/C in show_to)
			C.images -= II
		return
	else
		say = sanitize(say)
		if(iszombie(src)) // In case of nearing feature.
			say = zombie_talk(say)

	var/image/III = image('icons/mob/talk.dmi', src, "tele_typing", MOB_LAYER + 1)
	III.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	INVOKE_ASYNC(GLOBAL_PROC, /proc/flick_overlay, III, list(client, M.client), 3 SECONDS)

	var/datum/language/speaking = parse_language(say, M) // We can talk in languages they know, but we don't.
	if(!speaking)
		speaking = parse_language(say, src) // Or in languages we know, but they don't.

	if(speaking)
		say = copytext(say, 2 + length(speaking.key))

	var/clean_say = say
	if(speaking)
		say = speaking.format_message(say) //, verb) Verb is actually unused.
	else
		say = "\"[capitalize(say)]\""

	var/dist = get_dist(src, M)
	if(z != M.z)
		dist += 25
	if(!M.do_telepathy(dist))
		for(var/client/C in show_to)
			C.images -= II
		return

	var/star_chance = 0
	if(dist > MAX_TELEPATHY_RANGE)
		star_chance += dist
	star_chance += M.getarmor(BP_HEAD, "telepathy") + getarmor(BP_HEAD, "telepathy")
	if(star_chance)
		stars(say, star_chance)

	if((REMOTE_TALK in M.mutations))
		to_chat(M, "<span class='notice'>You hear <b>[src]'s voice</b>:</span> [say]")
	else
		to_chat(M, "<span class='notice'>You hear a voice that seems to echo around the room:</span> [say]")
	to_chat(src, "<span class='notice'>You project your mind into <b>[M]</b>:</span> [say]")

	if(speaking && M != src)
		speaking.on_message_hear(clean_say, M, src)

	var/mes = say
	for(var/mob/dead/observer/G in dead_mob_list)
		var/track = "<a href='byond://?src=\ref[G];track=\ref[src]'>(F)</a>"
		if((client.prefs.chat_toggles & CHAT_GHOSTEARS) && src in view(G))
			mes = "<b>[say]</b>"
		to_chat(G, "<span class='italics'>Telepathic message from <b>[src]</b>[track]:</span> [mes]")

	M.telepathy_hear("has heard a voice speak", say, src)
	log_say("Telepathic message from [key_name(src)]: [say]")
	for(var/client/C in show_to)
		C.images -= II

/mob/living/carbon/human/proc/force_telepathy_say() // Makes them hear what we want.
	set name = "Project Mind"
	set desc = "Make them hear what you desire."
	set category = "Tycheon"

	if(typing)
		return

	var/quick_pick = null
	var/list/chosen = list()
	if(!quick_pick)
		var/list/choices = list()
		for(var/mob/M in remote_hearing)
			choices |= M
			for(var/mob/M_hears in hearers(M, null))
				choices |= M_hears
		for(var/mob/M in living_mob_list)
			if(M in hearers())
				choices |= M
			else if(REMOTE_TALK in M.mutations)
				choices |= M

		while(TRUE)
			var/input_ = input("Choose recipients", "Telepathic Message") as null|anything in choices
			if(!input_)
				break
			if(input_ in chosen)
				if(chosen.len >= 3)
					to_chat(src, "<span class='notice'>Projecting your mind to so many recipients is too hard.</span>")
					continue
				chosen -= input_
				var/image/I = image('icons/mob/talk.dmi', input_, "telepathy_typed_to_not", MOB_LAYER + 0.9)
				I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
				INVOKE_ASYNC(GLOBAL_PROC, /proc/flick_overlay, I, list(client), 3 SECONDS)
			else
				chosen += input_
				var/image/I = image('icons/mob/talk.dmi', input_, "telepathy_typed_to", MOB_LAYER + 0.9)
				I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
				INVOKE_ASYNC(GLOBAL_PROC, /proc/flick_overlay, I, list(client), 3 SECONDS)
	else
		chosen += quick_pick

	var/list/pos_rec = chosen.Copy() + list(src)
	var/list/bubble_recipients = list()
	for(var/mob/M in pos_rec)
		if(!M.client || M.stat)
			to_chat(src, "<span class='notice'>[M] doesn't have a mind to project to.</span>")
			chosen -= M
			continue

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.species.flags[IS_SYNTHETIC])
				to_chat(src, "<span class='notice'>[H] doesn't have a mind to project to.</span>")
				chosen -= M
				continue

		if(isrobot(M))
			to_chat(src, "<span class='notice'>[M] doesn't have a mind to project to.</span>")
			chosen -= M
			continue

		bubble_recipients += M.client

	if(!chosen.len)
		return

	var/image/I = image('icons/mob/talk.dmi', src, "tele_typing", MOB_LAYER + 1)
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

	for(var/client/C in bubble_recipients)
		C.images += I

	var/say = input("What do you wish to say", "Telepathic Message") as text|null
	if(!say)
		for(var/client/C in bubble_recipients)
			C.images -= I
		return
	else
		say = sanitize(say)
		if(iszombie(src)) // In case of nearing feature.
			say = zombie_talk(say)

	var/image/II = image('icons/mob/talk.dmi', src, "tele_typing", MOB_LAYER + 1)
	II.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	INVOKE_ASYNC(GLOBAL_PROC, /proc/flick_overlay, II, bubble_recipients, 3 SECONDS)

	for(var/mob/living/M in chosen)
		var/cur_say = say
		var/datum/language/speaking = parse_language(say, M) // We can talk in languages they know, but we don't.
		if(!speaking)
			speaking = parse_language(say, src) // Or in languages we know, but they don't.

		if(speaking)
			cur_say = copytext(cur_say, 2 + length(speaking.key))

		var/clean_say = cur_say
		if(speaking)
			cur_say = speaking.format_message(cur_say) //, verb) Verb is actually unused.
		else
			cur_say = "\"[capitalize(say)]\""

		var/dist = get_dist(src, M)
		if(z != M.z)
			dist += 25
		if(!M.do_telepathy(dist))
			continue

		var/star_chance = 0
		if(dist > MAX_TELEPATHY_RANGE)
			star_chance += dist
		star_chance += M.getarmor(BP_HEAD, "telepathy") + getarmor(BP_HEAD, "telepathy")
		if(star_chance)
			stars(cur_say, star_chance)

		if((REMOTE_TALK in M.mutations))
			to_chat(M, "<span class='notice'>You hear <b>[src]'s voice</b>:</span> [cur_say]")
		else
			to_chat(M, "<span class='notice'>You hear a voice that seems to echo around the room:</span> [cur_say]")
		to_chat(src, "<span class='notice'>You project your mind into <b>[M]</b>:</span> [cur_say]")

		if(speaking && M != src)
			speaking.on_message_hear(clean_say, M, src)

		M.telepathy_hear("has heard a voice speak", say, src)

	for(var/mob/dead/observer/G in dead_mob_list)
		var/mes = say
		var/track = "<a href='byond://?src=\ref[G];track=\ref[src]'>(F)</a>"
		if((client.prefs.chat_toggles & CHAT_GHOSTEARS) && src in view(G))
			mes = "<b>[mes]</b>"
		to_chat(G, "<span class='italics'>Telepathic message from <b>[real_name]</b>[track]:</span> [mes]")

	log_say("Telepathic message from [key_name(src)]: [say]")
	for(var/client/C in bubble_recipients)
		C.images -= I

/mob/living/carbon/human/proc/breath_from_tank(obj/item/weapon/tank/T in view(1, src))
	set name = "Inhale From"
	set desc = "Inhales a portion of gas from tank."
	set category = "Tycheon"

	if(!istype(T))
		return

	if(breathing)
		return

	breathing = TRUE

	while(TRUE)
		if(do_after(src, 5, TRUE, T))
			var/datum/gas_mixture/removed = T.air_contents.remove(T.distribute_pressure)
			if(wear_suit)
				breathing = FALSE
				return
			if(removed.gas["phoron"] > 5)
				if(!regenerating_bodypart)
					regenerating_bodypart = find_damaged_bodypart()
				if(regenerating_bodypart)
					regen_bodyparts(0, FALSE)
			if(removed.gas["nitrogen"] > 0)
				heal_overall_damage(removed.gas["nitrogen"], removed.gas["nitrogen"])
