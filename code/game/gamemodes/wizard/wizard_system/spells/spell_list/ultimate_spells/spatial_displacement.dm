/obj/effect/proc_holder/magic/nondirect/spatial_displacement
	name = "Spatial displacement"
	desc = ""
	mana_cost = 0
	ultimate = TRUE
	var/area/thearea

//Forbid to use on centcomm

//It may be abused by players to teleport armory away.
//Although, not sure if I want to fix it, since explicitly removing Armory from locactions list is kinda ugly, and wizards can't use guns anyway. Disarming security is pretty reasonable effect for Ultimate spell.
//But if they do it constantly, then I am going to use a crutch and exclude armory from locations list. And justify it by some kind of anti-bluespace protection, I dunno...

/obj/effect/proc_holder/magic/nondirect/spatial_displacement/spell_specific_checks()
	var/A = input("Area to transfer", "Displacement") in teleportlocs
	if(!A)
		return TRUE

	thearea = teleportlocs[A]


/obj/effect/proc_holder/magic/nondirect/spatial_displacement/cast()
	playsound(owner.current.loc, 'sound/magic/CastSummon.ogg', 100, 1,channel = 2)
	var/turf/T = pick(get_area_turfs(thearea))
	if(T)
		var/turf/FROM = T
		var/turf/TO = get_turf(owner.current)
		playsound(TO, 'sound/effects/phasein.ogg', 100, 1,channel = 1)
//		command_alert("Massive bluespace translocation detected.", "Anomaly Alert")

		var/y_distance = TO.y - FROM.y
		var/x_distance = TO.x - FROM.x
		for (var/atom/movable/A in ultra_range(12, FROM ))
			if(A.anchored && istype(A,/obj/singularity)) continue
			var/turf/newloc = locate(A.x + x_distance, A.y + y_distance, TO.z) // calculate the new place
			if(!A.Move(newloc) && newloc) // if the atom, for some reason, can't move, FORCE them to move! :) We try Move() first to invoke any movement-related checks the atom needs to perform after moving
				A.forceMove(newloc)

		for(var/mob/living/carbon/human/M in viewers(TO, null))
			if(M.eyecheck() <= 0)
				M.flash_eyes()
//	message_admins("[usr] ([usr.ckey]) used [src.name] spell and opened a portal from [get_area(usr)] to [get_area(location)].(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")