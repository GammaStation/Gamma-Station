/obj/effect/overmap
	icon = 'icons/effects/overmap.dmi'
	anchored = TRUE

/obj/effect/overmap/sector
	name = "generic sector"
	desc = "Sector with some stuff in it."
	icon_state = "sector"

/obj/effect/overmap/event
	name = "generic event"

/obj/effect/overmap/event/atom_init()
	icon_state = ("[icon_state]"+"[pick(1,2,3,4)]")

/obj/effect/overmap/event/meteor
	name = "meteor field"
	icon_state = "meteor"

/obj/effect/overmap/event/dust
	name = "dust field"
	icon_state = "dust"

/obj/effect/overmap/event/electrical
	name = "electrical field"
	icon_state = "electrical"

/obj/effect/overmap/event/carp
	name = "carp flock"
	icon_state = "carp"

/obj/effect/overmap/event/ion
	name = "ion field"
	icon_state = "ion"

/obj/effect/overmap/ship
	name = "ship"
	icon_state = "ship"
	var/current_sector = null

/obj/effect/overmap/ship/atom_init()
	. = ..()
	if(loc == gamma_overmap.loc)
		forceMove(gamma_overmap)

/obj/effect/overmap/object
	name = "generic object"
	icon_state = "object"

/obj/effect/overmap/object/gamma
	name = "NFS Gamma"

/obj/effect/overmap/object/gamma/atom_init()
	. = ..()
	gamma_overmap = src

/obj/effect/overmap/object/derelict
	name = "Unknown ship"