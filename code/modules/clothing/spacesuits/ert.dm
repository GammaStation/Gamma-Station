/obj/item/clothing/head/helmet/space/rig/ert
	name = "emergency response team helmet"
	desc = "A helmet worn by members of the NanoTrasen Emergency Response Team. Armoured and space ready."
	icon_state = "rig0-ert_commander"
	item_state = "helm-command"
	armor = list(melee = 50, bullet = 35, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 60, telepathy = 15)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	var/obj/machinery/camera/camera
	actions_types = list(/datum/action/item_action/attack_self, /datum/action/item_action/hands_free/toggle_holomap)

/obj/item/clothing/head/helmet/space/rig/ert/attack_self(mob/user)
	if(camera)
		..(user)
	else
		camera = new /obj/machinery/camera(src)
		camera.network = list("ERT")
		cameranet.removeCamera(camera)
		camera.c_tag = user.name
		to_chat(user, "\blue User scanned as [camera.c_tag]. Camera activated.")

/obj/item/clothing/head/helmet/space/rig/ert/examine(mob/user)
	..()
	if(src in view(1, user))
		to_chat(user, "This helmet has a built-in camera. It's [camera ? "" : "in"]active.")

/obj/item/clothing/suit/space/rig/ert
	name = "emergency response team suit"
	desc = "A suit worn by members of the NanoTrasen Emergency Response Team. Armoured, space ready, and fire resistant."
	icon_state = "ert_commander"
	item_state = "suit-command"
	w_class = 3
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_box/magazine,/obj/item/ammo_casing,
	/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs,
	/obj/item/weapon/tank,/obj/item/weapon/rcd)
	slowdown = 1
	armor = list(melee = 60, bullet = 35, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 60, telepathy = 20)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

//Commander
/obj/item/clothing/head/helmet/space/rig/ert/commander
	name = "emergency response team commander helmet"
	desc = "A helmet worn by the commander of a NanoTrasen Emergency Response Team. Has blue highlights. Armoured and space ready."
	icon_state = "rig0-ert_commander"
	item_state = "helm-command"
	item_color = "ert_commander"
	armor = list(melee = 60, bullet = 65, laser = 55, energy = 45, bomb = 50, bio = 100, rad = 60, telepathy = 15)

/obj/item/clothing/head/helmet/space/rig/ert/commander/atom_init()
	. = ..()
	holochip = new /obj/item/holochip/ert(src)
	holochip.holder = src

/obj/item/clothing/suit/space/rig/ert/commander
	name = "emergency response team commander suit"
	desc = "A suit worn by the commander of a NanoTrasen Emergency Response Team. Has blue highlights. Armoured, space ready, and fire resistant."
	icon_state = "ert_commander"
	item_state = "suit-command"
	armor = list(melee = 60, bullet = 65, laser = 55, energy = 55, bomb = 50, bio = 100, rad = 60, telepathy = 20)
	breach_threshold = 28

//Security
/obj/item/clothing/head/helmet/space/rig/ert/security
	name = "emergency response team security helmet"
	desc = "A helmet worn by security members of a NanoTrasen Emergency Response Team. Has red highlights. Armoured and space ready."
	icon_state = "rig0-ert_security"
	item_state = "syndicate-helm-black-red"
	item_color = "ert_security"
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 30, bomb = 65, bio = 100, rad = 10, telepathy = 15)

/obj/item/clothing/head/helmet/space/rig/ert/security/atom_init()
	. = ..()
	holochip = new /obj/item/holochip/ert/security(src)
	holochip.holder = src

/obj/item/clothing/suit/space/rig/ert/security
	name = "emergency response team security suit"
	desc = "A suit worn by security members of a NanoTrasen Emergency Response Team. Has red highlights. Armoured, space ready, and fire resistant."
	icon_state = "ert_security"
	item_state = "syndicate-black-red"
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 30, bomb = 65, bio = 100, rad = 10, telepathy = 20)
	breach_threshold = 25
	slowdown = 1.4

//Engineer
/obj/item/clothing/head/helmet/space/rig/ert/engineer
	name = "emergency response team engineer helmet"
	desc = "A helmet worn by engineering members of a NanoTrasen Emergency Response Team. Has orange highlights. Armoured and space ready."
	icon_state = "rig0-ert_engineer"
	item_color = "ert_engineer"
	siemens_coefficient = 0
	armor = list(melee = 60, bullet = 35, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 75, telepathy = 15)

/obj/item/clothing/head/helmet/space/rig/ert/engineer/atom_init()
	. = ..()
	holochip = new /obj/item/holochip/ert/engineering(src)
	holochip.holder = src

/obj/item/clothing/suit/space/rig/ert/engineer
	name = "emergency response team engineer suit"
	desc = "A suit worn by the engineering of a NanoTrasen Emergency Response Team. Has orange highlights. Armoured, space ready, and fire resistant."
	icon_state = "ert_engineer"
	siemens_coefficient = 0
	armor = list(melee = 60, bullet = 35, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 75, telepathy = 20)

//Medical
/obj/item/clothing/head/helmet/space/rig/ert/medical
	name = "emergency response team medical helmet"
	desc = "A helmet worn by medical members of a NanoTrasen Emergency Response Team. Has white highlights. Armoured and space ready."
	icon_state = "rig0-ert_medical"
	item_color = "ert_medical"

	/obj/item/clothing/head/helmet/space/rig/ert/medical/atom_init()
		. = ..()
		holochip = new /obj/item/holochip/ert/medical(src)
		holochip.holder = src

/obj/item/clothing/suit/space/rig/ert/medical
	name = "emergency response team medical suit"
	desc = "A suit worn by medical members of a NanoTrasen Emergency Response Team. Has white highlights. Armoured and space ready."
	icon_state = "ert_medical"
	slowdown = 0.8

/obj/item/clothing/head/helmet/space/rig/ert/stealth
	name = "emergency response team steatlh helmet"
	desc = "A helmet worn by special stealth members of a NanoTrasen Emergency Response Team."
	icon_state = "rig0-ert_stealth"
	item_color = "ert_stealth"
	armor = list(melee = 30, bullet = 15, laser = 20, energy = 5, bomb = 20, bio = 100, rad = 100)
	light_color = "#c388eb"

/obj/item/clothing/suit/space/rig/ert/stealth
	name = "emergency response team stealth suit"
	desc = "A suit worn by special stealth members of a NanoTrasen Emergency Response Team."
	icon_state = "ert_stealth"
	armor = list(melee = 30, bullet = 15, laser = 20, energy = 5, bomb = 20, bio = 100, rad = 100)
	slowdown = 0.6
	var/on = FALSE
	var/mob/living/carbon/human/wearer
	actions_types = /datum/action/item_action/toggle_stealth

/obj/item/clothing/suit/space/rig/ert/stealth/verb/stealth()
	set name = "Toggle Stealth"
	set category = "Object"

	toggle_stealth()

/obj/item/clothing/suit/space/rig/ert/stealth/process()
	if(!on)
		return
	if(!istype(wearer.head, /obj/item/clothing/head/helmet/space/rig/ert/stealth))
		to_chat(wearer, "<span class='warning'>ERROR! Special equipment for user head, missing! Stopping invisibility protocol!</span>")
		toggle_stealth(TRUE)
	else if(is_damaged())
		toggle_stealth(TRUE)
	else
		wearer.alpha = 4

/obj/item/clothing/suit/space/rig/ert/stealth/equipped(mob/user, slot)
	..()
	if(slot == slot_wear_suit)
		wearer = user

/obj/item/clothing/suit/space/rig/ert/stealth/dropped(mob/user)
	toggle_stealth(TRUE)
	wearer = null
	..()

/obj/item/clothing/suit/space/rig/ert/stealth/proc/toggle_stealth(deactive = FALSE)
	if(on || deactive)
		on = FALSE
		wearer.alpha = 255
		STOP_PROCESSING(SSobj, src)
	else if(!deactive)
		if(wearer.is_busy())
			return
		to_chat(wearer, "<span class='notice'>Starting invisibility protocol, please wait until it done.</span>")
		if(do_after(wearer, 40, target = wearer))
			if(!istype(wearer) || wearer.wear_suit != src)
				return
			if(!istype(wearer.head, /obj/item/clothing/head/helmet/space/rig/ert/stealth))
				to_chat(wearer, "<span class='warning'>ERROR! Special equipment for user head, has not finded!</span>")
				return
			if(is_damaged())
				return
			on = TRUE
			to_chat(wearer, "<span class='notice'>Invisibility protocol has been engaged.</span>")
			START_PROCESSING(SSobj, src)

/obj/item/clothing/suit/space/rig/ert/stealth/proc/is_damaged()
	if(damage >= 2)
		to_chat(wearer, "<span class='warning'>ERROR![src] is too damaged to engage stealth invisibility protocol!</span>")
		var/datum/effect/effect/system/spark_spread/s = new
		s.set_up(5, 1, src)
		s.start()
		return TRUE
	return FALSE

/obj/item/clothing/suit/space/rig/ert/stealth/proc/overload()
	wearer.visible_message(
	"<span class='warning'>[wearer] appears from nowhere!",
	"<span class='warning'>Invisibilty protocol has been disturbed!</span>"
	)
	toggle_stealth()

/obj/item/clothing/suit/space/rig/ert/stealth/attack_reaction(mob/living/carbon/human/H, reaction_type, mob/living/carbon/human/T = null)
	if(reaction_type == REACTION_ITEM_TAKE || reaction_type == REACTION_ITEM_TAKEOFF)
		return

	if(on)
		overload()