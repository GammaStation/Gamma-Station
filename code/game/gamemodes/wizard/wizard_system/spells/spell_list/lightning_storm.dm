/obj/effect/proc_holder/magic/nondirect/lightning_storm
	name = "Lightning storm"
	desc = ""
	mana_cost = 0
	cooldown = 35
	delay = 25



/obj/effect/proc_holder/magic/nondirect/lightning_storm/cast()
	owner.current.tesla_ignore = TRUE
	playsound(owner.current.loc, 'sound/magic/lightningbolt.ogg', 100, 1)
	message_admins("[usr] ([usr.ckey]) used [src.name] spell at [get_area(usr)].(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
	var/list/affected_objects = list()
	for(var/atom/A in oview(owner.current, LIGHTNING_STORM_RANGE))
		if(istype(A, /obj/machinery) || istype(A, /obj/structure) || isliving(A))
			affected_objects.Add(A)

	for(var/i in 1 to LIGHTNING_STORM_AMOUNT_OF_LIGHTNINGS)
		var/obj/to_zap = safepick(affected_objects)
		tesla_zap(owner.current, LIGHTNING_STORM_JUMP_RANGE, LIGHTNING_STORM_POWER, to_zap)

	owner.current.tesla_ignore = FALSE


#undef LIGHTNING_STORM_MANACOST
#undef LIGHTNING_STORM_DELAY
#undef LIGHTNING_STORM_POWER
#undef LIGHTNING_STORM_AMOUNT_OF_LIGHTNINGS
#undef LIGHTNING_STORM_RANGE
#undef LIGHTNING_STORM_JUMP_RANGE



