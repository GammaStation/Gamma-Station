/mob/camera/Eye/overmap/proc/blind_turfs(var/client/user_client, var/radius)
	if(!user_client)
		return
	for(var/turf/T in overmap_turfs)
		var/I = image('icons/turf/floors.dmi', T, "map", LIGHTING_LAYER+1)
		user_client.images += I
	for(var/turf/T in RANGE_TURFS(radius, src.loc))
		for(var/image/I in user_client.images)
			if(I.icon_state == "map" && I.loc == T)
				user_client.images -= I
				qdel(I)

/mob/camera/Eye/overmap/proc/pre_destroy(var/client/user_client)
	if(!user_client)
		return
	for(var/image/I in user_client.images)
		if(I.icon_state != "map")
			continue
		user_client.images -= I
		qdel(I)

/mob/camera/Eye/overmap/examinate(atom/A as mob|obj|turf in view())
	set popup_menu = FALSE
	set src = usr.contents
	return FALSE

/mob/camera/Eye/overmap/pointed()
	set popup_menu = FALSE
	set src = usr.contents
	return FALSE