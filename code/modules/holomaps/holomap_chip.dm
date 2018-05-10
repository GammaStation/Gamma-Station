var/global/list/holochips = list()

/obj/item/holochip
	name = "Holomap chip"
	desc = "A small holomap module, attached to helmets."
	icon = 'icons/holomaps/holochips.dmi'
	icon_state = "holochip"
	var/role_filter = null //Because all holochips are stored in one list, this is used to display holochips only with same role_filters
	var/color_filter = null //Color for station's image, defined in flags.dm
	var/marker_prefix = null //Marker prefix for mob indicator on holomap, see holomap_markers.dmi

	var/mob/activator = null
	var/obj/item/holder = null
	var/list/holomap_images = list()

	var/static/image/default_holomap
	var/image/holomap_base

	var/image/indicator = null
	var/pixelx = null
	var/pixely = null

/obj/item/holochip/Destroy()
	deactivate_holomap()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(indicator)
	QDEL_NULL(holomap_base)
	QDEL_NULL(holomap_images)
	holder = null
	activator = null
	holochips -= src
	return ..()

/obj/item/holochip/process()
	if(length(holomap_images))
		activator.client.images -= holomap_images
		QDEL_LIST(holomap_images)
	handle_own_marker()
	handle_markers()

/obj/item/holochip/proc/activate_holomap(mob/user)
	if(activator)
		return
	activator = user
	if(!default_holomap)
		default_holomap = image(generate_holo_map())
	holomap_base = default_holomap
	holochips += src
	if(color_filter)
		holomap_base.color = color_filter
	holomap_base.loc = activator.hud_used.holomap_obj
	activator.hud_used.holomap_obj.overlays += holomap_base
	START_PROCESSING(SSobj, src)

/obj/item/holochip/proc/deactivate_holomap()
	if(!activator)
		return
	activator.hud_used.holomap_obj.overlays.Cut()
	if(length(holomap_images) && activator.client)
		activator.client.images -= holomap_images
		QDEL_LIST(holomap_images)
	qdel(holomap_base)
	activator = null
	holochips -= src
	STOP_PROCESSING(SSobj, src)

/obj/item/holochip/proc/handle_markers()
	if(!activator || !activator.client)
		deactivate_holomap()
		return

	for(var/obj/item/holochip/HC in holochips)
		if(HC.role_filter != src.role_filter)
			continue
		var/turf/marker_location = get_turf(HC)
		if(marker_location.z != ZLEVEL_STATION)
			continue
		var/image/I = HC.indicator
		if(HC == src)
			I = image('icons/holomaps/holomap_markers.dmi', "you")
		I.loc = activator.hud_used.holomap_obj
		I.pixel_x = HC.pixelx
		I.pixel_y = HC.pixely
		I.plane = ABOVE_HUD_PLANE
		I.layer = ABOVE_HUD_LAYER
		holomap_images += I
		animate(I ,alpha = 255, time = 8, loop = -1, easing = SINE_EASING)
		animate(I ,alpha = 0, time = 5, easing = SINE_EASING)
		animate(I ,alpha = 255, time = 2, easing = SINE_EASING)

	activator.client.images |= holomap_images

/obj/item/holochip/proc/handle_own_marker()
	if(!activator)
		return
	indicator = image('icons/holomaps/holomap_markers.dmi', "error")
	if(!marker_prefix)
		indicator.icon_state = "you"
	if(ishuman(activator))
		var/mob/living/carbon/human/H = activator
		if(H.head != holder)
			return
		if(H.stat == DEAD)
			indicator.icon_state = "[marker_prefix]_3"
		else if(H.stat == UNCONSCIOUS || H.incapacitated())
			indicator.icon_state = "[marker_prefix]_2"
		else
			indicator.icon_state = "[marker_prefix]_1"
	else if(isrobot(activator))
		var/mob/living/silicon/robot/R = activator
		if(R.stat == DEAD)
			indicator.icon_state = "[marker_prefix]_0"
		else
			indicator.icon_state = "[marker_prefix]_1"
	var/turf/location = get_turf(src)
	pixelx = (location.x - 6) * PIXEL_MULTIPLIER
	pixely = (location.y - 6) * PIXEL_MULTIPLIER


#define HOLOMAP_WALKABLE_TILE "#66666699"
#define HOLOMAP_CONCRETE_TILE "#FFFFFFDD"

/obj/item/holochip/proc/generate_holo_map()
	var/icon/holomap = icon('icons/holomaps/canvas.dmi', "blank")
	for(var/i = 1 to ((2 * world.view + 1) * 32))
		for(var/r = 1 to ((2 * world.view + 1) * 32))
			var/turf/tile = locate(i, r, 1)
			if(tile)
				if (istype(tile, /turf/simulated/floor) || istype(tile, /turf/unsimulated/floor) || istype(tile, /turf/simulated/shuttle/floor))
					holomap.DrawBox(HOLOMAP_WALKABLE_TILE, i, r)
				if(istype(tile, /turf/simulated/wall) || istype(tile, /turf/unsimulated/wall) || locate(/obj/structure/grille) in tile || locate(/obj/structure/window) in tile)
					holomap.DrawBox(HOLOMAP_CONCRETE_TILE, i, r)
	return holomap

#undef HOLOMAP_WALKABLE_TILE
#undef HOLOMAP_CONCRETE_TILE

//Holochip filters for different roles and marker_prefixes

/obj/item/holochip/deathsquad
	desc = "A small holomap module, attached to helmets. There is a NT logo and a skull on it's case"
	icon_state = "holochip_nt"
	role_filter = HOLOMAP_FILTER_DEATHSQUAD
	color_filter = HOLOMAP_DEATHSQUAD_COLOR
	marker_prefix = "deathsquad"

/obj/item/holochip/vox
	desc = "A small holomap module, attached to helmets. It has a small picture of... chicken?"
	role_filter = HOLOMAP_FILTER_VOX
	color_filter = HOLOMAP_VOX_COLOR
	marker_prefix = "chicka"

/obj/item/holochip/vox/carapace
	marker_prefix = "voxc"

/obj/item/holochip/vox/pressure
	marker_prefix = "voxp"

/obj/item/holochip/vox/stealth
	marker_prefix = "voxs"

/obj/item/holochip/vox/medical
	marker_prefix = "voxm"

/obj/item/holochip/nuclear
	desc = "A small holomap module, attached to helmets."
	icon_state = "holochip_syndi"
	role_filter = HOLOMAP_FILTER_NUCLEAR
	color_filter = HOLOMAP_NUCLEAR_COLOR
	marker_prefix = "nuclear"

/obj/item/holochip/ert
	desc = "A small holomap module, attached to helmets. There is a NT logo on it"
	icon_state = "holochip_nt"
	role_filter = HOLOMAP_FILTER_ERT
	color_filter = HOLOMAP_ERT_COLOR
	marker_prefix = "ertc"

/obj/item/holochip/ert/medical
	marker_prefix = "ertm"

/obj/item/holochip/ert/engineering
	marker_prefix = "erte"

/obj/item/holochip/ert/security
	marker_prefix = "erts"
