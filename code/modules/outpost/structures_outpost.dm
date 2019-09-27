/obj/structure/girder/outpost
	icon = 'icons/obj/structures/outpost/misc.dmi'
	icon_state = "outgirder"
	wall_type = /turf/simulated/wall/outpost
	health = 200

/obj/structure/girder/outpost/reinforced
	icon_state = "outgirder_reinforced"
	wall_type = /turf/simulated/wall/r_wall/outpost
	sheet_type = /obj/item/stack/sheet/plasteel
	state = 2
	health = 500

/obj/structure/girder/outpost/reinforced/attackby(obj/item/W, mob/user)
	..()
	if(istype(W, /obj/item/weapon/screwdriver) && state == 2)
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		to_chat(user, "\blue Now unsecuring support struts")
		if(do_after(user,40,target = src))
			if(!src) return
			to_chat(user, "\blue You unsecured the support struts!")
			state = 1

	else if(istype(W, /obj/item/weapon/wirecutters) && state == 1)
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		to_chat(user, "\blue Now removing support struts")
		if(do_after(user,40,target = src))
			if(!src) return
			to_chat(user, "\blue You removed the support struts!")
			new /obj/structure/girder/outpost(loc)
			new sheet_type(get_turf(src), 2)
			qdel(src)

/obj/structure/window/reinforced/outpost
	name = "reinforced window"
	icon = 'icons/obj/structures/outpost/window.dmi'
	icon_state = "nwindow"
	basestate = "nwindow"

/obj/structure/window/reinforced/outpost/tinted
	name = "tinted window"
	desc = "It looks rather strong and opaque. Might take a few good hits to shatter it."
	icon_state = "ntwindow"
	basestate = "ntwindow"
	opacity = 1

/obj/structure/window/reinforced/outpost/full
	dir = 5

/obj/structure/rack/outpost
	name = "rack"
	desc = "A bunch of metal shelves stacked on top of eachother."
	icon = 'icons/obj/structures/outpost/misc.dmi'

/obj/structure/table/outpost
	icon = 'icons/obj/structures/outpost/tables.dmi'
	parts = /obj/item/weapon/table_parts/outpost

/obj/structure/grille/outpost
	icon = 'icons/obj/structures/outpost/misc.dmi'
	icon_state = "grille"

/obj/structure/reagent_dispensers/fueltank/outpost
	icon = 'icons/obj/structures/outpost/misc.dmi'
	icon_state = "fueltank"

/obj/structure/reagent_dispensers/watertank/outpost
	icon = 'icons/obj/structures/outpost/misc.dmi'

/obj/structure/closet/outpost
	icon = 'icons/obj/structures/outpost/closet.dmi'
	icon_state = "closet"
	icon_closed = "closet"
	icon_opened = "closetopen"

/obj/structure/closet/secure_closet/outpost
	icon = 'icons/obj/structures/outpost/closet.dmi'

/obj/structure/closet/secure_closet/outpost/security
	name = "Security Locker"
	req_access = list(access_outpost_security)
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

/obj/structure/closet/secure_closet/outpost/medical
	name = "Medical Locker"
	req_access = list(access_outpost_medical)
	icon_state = "med1"
	icon_closed = "med"
	icon_locked = "med1"
	icon_opened = "medopen"
	icon_broken = "medbroken"
	icon_off = "medoff"

/obj/structure/closet/secure_closet/outpost/engineering_electrical
	name = "Electrical Supplies"
	req_access = list(access_outpost_engineer)
	icon_state = "secureengelec1"
	icon_closed = "secureengelec"
	icon_locked = "secureengelec1"
	icon_opened = "toolclosetopen"
	icon_broken = "secureengelecbroken"
	icon_off = "secureengelecoff"

/obj/structure/closet/secure_closet/outpost/engineering_welding
	name = "Welding Supplies"
	req_access = list(access_outpost_engineer)
	icon_state = "secureengweld1"
	icon_closed = "secureengweld"
	icon_locked = "secureengweld1"
	icon_opened = "toolclosetopen"
	icon_broken = "secureengweldbroken"
	icon_off = "secureengweldoff"

/*


*/
/obj/structure/closet/erokez_oxygen
	name = "emergency closet"
	desc = "It's a storage unit for emergency breathmasks and o2 tanks."
	icon = 'code/modules/locations/shuttles/closet.dmi'
	icon_state = "WallClosetw"
	icon_closed = "WallClosetw"
	icon_opened = "WallClosetw_open"
	anchored = 1
	density = 1

/obj/structure/closet/erokez_oxygen/PopulateContents()
	for (var/i in 1 to 12)
		new /obj/item/weapon/tank/emergency_oxygen/engi(src)
		new /obj/item/clothing/mask/gas/half(src)
	new /obj/item/weapon/storage/toolbox/emergency(src)

/obj/structure/closet/crate/outpost
	icon = 'icons/obj/structures/outpost/crates.dmi'

/obj/structure/closet/crate/hydroponics/outpost
	icon = 'icons/obj/structures/outpost/crates.dmi'

/obj/structure/closet/crate/outpost/ammo
	icon_opened= "ammoopen"
	icon_closed = "ammo"
	icon_state = "ammo"

/obj/structure/closet/crate/outpost/construction
	icon_opened= "constructionopen"
	icon_closed = "construction"
	icon_state = "construction"

/obj/structure/stool/bed/outpost
	icon = 'icons/obj/structures/outpost/misc.dmi'
	icon_state = "bed"