// Armor, gloves, space suits - it all goes here

/datum/export/gear

/datum/export/gear/energy_shield
	cost = 10000
	unit_name = "portable energy shield"
	export_types = list(/obj/item/clothing/belt/energy_shield)


//Clothing
/datum/export/gear/clothing
	cost = 20
	include_subtypes = TRUE

/datum/export/gear/clothing/gloves
	include_subtypes = TRUE
	unit_name = "gloves"
	export_types = list(/obj/item/clothing/gloves)

/datum/export/gear/clothing/head
	include_subtypes = TRUE
	unit_name = "headwear"
	export_types = list(/obj/item/clothing/head)

/datum/export/gear/clothing/under
	include_subtypes = TRUE
	unit_name = "underwear"
	export_types = list(/obj/item/clothing/under)

/datum/export/gear/clothing/suit
	include_subtypes = TRUE
	unit_name = "suit"
	export_types = list(/obj/item/clothing/suit)

// Security gear
/datum/export/gear/clothing/head/sec_helmet
	cost = 100
	include_subtypes = FALSE
	unit_name = "helmet"
	export_types = list(/obj/item/clothing/head/helmet/band)

/datum/export/gear/clothing/suit/sec_armor
	cost = 100
	include_subtypes = FALSE
	unit_name = "armor vest"
	export_types = list(/obj/item/clothing/suit/armor/vest,
									/obj/item/clothing/suit/storage/flak)


/datum/export/gear/clothing/head/riot_helmet
	cost = 250
	unit_name = "riot helmet"
	export_types = list(/obj/item/clothing/head/helmet/band/riot)

/datum/export/gear/clothing/suit/riot_armor
	cost = 250
	unit_name = "riot armor suit"
	export_types = list(/obj/item/clothing/suit/armor/riot)

/datum/export/gear/clothing/head/bulletproof_helmet
	cost = 250
	unit_name = "bulletproof helmet"
	export_types = list(/obj/item/clothing/head/helmet/bulletproof)

/datum/export/gear/clothing/suit/bulletproof_armor
	cost = 250
	unit_name = "bulletproof armor vest"
	export_types = list(/obj/item/clothing/suit/storage/flak/bulletproof)

/datum/export/gear/clothing/head/reflector_helmet
	cost = 650
	unit_name = "reflector helmet"
	export_types = list(/obj/item/clothing/head/helmet/laserproof)

/datum/export/gear/clothing/suit/reflector_armor
	cost = 650
	unit_name = "reflector armor vest"
	export_types = list(/obj/item/clothing/suit/armor/laserproof)


/datum/export/gear/riot_shield
	cost = 400
	unit_name = "riot shield"
	export_types = list(/obj/item/weapon/shield/riot)


// Masks
/datum/export/gear/mask/breath
	cost = 2
	unit_name = "breath mask"
	export_types = list(/obj/item/clothing/mask/breath)

/datum/export/gear/mask/gas
	cost = 10
	unit_name = "gas mask"
	export_types = list(/obj/item/clothing/mask/gas/coloured)
	include_subtypes = FALSE



// EVA gear
/datum/export/gear/clothing/head/space
	include_subtypes = TRUE

/datum/export/gear/clothing/suit/space
	include_subtypes = TRUE

/datum/export/gear/clothing/head/space/helmet
	cost = 500
	unit_name = "space helmet"
	export_types = list(/obj/item/clothing/head/helmet/space)

/datum/export/gear/clothing/suit/space/suit
	cost = 600
	unit_name = "space suit"
	export_types = list(/obj/item/clothing/suit/space)

/datum/export/gear/clothing/head/space/voidhelmet
	cost = 550
	unit_name = "void helmet"
	export_types = list(/obj/item/clothing/head/helmet/space/nasavoid)

/datum/export/gear/clothing/suit/space/voidsuit
	cost = 650
	unit_name = "void suit"
	export_types = list(/obj/item/clothing/suit/space/nasavoid)

/datum/export/gear/clothing/head/space/helmet/rig
	cost = 1500
	unit_name = "rig helmet"
	export_types = list(/obj/item/clothing/head/helmet/space/rig)

/datum/export/gear/clothing/suit/space/suit/rig
	cost = 3000
	unit_name = "rig suit"
	export_types = list(/obj/item/clothing/suit/space/rig)

/datum/export/gear/clothing/head/space/syndiehelmet
	cost = 1000
	unit_name = "Syndicate space helmet"
	export_types = list(/obj/item/clothing/head/helmet/space/syndicate)
	include_subtypes = TRUE

/datum/export/gear/clothing/suit/space/syndiesuit
	cost = 1500
	unit_name = "Syndicate space suit"
	export_types = list(/obj/item/clothing/suit/space/syndicate)
	include_subtypes = TRUE


// Radsuits
/datum/export/gear/clothing/head/radhelmet
	cost = 50
	unit_name = "radsuit hood"
	export_types = list(/obj/item/clothing/head/radiation)

/datum/export/gear/clothing/suit/radsuit
	cost = 100
	unit_name = "radsuit"
	export_types = list(/obj/item/clothing/suit/radiation)

// Biosuits
/datum/export/gear/clothing/head/biohood
	cost = 50
	unit_name = "biosuit hood"
	export_types = list(/obj/item/clothing/head/bio_hood)

/datum/export/gear/clothing/suit/biosuit
	cost = 100
	unit_name = "biosuit"
	export_types = list(/obj/item/clothing/suit/bio_suit)

// Bombsuits
/datum/export/gear/clothing/head/bombhelmet
	cost = 100
	unit_name = "bomb suit hood"
	export_types = list(/obj/item/clothing/head/bomb_hood)

/datum/export/gear/clothing/suit/bombsuit
	cost = 300
	unit_name = "bomb suit"
	export_types = list(/obj/item/clothing/suit/bomb_suit)

//--------------------------------------------
//---------------GLASSES----------------------
//--------------------------------------------

/datum/export/gear/glasses
	cost = 150
	include_subtypes = TRUE
	unit_name = "glasses"
	export_types = list(/obj/item/clothing/glasses)

/datum/export/gear/glasses/hud
	cost = 200
	include_subtypes = TRUE
	unit_name = "hud glasses"
	export_types = list(/obj/item/clothing/glasses/hud)

/datum/export/gear/glasses/meson
	cost = 350
	unit_name = "meson glasses"
	export_types = list(/obj/item/clothing/glasses/meson)

/datum/export/gear/glasses/night
	cost = 2700
	unit_name = "night vision glasses"
	export_types = list(/obj/item/clothing/glasses/night)

/datum/export/gear/glasses/thermal
	cost = 6000
	include_subtypes = TRUE
	unit_name = "thermal vision glasses"
	export_types = list(/obj/item/clothing/glasses/thermal)

/datum/export/gear/glasses/welding
	cost = 200
	include_subtypes = TRUE
	unit_name = "welding glasses"
	export_types = list(/obj/item/clothing/glasses/welding)


//--------------------------------------------
//----------------SHOES-----------------------
//--------------------------------------------

//Clothing

/datum/export/gear/clothing/shoes
	cost = 20
	include_subtypes = TRUE
	unit_name = "shoes"
	export_types = list(/obj/item/clothing/shoes)

/datum/export/gear/clothing/shoes/combat
	cost = 1000
	unit_name = "combat boots"
	export_types = list(/obj/item/clothing/shoes/combat,
									/obj/item/clothing/shoes/swat)

/datum/export/gear/clothing/shoes/jackboots
	cost = 200
	unit_name = "jackboots"
	export_types = list(/obj/item/clothing/shoes/jackboots)

/datum/export/gear/clothing/shoes/magboots
	cost = 3000
	unit_name = "magboots"
	export_types = list(/obj/item/clothing/shoes/magboots)

/datum/export/gear/clothing/shoes/rainbow
	cost = 150
	unit_name = "rainbow shoes"
	export_types = list(/obj/item/clothing/shoes/rainbow)
