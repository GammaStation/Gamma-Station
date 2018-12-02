/obj/effect/proc_holder/magic/click_on/architect
	name = "Architect's hand"
	desc = ""
	delay = ARCHITECT_DELAY
	mana_cost = ARCHITECT_MANACOST
	types_to_click = list("turfs", "objects")


/obj/effect/proc_holder/magic/click_on/architect/check_turf_cast(turf/target)
	if(owner.current.a_intent != "hurt")
		if(is_blocked_turf(target))
			to_chat(owner.current, "<font color='purple'><i>This place is occupied! I can't build anything here!</i></font>")
			return TRUE
	else
		if(!istype(target, /turf/simulated/wall))
			return TRUE


/obj/effect/proc_holder/magic/click_on/architect/check_object_cast(obj/target)
	if(!istype(target, /obj/machinery/door/airlock) && !istype(target, /obj/structure/mineral_door) && !istype(target,/obj/structure/window/phoronreinforced))
		return TRUE


/obj/effect/proc_holder/magic/click_on/architect/cast_on_turf(turf/target)
	var/datum/effect/effect/system/steam_spread/steam = new /datum/effect/effect/system/steam_spread()
	steam.set_up(6, 0, target)
	steam.start()
	switch(owner.current.a_intent)
		if("help")
			target.ChangeTurf(/turf/simulated/wall/mineral/gold)
			message_admins("[usr] ([usr.ckey]) created a wall at X=[target.x] Y=[target.y] Z=[target.z] with [src.name] spell.(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")

		if("disarm")
			var/obj/structure/window/phoronreinforced/A = new(target)
			A.anchored = TRUE
			A.dir = SOUTHWEST
			A.ini_dir = SOUTHWEST
			A.color = null
			message_admins("[usr] ([usr.ckey]) created a window at X=[target.x] Y=[target.y] Z=[target.z] with [src.name] spell.(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
		if("hurt")
			if(istype(target, /turf/simulated/wall))
				target.ChangeTurf(/turf/simulated/floor/plating/airless)
				message_admins("[usr] ([usr.ckey]) deleted a wall at X=[target.x] Y=[target.y] Z=[target.z] with [src.name] spell.(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
		if("grab")
			message_admins("[usr] ([usr.ckey]) created a door at X=[target.x] Y=[target.y] Z=[target.z] with [src.name] spell.(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
			new /obj/structure/mineral_door/wood(target)

	playsound(target, 'sound/magic/arch_hand.ogg', 50, 1)


/obj/effect/proc_holder/magic/click_on/architect/cast_on_object(turf/target)
	var/datum/effect/effect/system/steam_spread/steam = new /datum/effect/effect/system/steam_spread()
	steam.set_up(6, 0, target)
	steam.start()
	if(owner.current.a_intent == "hurt")
		message_admins("[usr] ([usr.ckey]) deleted a door at X=[target.x] Y=[target.y] Z=[target.z] with [src.name] spell.(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
		qdel(target)

	playsound(target, 'sound/magic/arch_hand.ogg', 50, 1)



#undef ARCHITECT_MANACOST
#undef ARCHITECT_DELAY