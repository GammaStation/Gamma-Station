/turf/simulated/shuttle/wall/ship_white
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	icon = 'icons/turf/ship.dmi'
	icon_state = "mwall"
	base_state = "mwall"
	join_group = "mwall"
	join_always = list(
	/obj/structure/shuttle/window
	)

/turf/simulated/shuttle/wall/ship_white/hard_corner
	icon_state = "mwall-hc"
	hard_corner = TRUE

/turf/simulated/shuttle/wall/ship_white/no_join
	icon_state = "mwall-nj"
	join_group = null

/turf/simulated/shuttle/wall/ship_white/no_join/underlay
	icon_state = "mwall-nj"
	join_group = null
	takes_underlays = TRUE


/turf/simulated/shuttle/wall/ship_white/black
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	icon = 'icons/turf/ship_black.dmi'
	icon_state = "black"
	base_state = "black"
	join_group = "black"

/turf/simulated/shuttle/wall/ship_white/black/hard_corner
	icon_state = "black-hc"
	hard_corner = TRUE

/turf/simulated/shuttle/wall/ship_white/black/no_join
	icon_state = "black-nj"
	join_group = null

/turf/simulated/shuttle/wall/ship_white/black/no_join/underlay
	icon_state = "black-nj"
	join_group = null
	takes_underlays = TRUE