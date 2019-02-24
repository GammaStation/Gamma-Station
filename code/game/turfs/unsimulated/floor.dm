/turf/unsimulated/floor
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "Floor3"

/turf/unsimulated/floor/abductor
	name = "alien floor"
	icon_state = "alienpod1"

/turf/unsimulated/floor/abductor/atom_init()
	. = ..()
	icon_state = "alienpod[rand(1,9)]"

/turf/unsimulated/floor/attack_paw(user)
	return src.attack_hand(user)

/turf/unsimulated/floor/self_cleaning
	var/list/uncleanable_items = list(/mob/living, /obj/item/thunder_dog_tag, /mob/dead/observer, /obj/effect/landmark, /obj/effect/light_emitter, /obj/effect/glowshroom, /obj/effect/decal/remains/human, /obj/effect/forcefield, /obj/item/weapon, /obj/structure, /obj/machinery) //We dont want this items to be deleted

var/global/list/self_cleaning_list = list()

/turf/unsimulated/floor/self_cleaning/atom_init()
	..()
	return INITIALIZE_HINT_LATELOAD

/turf/unsimulated/floor/self_cleaning/atom_init_late()
	..()
	self_cleaning_list += src

/turf/unsimulated/floor/self_cleaning/proc/cleaner() //Not sure if this is the correct way to do that
	for(var/atom/A in contents)
		if(!is_type_in_list(A, uncleanable_items))
			qdel(A)

/turf/unsimulated/floor/self_cleaning/Destroy()
	self_cleaning_list -= src
	return ..()