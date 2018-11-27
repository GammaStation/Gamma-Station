/obj/effect/proc_holder/magic/nondirect/stable_portal
	name = "Stable portal"
	desc = ""
	mana_cost = 0
	delay = 0



/obj/effect/proc_holder/magic/nondirect/stable_portal/cast()
//	message_admins("[usr] ([usr.ckey]) used [src.name] spell at [get_area(usr)].(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
//	log_game("[usr] ([usr.ckey]) used [src.name] spell."))
//	effects, drop logs on death, sounds
	var/list/L = list()
	var/A = input("Area to open portal into", "Portal") in teleportlocs
	var/area/thearea = teleportlocs[A]

	for(var/turf/T in get_area_turfs(thearea.type))
		if(!is_blocked_turf(T))
			L+=T

	var/turf/exit_loc = safepick(L)
	if(!exit_loc)
		to_chat(owner.current, "The spell matrix was unable to locate a suitable teleport destination for an unknown reason. Sorry.")
		return
	new /obj/effect/portal/tsci_wormhole (owner.current.loc, exit_loc)