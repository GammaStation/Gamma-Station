/obj/effect/proc_holder/magic/click_on/candela
	name = "Candela"
	desc = ""
	mana_cost = CANDELA_MANACOST
	types_to_click = list("turfs")


//Effects and shit
//Can place through walls

/obj/effect/proc_holder/magic/click_on/candela/check_turf_cast(turf/target)
	if(is_blocked_turf(target))
		to_chat(owner.current, "<span class='wizard'>This place is occupied! I can't place a magic latern here!</span>")
		return TRUE
	if(locate(/obj/effect/candela) in target.contents)
		return TRUE


/obj/effect/proc_holder/magic/click_on/candela/cast_on_turf(turf/target)
	var/obj/effect/candela/orb = new(target)
	var/chosen_color
	switch(owner.current.a_intent)
		if("help")
			chosen_color = "#32CD32"
		if("disarm")
			chosen_color = "#0000FF"
		if("hurt")
			chosen_color = "#FF0000"
		if("grab")
			chosen_color = "#CCCC00"

	orb.set_light(CANDELA_LIGHT_POWER, 1, chosen_color)
	orb.color = chosen_color
	QDEL_IN(orb, CANDELA_LIFESPAN)


/obj/effect/candela
	name = "glowing orb"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "resurrection"
	anchored = TRUE

#undef CANDELA_MANACOST
#undef CANDELA_LIGHT_POWER
#undef CANDELA_LIFESPAN