
/datum/weather/ash_storm //Ash Storms: Common happenings on lavaland. Heavily obscures vision and deals heavy fire damage to anyone caught outside.
	name = "ash storm"
	desc = "An intense atmospheric storm lifts ash off of the planet's surface and billows it down across the area, dealing intense fire damage to the unprotected."

	telegraph_message = "<span class='boldwarning'>An eerie moan rises on the wind. Sheets of sand blacken the horizon. Seek shelter.</span>"
	telegraph_duration = 300
	telegraph_sound = 'sound/ambience/ash_storm_windup.ogg'
	telegraph_overlay = "light_ash"

	weather_message = "<span class='userdanger'><i>Smoldering clouds of scorching trash billow down around you! Get inside!</i></span>"
	weather_duration_lower = 600
	weather_duration_upper = 1500
	weather_sound = 'sound/ambience/ash_storm_start.ogg'
	weather_overlay = "ash_storm"
	weather_alpha = 170
	overlay_layer = 10
	end_message = "<span class='boldannounce'>The shrieking wind whips away the last of the ash and falls to its usual murmur. It should be safe to go outside now.</span>"
	end_duration = 300
	end_sound = 'sound/ambience/ash_storm_end.ogg'
	end_overlay = "light_ash"
	area_type = /area/surface
	target_z = ZLEVEL_STATION
//	impacted_areas = list(/area/planet_surface,/area/outpost/outside)
	immunity_type = "ash"
	probability = 40

/datum/weather/ash_storm/proc/is_ash_immune(atom/L)
	while (L && !isturf(L))
		if(istype(L.loc, /obj/mecha)) //Mechs are immune
			return TRUE
		if(ishuman(L)) //Are you immune?
			var/mob/living/carbon/human/H = L
			var/thermal_protection = H.get_heat_protection(LAVA_TURF_TEMP+30)
			if(thermal_protection >= SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE)
				return TRUE
		if(isliving(L))// if we're a non immune mob inside an immune mob we have to reconsider if that mob is immune to protect ourselves
			var/mob/living/the_mob = L
			if("ash" in the_mob.weather_immunities)
				return TRUE
		L = L.loc //Check parent items immunities (recurses up to the turf)
	return FALSE //RIP you


/datum/weather/ash_storm/impact(mob/living/L)
	if(is_ash_immune(L))
		return
	L.adjustFireLoss(4)

/datum/weather/ash_storm/emberfall //Emberfall: An ash storm passes by, resulting in harmless embers falling like snow. 10% to happen in place of an ash storm.
	name = "emberfall"
	desc = "A passing ash storm blankets the area in harmless embers."

	weather_message = "<span class='notice'>Gentle embers waft down around you like grotesque snow. The storm seems to have passed you by...</span>"
	weather_sound = 'sound/ambience/ash_storm_windup.ogg'
	weather_overlay = "light_ash"

	end_message = "<span class='notice'>The emberfall slows, stops. Another layer of hardened soot to the ground beneath your feet.</span>"
	weather_alpha = 250
	aesthetic = TRUE
	probability = 60