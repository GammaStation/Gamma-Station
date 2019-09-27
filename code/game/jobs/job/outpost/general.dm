/datum/job/crewman
	title = "Crewman"
	flag = CREWMAN
	department_flag = CIVILIAN
	faction = "Outpost"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Executive Officer and UN personnel according to their rank"
	selection_color = "#dddddd"
	idtype = /obj/item/weapon/card/id/military/general
	access = list()
	minimal_player_age = 0
	minimal_player_ingame_minutes = 0
	restricted_species = list(DIONA, TAJARAN, UNATHI, SKRELL, IPC, TYCHEON)

/datum/job/crewman/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)	return FALSE
	var/msg
	H.equip_to_slot_or_del(new /obj/item/clothing/under/military/utility(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/military(H), slot_shoes)

	if(prob(25))
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/military(H), slot_gloves)
	if(prob(60))
		H.equip_to_slot_or_del(new /obj/item/clothing/head/soft/military(H), slot_head)

	var/obj/item/weapon/card/id/C = new idtype(H)
	C.registered_name = H.real_name
	C.rank = "Crewman Apprentice"
	C.assignment = "Crewman"
	C.name = "[C.registered_name]'s ID Card ([C.assignment])"
	H.equip_to_slot_or_del(C, slot_wear_id)
	msg = "Вы - рядовой член экипажа 'Аякса'. Для сослуживцев, командиров и для вас в частности, ваши обязанности представляют собой загадку, хотя формально вы занимаетесь управлением и обслуживанием боевых систем и вспомогательными работами."
	to_chat(H,"[sanitize(msg)]")

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_eng(H), slot_l_ear)

	return TRUE