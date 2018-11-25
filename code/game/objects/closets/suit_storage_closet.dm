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

/obj/structure/suit_closet/attackby(obj/item/I, mob/user)
	user.SetNextMove(CLICK_CD_INTERACT)
	if(istype(I, /obj/item/weapon/card/id))


/obj/structure/suit_closet
	QDEL_NULL(shelmet)
	QDEL_NULL(ssuit)
	return ..()