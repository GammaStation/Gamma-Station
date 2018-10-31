/obj/effect/proc_holder/magic/nondirect/lightning_storm
	name = "Lightning storm"
	desc = ""
	mana_cost = LIGHTNING_STORM_MANACOST
	delay = LIGHTNING_STORM_DELAY



/obj/effect/proc_holder/magic/nondirect/lightning_storm/cast()
	owner.current.tesla_ignore = TRUE
	playsound(owner.current.loc, 'sound/magic/lightningbolt.ogg', 100, 1)
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



