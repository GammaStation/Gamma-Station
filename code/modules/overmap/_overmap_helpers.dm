/proc/find_rift()
	if(empty_rift_navpoints.len)
		var/navpoint = empty_rift_navpoints[1]
		empty_rift_navpoints -= navpoint
		return navpoint
	else
		return create_rift()

/proc/create_rift()
	var/turf/landmark
	if(!bluespace_rift_navpoints.len)
		landmark = get_turf(locate(/obj/effect/landmark/overmap/center))
	else
		landmark = bluespace_rift_navpoints[bluespace_rift_navpoints.len]
	var/turf/T = locate((landmark.x + BLUESPACE_OFFSET), (landmark.y + BLUESPACE_OFFSET), landmark.z)
	rift_template = overmap_templates[rift_template_id]
	rift_template.load(T, TRUE)
	var/bluespace_navpoint = new /obj/effect/landmark/overmap/bluespace_rift_navpoint(T)
	bluespace_rift_navpoints += bluespace_navpoint
	return bluespace_navpoint