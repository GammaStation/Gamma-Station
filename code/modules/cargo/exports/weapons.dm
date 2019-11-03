// Weapon exports. Stun batons, disablers, etc.

/datum/export/weapon
	include_subtypes = FALSE

/datum/export/weapon/baton
	cost = 100
	unit_name = "stun baton"
	export_types = list(/obj/item/weapon/melee/baton)

/datum/export/weapon/energy
	cost = 600
	include_subtypes = TRUE
	unit_name = "energy weapon"
	export_types = list(/obj/item/weapon/gun/energy)

/datum/export/weapon/energy/taser
	cost = 250
	unit_name = "taser"
	export_types = list(/obj/item/weapon/gun/energy/taser)

/datum/export/weapon/energy/laser
	cost = 850
	unit_name = "laser gun"
	export_types = list(/obj/item/weapon/gun/energy/laser)

/datum/export/weapon/energy/laser/practice
	cost = 150
	unit_name = "practice laser gun"
	export_types = list(/obj/item/weapon/gun/energy/laser/practice,/obj/item/weapon/gun/energy/laser/bluetag,/obj/item/weapon/gun/energy/laser/redtag)

/datum/export/weapon/energy/laser/selfcharging
	cost = 3500
	unit_name = "selfcharging laser gun"
	export_types = list(/obj/item/weapon/gun/energy/laser/selfcharging)

/datum/export/weapon/energy/laser/xray
	cost = 10000
	unit_name = "xray laser gun"
	export_types = list(/obj/item/weapon/gun/energy/xray)

/datum/export/weapon/energy/energy_gun
	cost = 1600
	unit_name = "energy gun"
	export_types = list(/obj/item/weapon/gun/energy/gun,
										/obj/item/weapon/gun/energy)

/datum/export/weapon/projectile
	cost = 400
	include_subtypes = TRUE
	unit_name = "kinetic weapon"
	export_types = list(/obj/item/weapon/gun/projectile)

/datum/export/weapon/projectile/c5
	cost = 700
	unit_name = "WT-550 automatic rifle"
	export_types = list(/obj/item/weapon/gun/projectile/automatic/c5)

/datum/export/weapon/projectile/shotgun
	cost = 650
	unit_name = "combat shotgun"
	export_types = list(/obj/item/weapon/gun/projectile/shotgun/combat)


/datum/export/weapon/flashbang
	cost = 15
	unit_name = "flashbang grenade"
	export_types = list(/obj/item/weapon/grenade/flashbang)

/datum/export/weapon/teargas
	cost = 15
	unit_name = "tear gas grenade"
	export_types = list(/obj/item/weapon/grenade/chem_grenade/teargas)


/datum/export/weapon/flash
	cost = 10
	unit_name = "handheld flash"
	export_types = list(/obj/item/device/flash)
	include_subtypes = TRUE

/datum/export/weapon/handcuffs
	cost = 3
	unit_name = "pair"
	message = "of handcuffs"
	export_types = list(/obj/item/weapon/handcuffs)
