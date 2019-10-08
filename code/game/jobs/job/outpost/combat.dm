/datum/job/trooper
	title = "Squad Trooper"
	flag = TROOPER
	department_flag = ENGSEC
	faction = "Outpost"
	total_positions = 6
	spawn_positions = 1
	supervisors = "the Squad Leader"
	selection_color = "#bab86c"
	idtype = /obj/item/weapon/card/id/military/army
	access = list()
	minimal_player_age = 3
	minimal_player_ingame_minutes = 3560
	restricted_species = list(DIONA, TAJARAN, UNATHI, SKRELL, IPC, TYCHEON)

/datum/job/trooper/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)	return FALSE
	var/msg
	H.equip_to_slot_or_del(new /obj/item/clothing/under/military/trooper(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/military/trooper(H), slot_shoes)
//	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/rucksack(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/military/trooper(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/military/trooper(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/trooper(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/trooper(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/trooper(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/small_firstaid_kit/combat(H), slot_l_store)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/assault_rifle/military(H), slot_r_hand)

	var/obj/item/weapon/card/id/C = new idtype(H)
	C.registered_name = H.real_name
	C.rank = "Private"
	C.assignment = "Squad Trooper"
	C.name = "[C.registered_name]'s ID Card ([C.assignment])"
	H.equip_to_slot_or_del(C, slot_wear_id)
	msg = "Вы космический десантник сухопутных сил ООН. На 'Аяксе' вы и ваши сослуживцы являлись непреклонным островком армейского долбоебизма среди бушующего океана флотского маразма."
	to_chat(H,"[sanitize(msg)]")

	return TRUE

/datum/job/leader
	title = "Squad Leader"
	flag = LEADER
	department_flag = ENGSEC
	faction = "Outpost"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Commanding Officer and heads of staff"
	selection_color = "#bab86c"
	idtype = /obj/item/weapon/card/id/military/army
	access = list()
	minimal_player_age = 5
	minimal_player_ingame_minutes = 3800
	restricted_species = list(DIONA, TAJARAN, UNATHI, SKRELL, IPC, TYCHEON)

/datum/job/leader/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)	return FALSE
	var/msg
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/trooper(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/military/trooper/leader(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/military/trooper/leader(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/military/trooper/leader(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/military/trooper/leader(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/trooper/leader(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/trooper/leader(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/small_firstaid_kit/combat(H), slot_l_store)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/assault_rifle/military/carbine(H), slot_r_hand)
	var/obj/item/weapon/card/id/C = new idtype(H)
	C.registered_name = H.real_name
	C.rank = "Staff Sergeant"
	C.assignment = "Squad Leader"
	C.name = "[C.registered_name]'s ID Card ([C.assignment])"
	H.equip_to_slot_or_del(C, slot_wear_id)
	msg = "Вы командир отделения космодесантников с Тей Тенга. Вы крепкий орешек и просто матёрый засранец, ведь вам ежедневно приходиться командовать отнюдь не пай-мальчиками. В нынешней ситуации как вы как никогда нужны своим людям."
	to_chat(H,"[sanitize(msg)]")

	return TRUE

/datum/job/doom_trooper
	title = "Space Trooper"
	flag = DTROOPER
	department_flag = ENGSEC
	faction = "Outpost"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Commanding Officer and heads of staff"
	selection_color = "#bab86c"
	idtype = /obj/item/weapon/card/id/military/army
	access = list()
	minimal_player_age = 5
	minimal_player_ingame_minutes = 3800
	restricted_species = list(DIONA, TAJARAN, UNATHI, SKRELL, IPC, TYCHEON)

/datum/job/doom_trooper/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)	return FALSE
	var/msg
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/trooper(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/military/trooper/leader(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/military(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/military/trooper/leader(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/military/trooper/leader(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/praetor(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/praetor(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/small_firstaid_kit/combat(H), slot_l_store)
	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/assault_rifle/military/carbine(H), slot_r_hand)
//	H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/plasma_rifle(H), slot_r_hand)
	var/obj/item/weapon/card/id/C = new idtype(H)
	C.registered_name = H.real_name
	C.rank = "Lietenant"
	C.assignment = "Space Trooper"
	C.name = "[C.registered_name]'s ID Card ([C.assignment])"
	H.equip_to_slot_or_del(C, slot_wear_id)
	msg = "Вы космический пехотинец, элита Вооружённых Сил ООН. История умалчивает, за какие грехи вас сослали в эту жопу мира, но когда всё пошло наперекосяк вы, ваша силовая броня и оружие были готовы к этому."
	to_chat(H,"[sanitize(msg)]")

	return TRUE
