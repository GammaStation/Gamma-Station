//HEADGEAR
/obj/item/clothing/head/soft/military
	name = "utility cap"
	desc = "It's a ballcap in UNN colors."
	icon = 'code/modules/warfare/clothing.dmi'
	icon_custom = 'code/modules/warfare/clothing.dmi'
	icon_state = "cap-utilsoft"
	item_color = "cap-util"

/obj/item/clothing/head/soft/military/fleet
	name = "fleet cap"
	desc = "It's a navy blue field cap with the UN Fleet crest in a silver colour."
	icon_state = "cap-fleetsoft"
	item_color = "cap-fleet"

/obj/item/clothing/head/service_cap
	name = "fleet service wheel cover"
	desc = "A white service uniform cover. This one has an UN Fleet crest."
	icon = 'code/modules/warfare/clothing.dmi'
	icon_custom = 'code/modules/warfare/clothing.dmi'
	icon_state = "whitepeakcap"
	body_parts_covered = 0

/obj/item/clothing/head/helmet/trooper
	name = "trooper helmet"
	desc = "Spectrum alloy helmet. Lightweight and ready for action."
	icon = 'code/modules/warfare/gear.dmi'
	icon_custom = 'code/modules/warfare/gear.dmi'
	icon_state = "comhelm"
	item_state = "comhelm"
	flags = HEADCOVERSEYES
	armor = list(melee = 62, bullet = 60, laser = 50,energy = 35, bomb = 10, bio = 2, rad = 0, telepathy = 10)
	flags_inv = HIDEEARS
	siemens_coefficient = 0.7

/obj/item/clothing/head/helmet/trooper/leader
	name = "leader helmet"
	icon_state = "leaderhelm"
	item_state = "leaderhelm"
	bypass_icon = "bypass/clothing/gear.dmi"

//UNIFORM
/obj/item/clothing/under/military
	name = "master military uniform"
	desc = "You shouldn't be seeing this."
	icon = 'code/modules/warfare/clothing.dmi'
	icon_custom = 'code/modules/warfare/clothing.dmi'
	armor = list(melee = 5, bullet = 0, laser = 5, energy = 5, bomb = 0, bio = 5, rad = 5)
	siemens_coefficient = 0.8

/obj/item/clothing/under/military/verb/rollup()
	set name = "Roll uniform sleeves"
	set category = "Object"
	set src in usr
	item_color = item_color == "[icon_state]" ? "[icon_state]_rolled" : "[icon_state]"
	if (ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.update_inv_w_uniform()

/obj/item/clothing/under/military/trooper
	name = "combat uniform"
	desc = "A standard combat jumpsuit for space troopers"
	icon_state = "combat"
	item_state = "combat"
	item_color = "combat"
	armor = list(melee = 10, bullet = 5, laser = 5,energy = 0, bomb = 0, bio = 0, rad = 0, telepathy = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/military/trooper/leader
	name = "combat uniform"
	desc = "A tropical shaded version of combat jumpsuit."
	icon_state = "leader"
	item_state = "combat"
	item_color = "leader"


/obj/item/clothing/under/military/fleet
	name = "fleet fatigues"
	desc = "A combat uniform of the UN Fleet, for when coveralls are impractical."
	icon_state = "fleet_combat"
	item_state = "fleet_combat"
	item_color = "fleet_combat"

/obj/item/clothing/under/military/fleet/usual
	name = "fleet uniform"
	desc = "A common day uniform of the UN Fleet, for active duty on board of ship."
	icon_state = "fleet"
	item_color = "fleet"

/obj/item/clothing/under/military/fleet/usual/med
	name = "medical fleet uniform"
	desc = "A common day uniform of the UN Fleet, for active duty on board of ship. This one with blue stripes"
	icon_state = "fleet-med"
	item_color = "fleet-med"

/obj/item/clothing/under/military/fleet/usual/eng
	name = "engineering fleet uniform"
	desc = "A common day uniform of the UN Fleet, for active duty on board of ship. This one with orange stripes"
	icon_state = "fleet-eng"
	item_color = "fleet-eng"

/obj/item/clothing/under/military/service
	name = "fleet service uniform"
	desc = "The service uniform of the UN Fleet, made from immaculate white fabric."
	icon_state = "service"
	item_state = "service"
	item_color = "service"

/obj/item/clothing/under/military/service/female
	name = "female fleet service uniform"
	desc = "A feminine version service uniform of the UN Fleet, made from immaculate white fabric."
	icon_state = "service-fem"
	item_color = "service-fem"

/obj/item/clothing/under/military/utility
	name = "fleet utility uniform"
	desc = "A comfortable turtleneck and black utility trousers."
	icon_state = "utility"
	item_state = "utility"
	item_color = "utility"

/obj/item/clothing/under/military/utility/eng
	name = "engineering utility uniform"
	desc = "A comfortable turtleneck and black utility trousers. This one with orange stripes"
	icon_state = "utility-eng"
	item_color = "utility-eng"

/obj/item/clothing/under/military/utility/med
	name = "medical utility uniform"
	desc = "A comfortable turtleneck and black utility trousers. This one with blue stripes"
	icon_state = "utility-med"
	item_color = "utility-med"

//SUITS
/obj/item/clothing/suit/storage/fleet_jacket
	name = "fleet service jacket"
	desc = "A navy blue UN Fleet service jacket."
	icon = 'code/modules/warfare/clothing.dmi'
	icon_custom = 'code/modules/warfare/clothing.dmi'
	icon_state = "service-jacket"
	item_state = "service-jacket"
	allowed = list(/obj/item/weapon/tank/emergency_oxygen,/obj/item/device/flashlight,/obj/item/weapon/pen,/obj/item/clothing/head/soft,/obj/item/clothing/head/beret,/obj/item/clothing/head/service_cap)

//HANDSGEAR
/obj/item/clothing/gloves/military
	desc = "These work gloves are thick and fire-resistant."
	name = "work gloves"
	icon = 'code/modules/warfare/clothing.dmi'
	icon_custom = 'code/modules/warfare/clothing.dmi'
	icon_state = "gloves-util"
	item_state = "gloves-util"
	siemens_coefficient = 0.50
	permeability_coefficient = 0.05
	flags = THICKMATERIAL

/obj/item/clothing/gloves/military/eng
	name = "engineering duty gloves"
	desc = "These black duty gloves are made from durable synthetic materials, and have a lovely orange accent color."
	icon_state = "gloves-eng"
	item_state = "gloves-eng"

/obj/item/clothing/gloves/military/med
	name = "medical duty gloves"
	desc = "These black duty gloves are made from durable synthetic materials, and have a blue accent color."
	icon_state = "gloves-med"
	item_state = "gloves-med"

/obj/item/clothing/gloves/military/trooper
	desc = "These gloves are made from durable synthetic materials."
	name = "military gloves"
	icon_state = "gloves-combat"
	item_state = "gloves-combat"

/obj/item/clothing/gloves/military/trooper/leader
	siemens_coefficient = 0.6
	permeability_coefficient = 0.05
	cold_protection = ARMS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = ARMS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	icon_state = "gloves-leader"
	item_state = "gloves-leader"
	bypass_icon = "bypass/clothing/gear.dmi"
//ARMOR
/obj/item/clothing/suit/armor/trooper
	name = "tactical armor"
	desc = "A suit of armor most often used by Special Weapons and Tactics squads. Includes padded vest with pockets along with shoulder and kneeguards."
	icon = 'code/modules/warfare/gear.dmi'
	icon_custom = 'code/modules/warfare/gear.dmi'
	icon_state = "comarmor"
	item_state = "comarmor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	slowdown = 0.8
	armor = list(melee = 60, bullet = 65, laser = 50, energy = 60, bomb = 40, bio = 0, rad = 0, telepathy = 10)

/obj/item/clothing/suit/armor/trooper/scout
	name = "scout armor"
	desc = "A special lightweight set of armor for scouts."
	icon = 'code/modules/warfare/gear.dmi'
	icon_custom = 'code/modules/warfare/gear.dmi'
	icon_state = "scout_armor"
	item_state = "scout_armor"
	armor = list(melee = 55, bullet = 45, laser = 40, energy = 30, bomb = 30, bio = 0, rad = 15, telepathy = 0)

/obj/item/clothing/suit/armor/trooper/leader
	name = "leader armor"
	desc = "In fact this armor designed for inhabitable planets, but Tei Tenga sergeants stripped it and used for themselfs."
	bypass_icon = "bypass/clothing/gear.dmi"
	icon = 'code/modules/warfare/gear.dmi'
	icon_custom = 'code/modules/warfare/gear.dmi'

	icon_state = "leader"
	item_state = "leader"
	armor = list(melee = 70, bullet = 60, laser = 50, energy = 50, bomb = 40, bio = 0, rad = 30, telepathy = 10)

/obj/item/clothing/suit/armor/ertarmor_med/non_ert
	name = "combat body armor"
	armor = list(melee = 40, bullet = 40, laser = 40, energy = 20, bomb = 50, bio = 20, rad = 50, telepathy = 10)

//Security
/obj/item/clothing/head/helmet/space/praetor
	name = "Praetor hardsuit helmet"
	desc = "A modern combat helmet designed for in a various hazardous environments including space."
	bypass_icon = "bypass/clothing/gear.dmi"
	icon = 'code/modules/warfare/gear.dmi'
	icon_custom = 'code/modules/warfare/gear.dmi'
	icon_state = "praetor-helmet"
//	item_state = "sec_helm"
	item_color = "praetor-helmet"
	armor = list(melee = 75, bullet = 70, laser = 70, energy = 70, bomb = 70, bio = 100, rad = 20, telepathy = 15)

/obj/item/clothing/suit/space/praetor
	name = "Praetor hardsuit"
	desc = "A modern combat powered hardsuit for elite UN space troopers. This is apex one amongs the hardsuits."
	bypass_icon = "bypass/clothing/gear.dmi"
	icon = 'code/modules/warfare/gear.dmi'
	icon_custom = 'code/modules/warfare/gear.dmi'
	icon_state = "praetor-suit"
	item_color = "praetor-suit"
//	item_state = "sec_hardsuit"
	armor = list(melee = 75, bullet = 70, laser = 70, energy = 70, bomb = 70, bio = 100, rad = 20, telepathy = 20)
	breach_threshold = 32
	slowdown = 0.9
	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton)


//FOOTGEAR
/obj/item/clothing/shoes/military
	name = "duty boots"
	desc = "A pair of steel-toed synthleather boots with a mirror shine."
	icon_state = "jackboots"
	item_state = "jackboots"
	siemens_coefficient = 0.7
	clipped_status = CLIPPABLE
	armor = list(melee = 20, bullet = 10, laser = 10, energy = 10, bomb = 10, bio = 50, rad = 25, telepathy = 0)

/obj/item/clothing/shoes/military/trooper
	name = "combat jackboots"
	desc = "Strong and durable."
	icon = 'code/modules/warfare/clothing.dmi'
	icon_custom = 'code/modules/warfare/clothing.dmi'
	icon_state = "comboots"
	item_state = "comboots"
	flags = NOSLIP
	siemens_coefficient = 0.6
	clipped_status = CLIPPABLE

/obj/item/clothing/shoes/military/trooper/leader
	name = "armored jackboots"
	desc = "Strong and durable. With heat insulation"
	bypass_icon = "bypass/clothing/gear.dmi"
	icon_state = "ledboots"
	item_state = "ledboots"
	cold_protection = LEGS
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = LEGS
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

//STORAGE
/obj/item/weapon/storage/backpack/rucksack
	name = "green rucksack"
	desc = "A sturdy military-grade backpack with low-profile straps. Designed to work well with armor."
	icon = 'code/modules/warfare/storage.dmi'
	icon_custom = 'code/modules/warfare/storage.dmi'
	icon_state = "rucksack"
	item_color = "rucksack"

/obj/item/weapon/storage/backpack/messenger
	name = "messenger bag"
	desc = "A sturdy backpack worn over one shoulder."
	icon = 'code/modules/warfare/storage.dmi'
	icon_custom = 'code/modules/warfare/storage.dmi'
	icon_state = "courier"
	item_color = "courier"
	max_storage_space = DEFAULT_LARGEBOX_STORAGE

/obj/item/weapon/storage/backpack/fleetpack
	name = "emergency response team backpack"
	icon = 'code/modules/warfare/storage.dmi'
	icon_custom = 'code/modules/warfare/storage.dmi'
	desc = "A spacious backpack with lots of pockets issued for UN Navy."
	icon_state = "fleetpack"
	item_state = "rucksack"

/obj/item/weapon/storage/firstaid/military
	name = "combat first-aid kit"
	desc = "It's an standard large combat medical kit for use directly on battlefield."
	icon = 'code/modules/warfare/storage.dmi'
	icon_custom = 'code/modules/warfare/storage.dmi'
	icon_state = "combat_medkit"
	throw_speed = 2
	throw_range = 4
	w_class = ITEM_SIZE_LARGE
	max_storage_space = DEFAULT_BACKPACK_STORAGE

/obj/item/weapon/storage/firstaid/military/atom_init()
	. = ..()
	if (empty)
		return
	new /obj/item/device/handheld_bodyscanner(src)
	new /obj/item/stack/medical/splint(src)
	for (var/i in 1 to 3)
		new /obj/item/stack/medical/advanced/bruise_pack(src)
	for (var/i in 1 to 3)
		new /obj/item/stack/medical/advanced/ointment(src)
	for (var/i in 1 to 3)
		new /obj/item/weapon/storage/firstaid/small_firstaid_kit/combat(src)
	for (var/i in 1 to 3)
		new /obj/item/weapon/storage/firstaid/small_firstaid_kit/advanced(src)

/obj/item/weapon/storage/box/medicines
	name = "a medicine box"
	desc = "A box full of pill bottles."

/obj/item/weapon/storage/box/medicines/atom_init()
	. = ..()
	new /obj/item/weapon/storage/pill_bottle/bicaridine(src)
	new /obj/item/weapon/storage/pill_bottle/bicaridine(src)
	new /obj/item/weapon/storage/pill_bottle/dermaline(src)
	new /obj/item/weapon/storage/pill_bottle/dermaline(src)
	new /obj/item/weapon/storage/pill_bottle/dexalin(src)
	new /obj/item/weapon/storage/pill_bottle/tramadol(src)
	new /obj/item/weapon/storage/pill_bottle/spaceacillin(src)



/obj/item/weapon/reagent_containers/pill/spaceacillin
	name = "spaceacillin pill"
	desc = "An all-purpose antiviral agent."
	icon_state = "pill18"

/obj/item/weapon/reagent_containers/pill/spaceacillin/atom_init()
	. = ..()
	reagents.add_reagent("spaceacillin", 20)

/obj/item/weapon/storage/pill_bottle/spaceacillin
	name = "bottle of dexalin pills"
	desc = "An all-purpose antiviral agent.."

/obj/item/weapon/storage/pill_bottle/spaceacillin/atom_init()
	. = ..()
	for (var/i in 1 to 7)
		new /obj/item/weapon/reagent_containers/pill/spaceacillin(src)

//

/obj/item/weapon/storage/pill_bottle/dexalin
	name = "bottle of dexalin pills"
	desc = "Contains pills used to treat oxygen deprivation."

/obj/item/weapon/storage/pill_bottle/dexalin/atom_init()
	. = ..()
	for (var/i in 1 to 7)
		new /obj/item/weapon/reagent_containers/pill/dexalin(src)
	/*
/obj/item/weapon/storage/box/medicines2
	name = "a medicine box"
	desc = "A box full of pill bottles."

/obj/item/weapon/storage/box/medicines/atom_init()
	. = ..()
	new /obj/item/weapon/storage/pill_bottle/bicaridine(src)
	new /obj/item/weapon/storage/pill_bottle/bicaridine(src)
	new /obj/item/weapon/storage/pill_bottle/dermaline(src)
	new /obj/item/weapon/storage/pill_bottle/dermaline(src)
	new /obj/item/weapon/storage/pill_bottle/dexalin(src)
	new /obj/item/weapon/storage/pill_bottle/tramadol(src)
	new /obj/item/weapon/reagent_containers/pill/spaceacillin(src)
	*/
/obj/item/weapon/reagent_containers/pill/metatrombine
	name = "metatrombine pill"
	desc = "Metatrombine is a drug that induces high plateletes production. Can be used to temporarily coagulate blood in internal bleedings."
	icon_state = "pill18"

/obj/item/weapon/reagent_containers/pill/metatrombine/atom_init()
	. = ..()
	reagents.add_reagent("metatrombine", 15)

/obj/item/weapon/storage/pill_bottle/metatrombine
	name = "bottle of metatrombine pills"
	desc = "Metatrombine is a drug that induces high plateletes production. Can be used to temporarily coagulate blood in internal bleedings."

/obj/item/weapon/storage/pill_bottle/metatrombine/atom_init()
	. = ..()
	for (var/i in 1 to 7)
		new /obj/item/weapon/reagent_containers/pill/metatrombine(src)

/obj/item/weapon/storage/pill_bottle/stabyzol
	name = "bottle of stabyzol pills"
	desc = "Used to stimulate broken organs to a point where damage to them appears virtual while reagent is in patient's blood stream. Medicate only in small doses."

/obj/item/weapon/storage/pill_bottle/stabyzol/atom_init()
	. = ..()
	for (var/i in 1 to 7)
		new /obj/item/weapon/reagent_containers/pill/stabyzol(src)


/obj/item/weapon/reagent_containers/pill/stabyzol
	name = "stabyzol pill"
	desc = "Used to stimulate broken organs to a point where damage to them appears virtual while reagent is in patient's blood stream. Medicate only in small doses."
	icon_state = "pill18"

/obj/item/weapon/reagent_containers/pill/stabyzol/atom_init()
	. = ..()
	reagents.add_reagent("stabyzol", 5)


//BELTS
/obj/item/weapon/storage/belt/military/trooper
	name = "military belt"
	desc = "A sturdy military grade belt for holding all things that needed on the battlefield."
	icon = 'code/modules/warfare/storage.dmi'
	icon_custom = 'code/modules/warfare/storage.dmi'
	icon_state = "trooper"
	item_state = "trooper"
	can_hold = list()

/obj/item/weapon/storage/belt/military/trooper/leader
	desc = "A sturdy military grade belt for holding all things that needed on the battlefield. This is a squad leader version"
	icon_state = "leader-belt"
	item_state = "leader-belt"
	storage_slots = 9
	bypass_icon = "bypass/clothing/gear.dmi"
//IDs
/obj/item/weapon/card/id/military
	name = "identification card"
	desc = "An identification card issued to personnel aboard the UNS Ajax."
	icon = 'code/modules/warfare/id.dmi'
	icon_custom = 'code/modules/warfare/id.dmi'
	item_state = "id"

/obj/item/weapon/card/id/military/afterattack(obj/item/weapon/O, mob/user, proximity)
	if(!proximity) return
	if(istype(O, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/I = O
		src.access |= I.access
		to_chat(usr, "\blue The card's microscanners activate as you pass it over the ID, copying its access.")

/obj/item/weapon/card/id/military/general
	icon_state = "id-gen"

/obj/item/weapon/card/id/military/engineer
	icon_state = "id-eng"

/obj/item/weapon/card/id/military/army
	icon_state = "id-army"

/obj/item/weapon/card/id/military/command
	icon_state = "id-com"

/obj/item/weapon/card/id/military/medic
	icon_state = "id-med"