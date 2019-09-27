/obj/effect/landmark/corpse/pmc_private
	name = "Simon Golaski"
	corpseuniform = /obj/item/clothing/under/rank/outpost_sec/pmc
	corpsesuit = /obj/item/clothing/suit/armor/vest/outpost/pmc
	corpseshoes = /obj/item/clothing/shoes/jackboots/outpost/pmc
	corpsegloves = /obj/item/clothing/gloves/security/pmc
	corpseradio = /obj/item/device/radio/headset
	corpsebelt = /obj/item/weapon/storage/belt/security/outpost/pmc
//	corpsemask = /obj/item/clothing/mask/gas/coloured
	corpsehelmet = /obj/item/clothing/head/helmet/outpost/pmc
//	corpseback = /obj/item/weapon/storage/backpack
	corpseid = 0
	corpseidjob = "Operative"
	corpseidaccess = "Syndicate"

/obj/effect/landmark/corpse/archeologist
	name = "Archeologist"
	corpseid = 0
	corpseuniform = /obj/item/clothing/under/rank/scientist/explorer
	corpsesuit = /obj/item/clothing/suit/outpost_exosuit
	corpseshoes = /obj/item/clothing/shoes/outpost_exosuit_boots



/obj/effect/landmark/corpse/archeologist/julianbacker
	name = "Julian Backer"
	corpseid = 0
	hair_style = "Combed Hair"
	hair_color = "#71635A"
	corpsebelt = /obj/item/weapon/storage/belt/archaeology/quake_shells

/obj/item/weapon/storage/belt/archaeology/quake_shells/atom_init()
	. = ..()
	for(var/i in 1 to 6)
		var/obj/item/weapon/storage/pouch/small_generic/P = new /obj/item/weapon/storage/pouch/small_generic(src)
		for(var/h in 1 to P.max_storage_space)
			new /obj/item/ammo_casing/quake_shotgun(P)

/obj/effect/landmark/corpse/johnking
	name = "John King"
	hair_style = "Buzzcut"
	hair_color = "#B89778"
	corpseuniform = /obj/item/clothing/under/rank/engineer/outpost
	corpsehelmet = /obj/item/clothing/head/hardhat/yellow
	corpseshoes = /obj/item/clothing/shoes/workboots
	corpsemask = /obj/item/clothing/mask/gas/outpost

/obj/effect/landmark/corpse/johnking/createCorpse()
	..()
	var/obj/item/weapon/card/id/outpost/eng/W = new(human)
	W.name = "[human.real_name]'s ID Card"
	W.registered_name = human.real_name
	human.equip_to_slot_or_del(W, slot_wear_id)

/obj/effect/landmark/corpse/henrynelson
	name = "Henry Nelson"
	hair_style = "Dave"
	hair_color = "#090806"
	corpseuniform = /obj/item/clothing/under/rank/outpost_sec
	corpsehelmet = /obj/item/clothing/head/helmet/outpost
	corpseshoes = /obj/item/clothing/shoes/jackboots/outpost
	corpsesuit = /obj/item/clothing/suit/armor/vest/outpost
	corpsegloves = /obj/item/clothing/gloves/security/outpost
	corpsebelt = /obj/item/weapon/storage/belt/security/outpost

/obj/effect/landmark/corpse/henrynelson/createCorpse()
	..()
	var/obj/item/weapon/card/id/outpost/sec/W = new(human)
	W.name = "[human.real_name]'s ID Card"
	W.registered_name = human.real_name
	human.equip_to_slot_or_del(W, slot_wear_id)
