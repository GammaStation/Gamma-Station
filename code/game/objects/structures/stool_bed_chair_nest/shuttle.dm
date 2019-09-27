/obj/structure/stool/bed/chair/schair
	name = "shuttle chair"
	desc = "You sit in this. Either by will or force."
	icon = 'icons/obj/objects.dmi'
	icon_state = "schair"
	var/sarmrest = null

/obj/structure/stool/bed/chair/schair/atom_init()
	sarmrest = image(icon, "[icon_state]_armrest", layer = FLY_LAYER)
	. = ..()

/obj/structure/stool/bed/chair/schair/post_buckle_mob(mob/living/M)
	if(buckled_mob)
		overlays += sarmrest
	else
		overlays -= sarmrest

/obj/structure/stool/bed/chair/schair/passenger_chair
	icon = 'icons/obj/structures/furniture.dmi'
	icon_state = "passenger_chair"
	var/buckle = null

/obj/structure/stool/bed/chair/schair/passenger_chair/atom_init()
	buckle = image(icon, "[icon_state]_buckle", layer = FLY_LAYER)
	. = ..()

/obj/structure/stool/bed/chair/schair/passenger_chair/post_buckle_mob(mob/living/M)
	if(buckled_mob)
		icon_state = "passenger_chair_buckled"
		overlays += sarmrest
		overlays += buckle
	else
		overlays -= sarmrest
		overlays -= buckle
		icon_state = "passenger_chair"

/obj/structure/stool/bed/chair/schair/pilot_chair
	icon = 'icons/obj/structures/furniture.dmi'
	icon_state = "pilot_chair"