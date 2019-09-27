var/list/supply_points = list()
var/list/supply_drops = list()

/obj/effect/landmark/supplydrop_point
	name = "supply_point"
	icon_state = "s_arrow"

/obj/effect/landmark/supplydrop_point/atom_init()
	..()
	supply_points += loc
	return INITIALIZE_HINT_QDEL

/obj/machinery/computer/outpost_supply
	name = "Communications Console"
	desc = "This can be used for communications."
	icon = 'icons/obj/computer-new.dmi'
	icon_state = "comm"
	light_color = "#00b000"
	var/points = 3

/obj/machinery/computer/outpost_supply/atom_init()
	..()

	for(var/typepath in subtypesof(/datum/supply_drop))
		var/datum/supply_drop/P = new typepath()
		supply_drops[P.name] = P


/obj/machinery/computer/outpost_supply/ui_interact(mob/user)
	var/dat = "<i>�� ����� ��������� � '�����', ����� ������� ���������� � �������� ���� ���������� � �������� �������, ������� ��-�������� ��������� �� ������. ��������� ��� ������� �����, �� ������ ���������� ������� "
	dat += "� ���� ������� �� �����������. ������, �������� ������� �������� ����������, ��������� ���������� ���������� ���������� ��� ������ �������, ��� ������� �������. ��������� ������ �� ����������.</i><br>"
	dat += "<span><b>������������ ����������: [points]</b></span><br>"

	if(points)
		for(var/supply_name in supply_drops)
			var/datum/supply_drop/N = supply_drops[supply_name]
			dat += "<A href='?src=\ref[src];order=[N]'>[N.name]</A><BR>"

	var/datum/browser/popup = new(user, "out_sup", "Supply", 600, 700)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(icon, icon_state))
	popup.open()

/obj/machinery/computer/outpost_supply/Topic(href, href_list)
	. = ..()
	if(!.)
		return

	if(href_list["order"])

		var/datum/supply_drop/P = supply_drops[href_list["order"]]

		if(!istype(P))
			return FALSE

		if(!supply_points.len)
			return FALSE

		if(!points)
			return FALSE

		var/turf/T = pick(supply_points)
		var/list/surrounding_turfs = block(locate(T.x - 3, T.y - 3, T.z), locate(T.x + 3, T.y + 3, T.z))
		var/turf/F = pick(surrounding_turfs)
		new /obj/effect/decal/droppod_wreckage(F)
		P.generate(F)
		points--
		updateUsrDialog()

/obj/structure/closet/crate/outpost/supply_ammo
	name = "Ammunition"
	icon_opened= "ammoopen"
	icon_closed = "ammo"
	icon_state = "ammo"

/obj/structure/closet/crate/outpost/supply_ammo/PopulateContents()
	for (var/i in 1 to 6)
		new /obj/item/ammo_box/fancy(src)
	new /obj/item/ammo_box/fancy/shotgun(src)
	new /obj/item/ammo_box/fancy/shotgun(src)

/obj/structure/closet/crate/outpost/supply_materials
	name = "Construction Materials"
	icon_opened= "constructionopen"
	icon_closed = "construction"
	icon_state = "construction"

/obj/structure/closet/crate/outpost/supply_materials/PopulateContents()
	for (var/i in 1 to 6)
		new /obj/item/stack/sheet/glass(src)
	new /obj/item/stack/sheet/metal(src)
	new /obj/item/stack/sheet/plasteel(src)


/datum/supply_drop
	var/name = "Crate"
	var/crate_type = /obj/structure/closet/crate
	var/list/contains = null
	var/cost = 1
	var/amount

/datum/supply_drop/proc/generate(turf/T)
	var/obj/structure/closet/crate/C = new crate_type(T)

	for(var/item in contains)
		var/n_item = new item(C)
		if(amount && (istype(n_item, /obj/item/stack/sheet) || istype(n_item, /obj/item/stack/tile)))
			var/obj/item/stack/sheet/n_sheet = n_item
			n_sheet.set_amount(amount)

	return C

/datum/supply_drop/ammo
	name = "Ammunition"
	crate_type = /obj/structure/closet/crate/outpost/ammo
	contains = list(/obj/item/ammo_box/fancy,
					/obj/item/ammo_box/fancy,
					/obj/item/ammo_box/fancy,
					/obj/item/ammo_box/fancy,
					/obj/item/ammo_box/fancy,
					/obj/item/ammo_box/fancy,
					/obj/item/ammo_box/fancy/shotgun,
					/obj/item/ammo_box/fancy/shotgun,)

/datum/supply_drop/materials
	name = "Construction Materials"
	crate_type = /obj/structure/closet/crate/outpost/construction
	amount = 50
	contains = list(/obj/item/stack/sheet/glass,
					/obj/item/stack/sheet/metal,
					/obj/item/stack/sheet/plasteel)