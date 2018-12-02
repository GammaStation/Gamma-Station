/obj/effect/proc_holder/magic/nondirect/stable_portal
	name = "Stable portal"
	desc = ""
	mana_cost = PORTAL_MANACOST
	delay = PORTAL_DELAY
	var/location

//Remove "charging effect" or add sleep or whatever

/obj/effect/proc_holder/magic/nondirect/stable_portal/spell_specific_checks()
	var/list/L = list()
	var/A = input("Area to open portal into", "Portal") in teleportlocs
	if(!A)
		return TRUE

	var/area/thearea = teleportlocs[A]

	for(var/turf/T in get_area_turfs(thearea.type))
		if(!is_blocked_turf(T))
			L+=T

	var/turf/exit_loc = safepick(L)
	if(!exit_loc)
		to_chat(owner.current, "The spell matrix was unable to locate a suitable teleport destination for an unknown reason. Sorry.")
		return TRUE

	location = exit_loc

/obj/effect/proc_holder/magic/nondirect/stable_portal/cast()
	var/obj/effect/portal/tsci_wormhole/wormhole = new (owner.current.loc, location)
	playsound(owner.current.loc, 'sound/magic/CastSummon.ogg', 100, 1)
	message_admins("[usr] ([usr.ckey]) used [src.name] spell and opened a portal from [get_area(usr)] to [get_area(location)].(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
	QDEL_IN(wormhole, PORTAL_LIFESPAN)

#undef PORTAL_MANACOST
#undef PORTAL_DELAY
#undef PORTAL_LIFESPAN
