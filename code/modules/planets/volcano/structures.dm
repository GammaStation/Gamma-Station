/obj/structure/flora/rock/volcano
	name = "rock"
	desc = "A big rock."
	icon = 'icons/obj/flora/rocks.dmi'
	icon_state = "basalt"
	density = TRUE
	anchored = TRUE

/obj/structure/flora/rock/volcano/atom_init()
	. = ..()
	icon_state = "[initial(icon_state)][rand(1,3)]"