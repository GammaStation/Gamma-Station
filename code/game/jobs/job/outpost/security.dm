/datum/job/security
	title = "Security Officer"
	flag = OFFICER
	department_flag = ENGSEC
	faction = "Outpost"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Star Vigil Commander"
	selection_color = "#ffeeee"
	idtype = /obj/item/weapon/card/id/sec
	access = list(access_outpost_general, access_outpost_security)
	minimal_player_age = 3
	minimal_player_ingame_minutes = 3560
	restricted_species = list(DIONA, TAJARAN)

/datum/job/security/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/outpost_sec(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/outpost(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/handcuffs(H), slot_s_store)
	H.equip_to_slot_or_del(new /obj/item/device/flash(H), slot_l_store)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(H), slot_glasses)

	if(visualsOnly)
		return

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec(H), slot_l_ear)
//	H.equip_to_slot_or_del(new /obj/item/device/pda/security(H), slot_belt)


	return TRUE