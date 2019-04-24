/obj/effect/proc_holder/magic/nondirect/blink
	name = "Blink"
	desc = ""
	mana_cost = BLINK_MANACOST

/obj/effect/proc_holder/magic/nondirect/blink/cast()
	var/list/turfs = list()
	for(var/turf/T in range(owner.current, 7))
		if(!is_blocked_turf(T) && !istype(T,/turf/space))
			turfs += T

	var/turf/picked = safepick(turfs)
	if(!picked)
		to_chat(owner.current, "There is no place for me to jump!")
		return TRUE

	var/datum/effect/effect/system/spark_spread/spark_system_first = new /datum/effect/effect/system/spark_spread()
	spark_system_first.set_up(5, 0, owner.current)
	spark_system_first.start()
	owner.current.forceMove(picked)
	var/datum/effect/effect/system/spark_spread/spark_system_second = new /datum/effect/effect/system/spark_spread()
	spark_system_second.set_up(5, 0, owner.current)
	spark_system_second.start()

