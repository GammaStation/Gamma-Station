/datum/hud/proc/vrhuman_hud(ui_style = 'icons/mob/screen_vrhuman.dmi')
	var/mob/living/carbon/human/vrhuman/V = mymob

	V.vrhuman_shop = new /obj/screen/vrhuman_shop()
	V.vrhuman_shop.icon = 'icons/mob/screen_vrhuman.dmi'
	V.vrhuman_shop.icon_state = "vrui_shop"
	V.vrhuman_shop.screen_loc = ui_vrhuman_shop
	V.vrhuman_shop.layer = ABOVE_HUD_LAYER
	V.vrhuman_shop.plane = ABOVE_HUD_PLANE
	V.vrhuman_shop.alpha = 0

	V.vrhuman_exit = new /obj/screen/vrhuman_exit()
	V.vrhuman_exit.icon = 'icons/mob/screen_vrhuman.dmi'
	V.vrhuman_exit.icon_state = "vrui_exit"
	V.vrhuman_exit.screen_loc = ui_vrhuman_exit
	V.vrhuman_exit.layer = ABOVE_HUD_LAYER
	V.vrhuman_exit.plane = ABOVE_HUD_PLANE
	V.vrhuman_exit.alpha = 0

	V.vrhuman_main = new /obj/screen/vrhuman_main()
	V.vrhuman_main.icon = 'icons/mob/screen_vrhuman.dmi'
	V.vrhuman_main.icon_state = "vrui_main"
	V.vrhuman_main.screen_loc = ui_vrhuman_main
	V.vrhuman_main.layer = ABOVE_HUD_LAYER
	V.vrhuman_main.plane = ABOVE_HUD_PLANE

	V.vrhuman_cleanup = new /obj/screen/vrhuman_cleanup()
	V.vrhuman_cleanup.icon = 'icons/mob/screen_vrhuman.dmi'
	V.vrhuman_cleanup.icon_state = "vrui_cleanup"
	V.vrhuman_cleanup.screen_loc = ui_vrhuman_cleanup
	V.vrhuman_cleanup.layer = ABOVE_HUD_LAYER
	V.vrhuman_cleanup.plane = ABOVE_HUD_PLANE
	V.vrhuman_cleanup.alpha = 0

	V.vrhuman_dienow = new /obj/screen/vrhuman_dienow()
	V.vrhuman_dienow.icon = 'icons/mob/screen_vrhuman.dmi'
	V.vrhuman_dienow.icon_state = "vrui_dienow"
	V.vrhuman_dienow.screen_loc = ui_vrhuman_dienow
	V.vrhuman_dienow.layer = ABOVE_HUD_LAYER
	V.vrhuman_dienow.plane = ABOVE_HUD_PLANE
	V.vrhuman_dienow.alpha = 0

	V.client.screen += list(V.vrhuman_shop, V.vrhuman_exit, V.vrhuman_main, V.vrhuman_cleanup, V.vrhuman_dienow)
	V.client.screen += mymob.client.void

/obj/screen/vrhuman_shop/Click(location, control, params)
	if(alpha == 0)
		return
	var/mob/living/carbon/human/vrhuman/V = usr
	if(!V.vr_shop.vr_mind)
		V.vr_shop.vr_mind = V.mind
	V.vr_shop.trigger(V)

/obj/screen/vrhuman_exit/Click(location, control, params)
	if(alpha == 0)
		return
	var/mob/living/carbon/human/vrhuman/V = usr
	V.exit_body()

/obj/screen/vrhuman_cleanup/Click(location, control, params)
	if(alpha == 0)
		return
	var/mob/living/carbon/human/vrhuman/V = usr
	V.try_cleanup()

/obj/screen/vrhuman_dienow/Click(location, control, params)
	if(alpha == 0)
		return
	var/mob/living/carbon/human/vrhuman/V = usr
	V.dienow()

/obj/screen/vrhuman_main
	var/hidden = TRUE

/obj/screen/vrhuman_main/Click(location, control, params)
	var/mob/living/carbon/human/vrhuman/V = usr
	hidden = !hidden
	if(hidden)
		V.vrhuman_exit.alpha = 0
		V.vrhuman_shop.alpha = 0
		V.vrhuman_cleanup.alpha = 0
		V.vrhuman_dienow.alpha = 0
		icon_state = "vrui_main"
	else
		V.vrhuman_exit.alpha = 255
		V.vrhuman_shop.alpha = 255
		V.vrhuman_cleanup.alpha = 255
		V.vrhuman_dienow.alpha = 255
		icon_state = "vrui_main_open"

