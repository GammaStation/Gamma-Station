var/global/list/thunderfield_spawns_list = list()

/obj/effect/landmark/thunderfield_spawn/atom_init()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/thunderfield_spawn/atom_init_late()
	thunderfield_spawns_list += src

/obj/effect/landmark/thunderfield_spawn/Destroy()
	thunderfield_spawns_list -= src
	return ..()

/obj/item/thunder_dog_tag
	name = "Dog tag"
	desc = "Collect it to get points"
	icon_state = "dogtag"
	layer = FLY_LAYER //So the dog tag will be located higher than dead bodies
	var/points

/obj/item/thunder_dog_tag/equipped(mob/user)
	..()
	if(!isvrhuman(user))
		return
	user.mind.thunder_points += points
	to_chat(user, "<span class='warning'>You get [points] points! Your total points are: [user.mind.thunder_points]</span>")
	qdel(src)