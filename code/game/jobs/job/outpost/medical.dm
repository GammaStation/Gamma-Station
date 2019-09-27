/datum/job/corpsman
	title = "Corpsman"
	flag = PARAMEDIC
	department_flag = MEDSCI
	faction = "Outpost"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the chief medical officer"
	selection_color = "#a3cde1"
	idtype = /obj/item/weapon/card/id/military/medic
	access = list()
	minimal_player_ingame_minutes = 960
	special_id_handling = TRUE
	restricted_species = list(DIONA, TAJARAN, UNATHI, SKRELL, IPC, TYCHEON)

/datum/job/corpsman/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)	return FALSE

	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/military(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/soft/military/fleet(H), slot_head)

	var/obj/item/clothing/under/U = new /obj/item/clothing/under/military/fleet/usual/eng(H)
	var/obj/item/clothing/accessory/storage/white_vest/new_tie = new
	U.accessories += new_tie
	new_tie.on_attached(U, H, TRUE)
	H.equip_to_slot_or_del(U, slot_w_uniform)

	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/fleetpack(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/latex/nitrile(H), slot_in_backpack)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/medicines(H), slot_in_backpack)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/pill_bottle/stabyzol(H), slot_in_backpack)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/pill_bottle/metatrombine(H), slot_in_backpack)

//	H.equip_to_slot_or_del(new 	/obj/item/weapon/gun/projectile/automatic/c20r(H), slot_in_backpack)
//	H.equip_to_slot_or_del(new 	/obj/item/ammo_box/magazine/m12mm(H), slot_in_backpack)
//	H.equip_to_slot_or_del(new 	/obj/item/ammo_box/magazine/m12mm(H), slot_in_backpack)

	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(H), slot_glasses)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/military(H), slot_l_hand)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/military/med(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/pouch/medical_supply(H), slot_l_store)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/pouch/medical_supply(H), slot_r_store)

//	H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/ertarmor_med/non_ert(H), slot_wear_suit)

	var/msg
	var/obj/item/weapon/card/id/C = new idtype(H)
	C.registered_name = H.real_name
	C.rank = "Ensign"
	C.assignment = "Corpsman"
	C.name = "[C.registered_name]'s ID Card ([C.assignment])"
	H.equip_to_slot_or_del(C, slot_wear_id)
	msg = "¬ы - санитар на борту 'ј€кса'. ∆изни ваших товарищей и сохранность запасов медицинского спирта наход€тс€ именно в ваших руках, и если спирт уже не спасти, то за жизни вы ещЄ можете поборотьс€."
	to_chat(H,"[sanitize(msg)]")


/*
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/fr_jacket(H), slot_wear_suit)

/obj/item/clothing/glasses/hud/health
	if(visualsOnly)
		return

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_med(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/device/pda/medical(H), slot_belt)
	switch(H.backbag)
		if(1) H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		if(2) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/medic(H), slot_back)
		if(3) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel/med(H), slot_back)
		if(4) H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
*/
	return TRUE

