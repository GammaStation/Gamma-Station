/obj/effect/proc_holder/magic/click_on/temperature_shift
	name = "Temperature shift"
	desc = ""
	delay = TEMP_SHIFT_DELAY
	mana_cost = TEMP_SHIFT_MANACOST
	types_to_click = list("mobs", "turfs")


/obj/effect/proc_holder/magic/click_on/temperature_shift/cast_on_mob(mob/living/target)
	switch(owner.current.a_intent)
		if("help")
			to_chat(owner.current, "<span class='wizard'>I carefully lower [target] temperature</span>")
			to_chat(target, "<span class='notice'>Your body feels cold</span>")
			target.bodytemperature += TEMP_SHIFT_WEAK_COLD
		if("disarm")
			to_chat(owner.current, "<span class='wizard'>I freeze the [target]!</span>")
			to_chat(target, "<span class='danger'>You feel terrible chill washing all over your body!</span>")
			target.bodytemperature += TEMP_SHIFT_STRONG_COLD
		if("hurt")
			to_chat(owner.current, "<span class='wizard'>I heat [target] up!</span>")
			to_chat(target, "<span class='danger'>You feel terrible scorching heat spreading all over your body!</span>")
			target.bodytemperature += TEMP_SHIFT_STRONG_HEAT
		if("grab")
			to_chat(owner.current, "<span class='wizard'>I carefully rise [target] temperature</span>")
			to_chat(target, "<span class='danger'>Your body feels warm</span>")
			target.bodytemperature += TEMP_SHIFT_WEAK_HEAT


/obj/effect/proc_holder/magic/click_on/temperature_shift/check_turf_cast(turf/target)
	var/datum/gas_mixture/aircheck = target.return_air()
	if(!aircheck || !aircheck.total_moles || target.blocks_air)
		to_chat(owner.current, "<span class='wizard'>There is no gas to manipulate in this area!</span>")
		return TRUE

	if(istype(target, /turf/unsimulated))
		to_chat(owner.current, "<span class='wizard'>Some kind of mystical force prevents me to manipulate temperature in this area!</span>")
		return TRUE

/obj/effect/proc_holder/magic/click_on/temperature_shift/cast_on_turf(turf/target)
	var/datum/gas_mixture/env = target.return_air()
	var/datum/gas_mixture/removed = env.remove(env.total_moles)

	switch(owner.current.a_intent)
		if("help")
			to_chat(owner.current, "<span class='wizard'>I carefully lower air temperature in that area</span>")
			removed.add_thermal_energy(TEMP_SHIFT_WEAK_COLD_ATMOS)
		if("disarm")
			to_chat(owner.current, "<span class='wizard'>I freeze the air in that area!</span>")
			removed.add_thermal_energy(TEMP_SHIFT_STRONG_COLD_ATMOS)
		if("hurt")
			to_chat(owner.current, "<span class='wizard'>I heat the air in that area up!</span>")
			removed.add_thermal_energy(TEMP_SHIFT_STRONG_HEAT_ATMOS)
		if("grab")
			to_chat(owner.current, "<span class='wizard'>I carefully rise air temperature in that area</span>")
			removed.add_thermal_energy(TEMP_SHIFT_WEAK_HEAT_ATMOS)

	var/old_temp = env.temperature
	env.merge(removed)
	message_admins("[usr] ([usr.ckey]) changed the temperature on the turf in [get_area(target)] using temperature shift. Old temperature: [old_temp]K. New temperature: [env.temperature]K(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>)")
	log_game("[usr] ([usr.ckey]) changed the temperature on the turf in [get_area(target)] using temperature shift. Old temperature: [old_temp]K. New temperature: [env.temperature]K.")

#undef TEMP_SHIFT_DELAY
#undef TEMP_SHIFT_MANACOST
#undef TEMP_SHIFT_WEAK_HEAT
#undef TEMP_SHIFT_STRONG_HEAT
#undef TEMP_SHIFT_WEAK_COLD
#undef TEMP_SHIFT_STRONG_COLD
#undef TEMP_SHIFT_WEAK_HEAT_ATMOS
#undef TEMP_SHIFT_STRONG_HEAT_ATMOS
#undef TEMP_SHIFT_WEAK_COLD_ATMOS
#undef TEMP_SHIFT_STRONG_COLD_ATMOS