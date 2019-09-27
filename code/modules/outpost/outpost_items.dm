/obj/item/weapon/bedsheet/outpost
	icon = 'code/modules/outpost/outpost_items.dmi'
	slot_flags = null
	icon_state = "sheet"

/obj/item/weapon/bedsheet/outpost/red
	icon_state = "sheet_red"

/obj/item/weapon/bedsheet/outpost/green
	icon_state = "sheet_green"

/obj/item/weapon/table_parts/outpost
	icon = 'code/modules/outpost/outpost_items.dmi'

/obj/item/weapon/rack_parts/outpost
	icon = 'code/modules/outpost/outpost_items.dmi'

/obj/item/weapon/rack_parts/outpost/attack_self(mob/user)
	var/obj/structure/rack/R = new /obj/structure/rack/outpost( user.loc )
	R.add_fingerprint(user)
	user.drop_item()
	qdel(src)
	return


/obj/item/weapon/extinguisher/outpost
	name = "fire extinguisher"
	desc = "A traditional red fire extinguisher."
	icon = 'code/modules/outpost/outpost_items.dmi'

/obj/item/weapon/melee/baseball_bat
	name = "baseball bat"
	desc = "There ain't a skull in the league that can withstand a swatter."
	icon = 'code/modules/outpost/outpost_items.dmi'
	icon_custom = 'code/modules/outpost/outpost_items.dmi'
	icon_state = "bat"
	item_state = "bat"
	force = 10
	throwforce = 4
	attack_verb = list("beat", "smacked")
	w_class = ITEM_SIZE_HUGE


/obj/item/weapon/storage/firstaid/regular/outpost
	icon = 'code/modules/outpost/outpost_items.dmi'
	icon_custom = 'code/modules/outpost/outpost_items.dmi'
	icon_state = "medkit"
