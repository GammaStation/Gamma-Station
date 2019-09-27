/datum/job/officer_junior
	title = "Junior Officer"
	flag = OFFJUN
	department_flag = ENGSEC
	faction = "Outpost"
	total_positions = 4
	spawn_positions = 1
	supervisors = "the Commanding Officer and heads of staff"
	selection_color = "#2f2f7f"
	idtype = /obj/item/weapon/card/id/military/command
	access = list()
	minimal_player_ingame_minutes = 180
	special_id_handling = TRUE
	restricted_species = list(DIONA, TAJARAN, UNATHI, SKRELL, IPC, TYCHEON)

/datum/job/officer_junior/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/msg
	if(!H)	return FALSE

	if(H.gender == MALE)

		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/trooper(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/military/fleet(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/military(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/kevlar_vest(H), slot_wear_suit)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/pilot(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/fingerless(H), slot_gloves)

		var/obj/item/weapon/card/id/C = new idtype(H)
		C.registered_name = H.real_name
		C.rank = "Ensign"
		C.assignment = "Pilot"
		C.name = "[C.registered_name]'s ID Card ([C.assignment])"
		H.equip_to_slot_or_del(C, slot_wear_id)
		msg = "Вы - пилот, младший офицер ответственный за пилотирование всех образцов космической техники на борту 'Аякса'. К сожалению, вся она сгинула вместе с корветом, так что придётся управляться с чем-то другим. Вам повезло и вы успели облачиться в полётное снаряжение."
		to_chat(H,"[sanitize(msg)]")

		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/messenger(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/mre(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/pistol/sec_pistol/spec(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/ammo_box/magazine/m9mm_pistol(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/ammo_box/magazine/m9mm_pistol(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/firstaid/small_firstaid_kit/space(H), slot_in_backpack)

	else

		var/obj/item/clothing/under/U = new /obj/item/clothing/under/military/service/female(H)
		var/obj/item/clothing/accessory/tie/blue/new_tie = new
		U.accessories += new_tie
		new_tie.on_attached(U, H, TRUE)
		H.equip_to_slot_or_del(U, slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/service_cap(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/weapon/lipstick/random(H), slot_l_store)
		H.equip_to_slot_or_del(new /obj/item/weapon/haircomb (H), slot_r_store)

		if(prob(40))
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/fleet_jacket(H), slot_wear_suit)

		var/obj/item/weapon/card/id/C = new idtype(H)
		C.registered_name = H.real_name
		C.rank = "Ensign"
		C.assignment = "Bridge Officer"
		C.name = "[C.registered_name]'s ID Card ([C.assignment])"
		H.equip_to_slot_or_del(C, slot_wear_id)

		msg = "Вы - дежурный офицер с мостика 'Аякса'. Поздравляем! Вам удалось выбраться с гибнующего корабля и сохранить укладку в целости! К несчастью, вся ваша работа заключалась в помощи старшим офицерам и мониторингу систем 'Аякса', и никогда не была грязной или тяжелой..что ж, теперь всё изменилось."
		to_chat(H,"[sanitize(msg)]")
	return TRUE

