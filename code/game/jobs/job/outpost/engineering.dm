/*
/datum/job/engineer_junior
	title = "Engineer Trainee"
	flag = ENGJUN
	department_flag = ENGSEC
	faction = "Outpost"
	total_positions = 3
	spawn_positions = 1
	supervisors = "the Chief Engineer and Engineering Personnel"
	selection_color = "#FF7F00"
	idtype = /obj/item/weapon/card/id/military/engineer
//	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction)
//	alt_titles = list("Maintenance Technician","Engine Technician","Electrician")
	minimal_player_age = 0
	minimal_player_ingame_minutes = 0

/datum/job/engineer_junior/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)	return FALSE
	var/msg
	H.equip_to_slot_or_del(new /obj/item/clothing/under/military/utility/eng(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/military(H), slot_shoes)

	if(prob(25))
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/military/eng(H), slot_gloves)
	if(prob(50))
		H.equip_to_slot_or_del(new /obj/item/clothing/head/soft/military(H), slot_head)

	var/obj/item/weapon/card/id/C = new idtype(H)
	C.registered_name = H.real_name
	C.rank = "Crewman Apprentice"
	C.assignment = "Engineer Trainee"
	C.name = "[C.registered_name]'s ID Card ([C.assignment])"
	H.equip_to_slot_or_del(C, slot_wear_id)
	msg = "Вы - инженер-стажёр, рядовой член экипажа 'Аякса', назначенный сразу после прохождения инженерной учебки. Ваши обязанности на период практического обучения на корабле сводились к помощи инженерам и мелкому техническому обслуживанию, но к тому повороту вас подготовить никто не мог. "
	to_chat(H,"[sanitize(msg)]")

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_eng(H), slot_l_ear)

	return TRUE
*/
/datum/job/ship_engineer
	title = "Ship Engineer"
	flag = ENGINEER
	department_flag = ENGSEC
	faction = "Outpost"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief engineer"
	selection_color = "#fff5cc"
	idtype = /obj/item/weapon/card/id/military/engineer
//	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction)
//	alt_titles = list("Maintenance Technician","Engine Technician","Electrician")
	minimal_player_age = 3
	minimal_player_ingame_minutes = 540
	restricted_species = list(DIONA, TAJARAN, UNATHI, SKRELL, IPC, TYCHEON)

/datum/job/ship_engineer/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/military(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/soft/military/fleet(H), slot_head)

	var/obj/item/clothing/under/U = new /obj/item/clothing/under/military/fleet/usual/eng(H)
	var/obj/item/clothing/accessory/storage/drop_pouches/brown/new_tie = new
	U.accessories += new_tie
	new_tie.on_attached(U, H, TRUE)
	H.equip_to_slot_or_del(U, slot_w_uniform)

	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/military/eng(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/pouch/engineering_tools(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/pouch/engineering_supply(H), slot_r_store)
//	H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/(H), slot_belt)

/*
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/workboots(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(H), slot_belt)
	if(prob(75))
		H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/yellow(H), slot_head)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat/yellow/visor(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/device/t_scanner(H), slot_r_store)
	H.equip_to_slot_or_del(new /obj/item/device/pda/engineering(H), slot_l_store)
	if(visualsOnly)
		return

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_eng(H), slot_l_ear)
*/
	return TRUE