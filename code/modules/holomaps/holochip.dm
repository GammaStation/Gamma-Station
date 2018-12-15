var/global/list/holochips = list()
var/global/image/default_holomap

/obj/item/holochip
	name = "Holomap chip"
	desc = "A small holomap module, attached to helmets."
	icon = 'icons/holomaps/holochips.dmi'
	icon_state = "holochip"
	var/role_filter = null //Because all holochips are stored in one list, this is used to display holochips only with same role_filters
	var/color_filter = null //Color for station's image, defined in flags.dm
	var/marker_prefix = null //Marker prefix for mob indicator on holomap, see holomap_markers.dmi

	var/mob/living/carbon/human/activator = null
	var/obj/item/holder = null
	var/list/holomap_images = list()

	var/image/holomap_base

/obj/item/holochip/atom_init(obj/item/I)
	. = ..()
	holder = I
	holochips += src

/obj/item/holochip/Destroy()
	STOP_PROCESSING(SSobj, src)
	deactivate_holomap()
	QDEL_NULL(holomap_base)
	QDEL_LIST(holomap_images)
	holder = null
	activator = null
	holochips -= src
	return ..()

/obj/item/holochip/process()
	if(!activator || !activator.client || activator.stat == DEAD || activator.head != holder)
		deactivate_holomap()
		return
	handle_markers()

/obj/item/holochip/proc/activate_holomap(mob/user)
	if(activator)
		return
	activator = user
	if(!holomap_base)
		if(!default_holomap)
			default_holomap = image(generate_holo_map())
		holomap_base = default_holomap
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
	STOP_PROCESSING(SSobj, src)

/obj/item/holochip/proc/handle_markers()
	if(!activator || !activator.client)
		deactivate_holomap()
		return
	if(length(holomap_images))
		activator.client.images -= holomap_images
		QDEL_LIST(holomap_images)
	for(var/obj/item/holochip/HC in holochips)
		if(HC.role_filter != role_filter)
			continue
		var/turf/marker_location = get_turf(HC)
		if(marker_location.z != ZLEVEL_STATION)
			continue
		var/image/I = image('icons/holomaps/holomap_markers.dmi', "error")
		if(ishuman(HC.holder.loc))
			var/mob/living/carbon/human/H = HC.holder.loc
			if(H.head != HC.holder)
				continue
			if(H.stat == DEAD)
				I.icon_state = "[HC.marker_prefix]_3"
			else if(H.stat == UNCONSCIOUS || H.incapacitated())
				I.icon_state = "[HC.marker_prefix]_2"
			else
				I.icon_state = "[HC.marker_prefix]_1"
		else
			continue
		if(HC == src)
			I.icon_state = "you"
		I.loc = activator.hud_used.holomap_obj
		I.pixel_x = (marker_location.x - 6) * PIXEL_MULTIPLIER
		I.pixel_y = (marker_location.y - 6) * PIXEL_MULTIPLIER
		I.plane = ABOVE_HUD_PLANE
		I.layer = ABOVE_HUD_LAYER
		holomap_images += I
		animate(I ,alpha = 255, time = 8, loop = -1, easing = SINE_EASING)
		animate(I ,alpha = 0, time = 5, easing = SINE_EASING)
		animate(I ,alpha = 255, time = 2, easing = SINE_EASING)
	activator.client.images += holomap_images

#define HOLOMAP_WALKABLE_TILE "#66666699"
#define HOLOMAP_CONCRETE_TILE "#FFFFFFDD"

/proc/generate_holo_map()
	var/icon/holomap = icon('icons/holomaps/canvas.dmi', "blank")
	var/turf/center = locate(world.maxx/2, world.maxy/2, 1)
	if(!center)
		return
	var/list/turf/turfs = RANGE_TURFS(world.maxx/2, center)
	for(var/turf/T in turfs)
		if (istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor) || istype(T, /turf/simulated/shuttle/floor))
			holomap.DrawBox(HOLOMAP_WALKABLE_TILE, T.x, T.y)
		if(istype(T, /turf/simulated/wall) || istype(T, /turf/unsimulated/wall) || locate(/obj/structure/grille) in T || locate(/obj/structure/window) in T)
			holomap.DrawBox(HOLOMAP_CONCRETE_TILE, T.x, T.y)
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
