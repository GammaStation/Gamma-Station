var/list/rally_points = list()
var/list/invasion_starts = list()
var/list/waypoints = list()


/obj/effect/landmark/rally_point
	name = "rally_point"
	icon_state = "x"

/obj/effect/landmark/rally_point/atom_init()
	..()
	rally_points += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/way_point
	name = "way_point"
	icon_state = "x3"
	var/id = ""
	var/number = 1

/obj/effect/landmark/way_point/atom_init()
	..()
	waypoints += src

/obj/effect/landmark/invasion_start
	name = "invasion_start"
	var/id = ""
/obj/effect/landmark/invasion_start/atom_init()
	..()
	invasion_starts += src

