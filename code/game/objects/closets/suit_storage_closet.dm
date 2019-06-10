/obj/structure/suit_closet
	name = "Space suit storage"
	desc = "Storage for space suits"
	icon = 'icons/obj/suitcloset.dmi'
	icon_state = "suitcloset_closed"
	anchored = TRUE
	density = TRUE
	var/obj/item/clothing/head/helmet/space/shelmet
	var/obj/item/clothing/suit/space/ssuit
	var/islocked = FALSE
	var/closed = TRUE
	var/in_process = FALSE

/obj/structure/suit_closet/attackby(obj/item/I, mob/user)
	user.SetNextMove(CLICK_CD_INTERACT)
	if(istype(I, /obj/item/weapon/card/id))
		return
	else if(istype(I, /obj/item/clothing/suit/space))
		if(ssuit)
			to_chat(user, "<span class='notice'>There is already [ssuit.name]!</span>")
			return
		if(closed)
			to_chat(user, "<span class='notice'>You must open the door first!</span>")
			return
		user.drop_item(I)
		I.forceMove(src)
		ssuit = I
		overlays += image('icons/obj/suitcloset.dmi', "suitcloset_scarf")
	else if(istype(I, /obj/item/clothing/head/helmet/space))
		if(shelmet)
			to_chat(user, "<span class='notice'>There is already [ssuit.name]!</span>")
			return
		if(closed)
			to_chat(user, "<span class='notice'>You must open the door first!</span>")
			return
		user.drop_item(I)
		I.forceMove(src)
		shelmet = I
		overlays += image('icons/obj/suitcloset.dmi', "suitcloset_helmet")

/obj/structure/suit_closet/attack_hand(mob/user)
	if(in_process)
		//It is already opening/closing
		return
	if(closed)
		open()
	else
		ui_interact(user)

/obj/structure/suit_closet/proc/open()
	in_process = TRUE
	icon_state = "suitcloset_open"
	underlays += image('icons/obj/suitcloset.dmi', "suitcloset_open")
	if(shelmet)
		underlays += image('icons/obj/suitcloset.dmi', "suitcloset_helmet")
	if(ssuit)
		underlays += image('icons/obj/suitcloset.dmi', "suitcloset_scarf")
	flick("anim_open", src)
	addtimer(CALLBACK(src, .proc/after_open), 20)

/obj/structure/suit_closet/proc/after_open()
	in_process = FALSE
	closed = FALSE
	overlays.Cut()
	underlays.Cut()
	update_icons()

/obj/structure/suit_closet/proc/close()
	in_process = TRUE
	overlays.Cut()
	if(shelmet)
		underlays += image('icons/obj/suitcloset.dmi', "suitcloset_helmet")
	if(ssuit)
		underlays += image('icons/obj/suitcloset.dmi', "suitcloset_scarf")
	underlays += image('icons/obj/suitcloset.dmi', "suitcloset_open")
	flick("anim_close", src)
	addtimer(CALLBACK(src, .proc/after_close), 20)

/obj/structure/suit_closet/proc/after_close()
	closed = TRUE
	in_process = FALSE
	overlays.Cut()
	underlays.Cut()
	icon_state = "suitcloset_closed"

/obj/structure/suit_closet/proc/update_icons()
	overlays.Cut()
	underlays.Cut()
	if(shelmet)
		overlays += image('icons/obj/suitcloset.dmi', "suitcloset_helmet")
	if(ssuit)
		overlays += image('icons/obj/suitcloset.dmi', "suitcloset_scarf")

/obj/structure/suit_closet/ui_interact(mob/user)
	if(!ishuman(user) || isobserver(user))
		return
	if((get_dist(src, user) > 1) || (closed))
		user << browse(null, "window=op")
		return
	var/dat = "<HEAD><TITLE>Suit storage unit</TITLE></HEAD>"
	dat+= text("<font color='black'>Helmet storage compartment: <B>[]</B></font><BR>",(src.shelmet ? shelmet.name : "</font><font color ='grey'>No helmet detected.") )
	if(shelmet && !closed)
		dat+=text("<A href='?src=\ref[];dispense_helmet=1'>Dispense helmet</A><BR>",src)
	dat+= text("<font color='black'>Suit storage compartment: <B>[]</B></font><BR>",(src.ssuit ? ssuit.name : "</font><font color ='grey'>No exosuit detected.") )
	if(ssuit && !closed)
		dat+=text("<A href='?src=\ref[];dispense_suit=1'>Dispense suit</A><BR>",src)
	if(!closed)
		dat+=text("<A href='?src=\ref[];close_closet=1'>Close suit storage</A><BR>",src)
	user << browse(entity_ja(dat), "window=op")
	onclose(user, "op")

/obj/structure/suit_closet/Topic(href, href_list)
	..()
	if (href_list["dispense_helmet"])
		dispense_helmet()
	else if (href_list["dispense_suit"])
		dispense_suit()
	else if (href_list["close_closet"] && !in_process && !closed)
		in_process = TRUE
		close()
	updateUsrDialog()

/obj/structure/suit_closet/proc/dispense_helmet()
	if(!shelmet)
		return
	shelmet.forceMove(get_turf(src))
	shelmet = null
	overlays.Cut()
	update_icons()

/obj/structure/suit_closet/proc/dispense_suit()
	if(!ssuit)
		return
	ssuit.forceMove(get_turf(src))
	ssuit = null
	update_icons()

/obj/structure/suit_closet/Destroy()
	QDEL_NULL(shelmet)
	QDEL_NULL(ssuit)
	return ..()