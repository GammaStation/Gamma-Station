//EXOSUIT
/obj/item/clothing/suit/outpost_exosuit
	name = "exo suit"
	desc = "An sturdy suit for exploring harsh environments."
	icon = 'code/modules/outpost/outpost_clothing.dmi'
	icon_custom = 'code/modules/outpost/outpost_clothing.dmi'
	icon_state = "exo"
	item_state = "exo"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 20, bullet = 10, laser = 10, energy = 10, bomb = 10, bio = 50, rad = 25, telepathy = 0)
//	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/resonator, /obj/item/mining_scanner, /obj/item/t_scanner/adv_mining_scanner, /obj/item/gun/energy/kinetic_accelerator, /obj/item/pickaxe)

/obj/item/clothing/head/outpost_exosuit_hood
	name = "explorer hood"
	desc = "An armoured hood for exploring harsh environments."
	icon = 'code/modules/outpost/outpost_clothing.dmi'
	icon_custom = 'code/modules/outpost/outpost_clothing.dmi'
	icon_state = "exohelm"
	body_parts_covered = HEAD
	flags_inv = BLOCKHAIR|HIDEFACE|HIDEEARS
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

	armor = list(melee = 20, bullet = 10, laser = 10, energy = 10, bomb = 10, bio = 50, rad = 25, telepathy = 0)

/obj/item/clothing/shoes/outpost_exosuit_boots
	name = "mining boots"
	desc = "Steel-toed mining boots for mining in hazardous environments. Very good at keeping toes uncrushed."
	icon = 'code/modules/outpost/outpost_clothing.dmi'
	icon_custom = 'code/modules/outpost/outpost_clothing.dmi'
	icon_state = "exoboots"
	item_state = "exoboots"
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	permeability_coefficient = 0.15
	armor = list(melee = 20, bullet = 10, laser = 10, energy = 10, bomb = 10, bio = 50, rad = 25, telepathy = 0)

/obj/item/clothing/under/rank/scientist/explorer
	desc = "A dark uniform for operating in hazardous environments."
	name = "archeologist's jumpsuit"
	icon = 'code/modules/outpost/outpost_clothing.dmi'
	icon_custom = 'code/modules/outpost/outpost_clothing.dmi'
	icon_state = "exop"
	item_state = "exop"
	item_color = "exop"

/obj/item/clothing/under/rank/engineer/outpost
	desc = "It's an orange high visibility jumpsuit worn by engineers. It has minor radiation shielding."
	name = "engineer's jumpsuit"
	icon = 'code/modules/outpost/outpost_clothing.dmi'
	icon_custom = 'code/modules/outpost/outpost_clothing.dmi'
	icon_state = "engine"
	item_color = "engine"

	flags = 0

/obj/item/clothing/mask/gas/outpost
	name = "gas mask"
	icon_state = "gas"
	item_state = "gas"
	icon = 'code/modules/outpost/outpost_clothing.dmi'
	icon_custom = 'code/modules/outpost/outpost_clothing.dmi'

//SECURITY
/obj/item/clothing/under/rank/outpost_sec
	name = "security uniform"
	desc = "It's made of a slightly sturdier material, to allow for robust protection."
	icon = 'code/modules/outpost/outpost_clothing.dmi'
	icon_custom = 'code/modules/outpost/outpost_clothing.dmi'
	icon_state = "sec"
	item_state = "sec"
	item_color = "sec"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0, telepathy = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	siemens_coefficient = 0.9

/obj/item/clothing/shoes/jackboots/outpost
	name = "security shoes"
	desc = "Security shoes for style."
	icon = 'code/modules/outpost/outpost_clothing.dmi'
	icon_custom = 'code/modules/outpost/outpost_clothing.dmi'
	icon_state = "secshoes"
	item_state = "secshoes"

/obj/item/clothing/head/helmet/outpost
	name = "helmet"
	desc = "Standard Security gear. Protects the head from impacts."
	icon = 'code/modules/outpost/outpost_clothing.dmi'
	icon_custom = 'code/modules/outpost/outpost_clothing.dmi'
	icon_state = "sechelmet"
	item_state = "sechelmet"
	armor = list(melee = 35, bullet = 30, laser = 30, energy = 10, bomb = 25, bio = 0, rad = 0, telepathy = 0)

/obj/item/clothing/suit/armor/vest/outpost
	name = "armor"
	desc = "A slim Type I armored vest that provides decent protection against most types of damage."
	icon = 'code/modules/outpost/outpost_clothing.dmi'
	icon_custom = 'code/modules/outpost/outpost_clothing.dmi'
	icon_state = "secarmor"
	item_state = "secarmor"
	armor = list(melee = 30, bullet = 30, laser = 30, energy = 10, bomb = 25, bio = 0, rad = 0, telepathy = 10)

/obj/item/weapon/storage/belt/security/outpost
	icon = 'code/modules/outpost/outpost_clothing.dmi'
	icon_custom = 'code/modules/outpost/outpost_clothing.dmi'
	icon_state = "secbelt"
	item_state = "secbelt"

/obj/item/weapon/storage/backpack/sec_outpost
	name = "security backpack"
	icon = 'code/modules/outpost/outpost_clothing.dmi'
	icon_custom = 'code/modules/outpost/outpost_clothing.dmi'
	icon_state = "secpack"
	item_state = "secpack"

/obj/item/clothing/gloves/security/outpost
	icon = 'code/modules/outpost/outpost_clothing.dmi'
	icon_custom = 'code/modules/outpost/outpost_clothing.dmi'
	icon_state = "secgloves"
	item_state = "secgloves"

/obj/item/clothing/under/rank/medical/outpost
	desc = "It's made of a special fiber that provides minor protection against biohazards."
	name = "medical doctor's jumpsuit"
	icon = 'code/modules/outpost/outpost_clothing.dmi'
	icon_custom = 'code/modules/outpost/outpost_clothing.dmi'
	icon_state = "med"
	item_state = "med"
	item_color = "med"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0, telepathy = 0)
