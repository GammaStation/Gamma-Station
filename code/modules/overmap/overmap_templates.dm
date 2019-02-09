/datum/map_template/overmap
	var/id

/datum/map_template/overmap/proc/id()
	if(id)
		return id
	else
		return null

/datum/map_template/overmap/bluespace_rift
	id = "bluespace_rift"
	mappath = "maps/templates/bluespace_rift.dmm"