/obj/item/clothing/head/helmet/space/rig/gert
	name = "blood-red hybrid helmet"
	desc = "An advanced helmet designed for work in special operations. Property of Gorlex Emergency Responce Team."
	icon_state = "rig0-syndie"
	item_state = "syndie_helm"
	//armor = list(melee = 60, bullet = 55, laser = 30,energy = 30, bomb = 50, bio = 100, rad = 60)
	armor = list (melee = 60, bullet = 65, laser = 55, energy = 45, bomb = 50, bio = 100, rad = 60)
	var/obj/machinery/camera/camera
	var/combat_mode = FALSE
	species_restricted = list("exclude" , SKRELL , DIONA, VOX)
	var/image/lamp = null
	var/equipped_on_head = FALSE
	flags = BLOCKHAIR | THICKMATERIAL | PHORONGUARD
	light_color = "#00f397"

/obj/item/clothing/head/helmet/space/rig/gert/equipped(mob/user, slot)
	. = ..()
	if(slot == slot_head)
		equipped_on_head = TRUE
		update_icon(user)

/obj/item/clothing/head/helmet/space/rig/gert/dropped(mob/user)
	. = ..()
	if(equipped_on_head)
		equipped_on_head = FALSE
		update_icon(user)

/obj/item/clothing/head/helmet/space/rig/gert/proc/checklight()
	if(on)
		set_light(l_range = brightness_on, l_color = light_color)
	else if(combat_mode)
		set_light(l_range = 1.23) // Minimal possible light_range that'll make helm lights visible in full dark from distance. Most likely going to break if somebody will touch lightning formulae.
	else
		set_light(0)

/obj/item/clothing/head/helmet/space/rig/gert/update_icon(mob/user)
	user.overlays -= lamp
	if(equipped_on_head && camera && (on || combat_mode))
		lamp = image(icon = 'icons/mob/nuclear_helm_overlays.dmi', icon_state = "terror[combat_mode ? "_combat" : ""]_glow", layer = ABOVE_LIGHTING_LAYER)
		lamp.plane = LIGHTING_PLANE + 1
		lamp.alpha = on ? 255 : 127
		user.overlays += lamp
	icon_state = "rig[on]-syndie[combat_mode ? "-combat" : ""]"
	user.update_inv_head()

/obj/item/clothing/head/helmet/space/rig/gert/attack_self(mob/user)
	if(camera)
		on = !on
	else
		camera = new /obj/machinery/camera(src)
		camera.replace_networks(list("ERT"))
		cameranet.removeCamera(camera)
		camera.c_tag = user.name
		to_chat(user, "<span class='notice'>User scanned as [camera.c_tag]. Camera activated.</span>")
	checklight()
	update_icon(user)

/obj/item/clothing/head/helmet/space/rig/gert/verb/toggle()
	set category = "Object"
	set name = "Adjust helmet"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.restrained())
		combat_mode = !combat_mode
		if(combat_mode)
			armor = list(melee = 60, bullet = 65, laser = 55,energy = 45, bomb = 50, bio = 100, rad = 60)
			canremove = FALSE
			flags |= (HEADCOVERSEYES | HEADCOVERSMOUTH)
			usr.visible_message("<span class='notice'>[usr] moves faceplate of their helmet into combat position, covering their visor and extending cameras.</span>")
		else
			armor = list(melee = 60, bullet = 55, laser = 30,energy = 30, bomb = 50, bio = 100, rad = 60)
			canremove = TRUE
			flags &= ~(HEADCOVERSEYES | HEADCOVERSMOUTH)
			usr.visible_message("<span class='notice'>[usr] pulls up faceplate from helmet's visor, retracting cameras</span>")
		checklight()
		update_icon(usr)

/obj/item/clothing/head/helmet/space/rig/gert/examine(mob/user)
	..()
	if(src in view(1, user))
		to_chat(user, "This helmet has a built-in camera. It's [camera ? "" : "in"]active.")

/obj/item/clothing/head/helmet/space/rig/gert/attackby(obj/item/W, mob/living/carbon/human/user)
	if(!istype(user) || user.species.flags[IS_SYNTHETIC])
		return
	if(!istype(W, /obj/item/weapon/reagent_containers/pill))
		return
	if(!combat_mode && equipped_on_head)
		user.SetNextMove(CLICK_CD_RAPID)
		var/obj/item/weapon/reagent_containers/pill/P = W
		P.reagents.trans_to_ingest(user, W.reagents.total_volume)
		to_chat(user, "<span class='notice'>[src] consumes [W] and injected reagents to you!</span>")
		qdel(W)


/obj/item/clothing/suit/space/rig/gert
	name = "blood-red hybrid suit"
	desc = "An advanced suit that protects against injuries during special operations. Property of Gorlex Emergency Responce Team."
	icon_state = "rig-syndie"
	item_state = "syndie_hardsuit"
	slowdown = 1.4
	//armor = list(melee = 60, bullet = 65, laser = 55, energy = 45, bomb = 50, bio = 100, rad = 60)
	armor = list(melee = 60, bullet = 35, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 60)
	allowed = list(/obj/item/device/flashlight,
	               /obj/item/weapon/tank,
	               /obj/item/device/suit_cooling_unit,
	               /obj/item/weapon/gun,
	               /obj/item/ammo_box/magazine,
	               /obj/item/ammo_casing,
	               /obj/item/weapon/melee/baton,
	               /obj/item/weapon/melee/energy/sword,
	               /obj/item/weapon/handcuffs)
	species_restricted = list("exclude" , UNATHI , TAJARAN , DIONA, VOX)
	action_button_name = "Toggle space suit mode"
	var/combat_mode = FALSE

/obj/item/clothing/suit/space/rig/gert/update_icon(mob/user)
	..()
	icon_state = "rig-syndie[combat_mode ? "-combat" : ""]"
	user.update_inv_wear_suit()

/obj/item/clothing/suit/space/rig/gert/ui_action_click()
	toggle_mode()

/obj/item/clothing/suit/space/rig/gert/verb/toggle_mode()
	set category = "Object"
	set name = "Adjust space suit"
	set src in usr

	if(usr.canmove && !usr.stat && !usr.restrained())
		combat_mode = !combat_mode
		if(combat_mode)
			canremove = FALSE
			can_breach = FALSE
			flags_pressure &= ~STOPS_PRESSUREDMAGE
			playsound(usr, "sound/effects/air_release.ogg", 50)
			usr.visible_message("<span class='notice'>[usr]'s suit depressurizes, exposing armor plates.</span>")
		else
			canremove = TRUE
			can_breach = TRUE
			flags_pressure |= STOPS_PRESSUREDMAGE
			playsound(usr, "sound/effects/inflate.ogg", 30)
			usr.visible_message("<span class='notice'>[usr]'s suit inflates and pressurizes.</span>")
		update_icon(usr)


//Commander
/obj/item/clothing/head/helmet/space/rig/gert/commander
	name = "Gorlex emergency responce team commander helmet"
	desc = "A helmet worn by the commander of a Gorlex Emergency Responce Team. Has blue highlights. Armoured and space ready."
	icon_state = "rig0-gert_commander"
	item_state = "helm-command"
	item_color = "gert_commander"
	//armor = list(melee = 60, bullet = 65, laser = 55, energy = 45, bomb = 50, bio = 100, rad = 60)
	armor = list(melee = 60, bullet = 55, laser = 30,energy = 30, bomb = 50, bio = 100, rad = 60)


/obj/item/clothing/suit/space/rig/gert/commander
	name = "Gorlex emergency responce team commander suit"
	desc = "A suit worn by the Gorlex Emergency Responce Team. Has blue highlights. Armoured, space ready, and fire resistant."
	icon_state = "gert_commander"
	item_state = "suit-command"
	slowdown = 1.4
	//armor = list(melee = 60, bullet = 65, laser = 55, energy = 55, bomb = 50, bio = 100, rad = 60)
	armor = list(melee = 60, bullet = 65, laser = 55, energy = 45, bomb = 50, bio = 100, rad = 60)
	//breach_threshold = 28

//Security
/obj/item/clothing/head/helmet/space/rig/gert/security
	name = "Gorlex emergency responce team security helmet"
	desc = "A helmet worn by security members of a Gorlex Emergency Responce Team. Has red highlights. Armoured and space ready."
	icon_state = "rig0-gert_security"
	item_state = "syndicate-helm-black-red"
	item_color = "gert_security"
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 30, bomb = 65, bio = 100, rad = 10)

/obj/item/clothing/suit/space/rig/gert/security
	name = "Gorlex emergency responce team security suit"
	desc = "A suit worn by security members of a Gorlex Emergency Responce Team. Has red highlights. Armoured, space ready, and fire resistant."
	icon_state = "gert_security"
	item_state = "syndicate-black-red"
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 30, bomb = 65, bio = 100, rad = 10)
	breach_threshold = 25
	slowdown = 1.4

//Engineer
/obj/item/clothing/head/helmet/space/rig/gert/engineer
	name = "Gorlex emergency responce team engineer helmet"
	desc = "A helmet worn by engineering members of a Gorlex Emergency Responce Team. Has orange highlights. Armoured and space ready."
	icon_state = "rig0-gert_engineer"
	item_color = "gert_engineer"
	siemens_coefficient = 0
	armor = list(melee = 60, bullet = 35, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 75)

/obj/item/clothing/suit/space/rig/gert/engineer
	name = "Gorlex emergency responce team engineer suit"
	desc = "A suit worn by the engineering of a Gorlex Emergency Responce Team. Has orange highlights. Armoured, space ready, and fire resistant."
	icon_state = "gert_engineer"
	siemens_coefficient = 0
	armor = list(melee = 60, bullet = 35, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 75)

//Medical
/obj/item/clothing/head/helmet/space/rig/gert/medical
	name = "Gorlex emergency responce team medical helmet"
	desc = "A helmet worn by medical members of a Gorlex Emergency Responce Team. Has white highlights. Armoured and space ready."
	icon_state = "rig0-gert_medical"
	item_color = "ert_medical"

/obj/item/clothing/suit/space/rig/gert/medical
	name = "Gorlex emergency responce team medical suit"
	desc = "A suit worn by medical members of a Gorlex Emergency Responce Team. Has white highlights. Armoured and space ready."
	icon_state = "gert_medical"
	slowdown = 0.8


/*/obj/item/clothing/head/helmet/space/rig/nuke
	name = "assault team helmet"
	desc = "A helmet worn by members of the NanoTrasen Assault Team. Armoured and space ready."
	icon_state = "rig0-ert_commander"
	item_state = "helm-command"
	//armor = list(melee = 50, bullet = 35, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 60)
	armor = list(melee = 60, bullet = 55, laser = 30,energy = 30, bomb = 50, bio = 100, rad = 60)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	var/obj/machinery/camera/camera

/obj/item/clothing/head/helmet/space/rig/nuke/attack_self(mob/user)
	if(camera)
		..(user)
	else
		camera = new /obj/machinery/camera(src)
		camera.network = list("NUKE")
		cameranet.removeCamera(camera)
		camera.c_tag = user.name
		to_chat(user, "\blue User scanned as [camera.c_tag]. Camera activated.")

/obj/item/clothing/head/helmet/space/rig/nuke/examine(mob/user)
	..()
	if(src in view(1, user))
		to_chat(user, "This helmet has a built-in camera. It's [camera ? "" : "in"]active.")

/obj/item/clothing/suit/space/rig/nuke
	name = "assault team suit"
	desc = "A suit worn by members of the NanoTrasen Assault Team. Armoured, space ready, and fire resistant."
	icon_state = "ert_commander"
	item_state = "suit-command"
	w_class = 3
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_box/magazine,/obj/item/ammo_casing,
	/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs,
	/obj/item/weapon/tank,/obj/item/weapon/rcd)
	slowdown = 1
	//armor = list(melee = 60, bullet = 35, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 60)
	armor = list(melee = 60, bullet = 65, laser = 55, energy = 45, bomb = 50, bio = 100, rad = 60)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

//Commander
/obj/item/clothing/head/helmet/space/rig/nuke/commander
	name = "assault team commander helmet"
	desc = "A helmet worn by the commander of a NanoTrasen Assault Team. Has blue highlights. Armoured and space ready."
	icon_state = "rig0-ert_commander"
	item_state = "helm-command"
	item_color = "ert_commander"
	//armor = list(melee = 60, bullet = 65, laser = 55, energy = 45, bomb = 50, bio = 100, rad = 60)
	armor = list(melee = 60, bullet = 55, laser = 30,energy = 30, bomb = 50, bio = 100, rad = 60)


/obj/item/clothing/suit/space/rig/nuke/commander
	name = "assault team commander suit"
	desc = "A suit worn by the NanoTrasen Assault Team. Has blue highlights. Armoured, space ready, and fire resistant."
	icon_state = "ert_commander"
	item_state = "suit-command"
	slowdown = 1.4
	//armor = list(melee = 60, bullet = 65, laser = 55, energy = 55, bomb = 50, bio = 100, rad = 60)
	armor = list(melee = 60, bullet = 65, laser = 55, energy = 45, bomb = 50, bio = 100, rad = 60)
	//breach_threshold = 28

//Security
/obj/item/clothing/head/helmet/space/rig/nuke/security
	name = "assault team security helmet"
	desc = "A helmet worn by security members of a NanoTrasen Assault Team. Has red highlights. Armoured and space ready."
	icon_state = "rig0-ert_security"
	item_state = "syndicate-helm-black-red"
	item_color = "ert_security"
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 30, bomb = 65, bio = 100, rad = 10)

/obj/item/clothing/suit/space/rig/nuke/security
	name = "assault team security suit"
	desc = "A suit worn by security members of a NanoTrasen Assault Team. Has red highlights. Armoured, space ready, and fire resistant."
	icon_state = "ert_security"
	item_state = "syndicate-black-red"
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 30, bomb = 65, bio = 100, rad = 10)
	breach_threshold = 25
	slowdown = 1.4

//Engineer
/obj/item/clothing/head/helmet/space/rig/nuke/engineer
	name = "assault team engineer helmet"
	desc = "A helmet worn by engineering members of a NanoTrasen Assault Team. Has orange highlights. Armoured and space ready."
	icon_state = "rig0-ert_engineer"
	item_color = "ert_engineer"
	siemens_coefficient = 0
	armor = list(melee = 60, bullet = 35, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 75)

/obj/item/clothing/suit/space/rig/nuke/engineer
	name = "assault team engineer suit"
	desc = "A suit worn by the engineering of a NanoTrasen Assault Team. Has orange highlights. Armoured, space ready, and fire resistant."
	icon_state = "ert_engineer"
	siemens_coefficient = 0
	armor = list(melee = 60, bullet = 35, laser = 30,energy = 15, bomb = 30, bio = 100, rad = 75)

//Medical
/obj/item/clothing/head/helmet/space/rig/nuke/medical
	name = "assault team medical helmet"
	desc = "A helmet worn by medical members of a NanoTrasen Assault Team. Has white highlights. Armoured and space ready."
	icon_state = "rig0-ert_medical"
	item_color = "ert_medical"

/obj/item/clothing/suit/space/rig/nuke/medical
	name = "assault team medical suit"
	desc = "A suit worn by medical members of a NanoTrasen Assault Team. Has white highlights. Armoured and space ready."
	icon_state = "ert_medical"
	slowdown = 0.8
*/