/obj/effect/proc_holder/magic/click_on/candela
	name = "Candela"
	desc = ""
	mana_cost = 0
	types_to_click = list("turfs")


//Effects and shit

/obj/effect/proc_holder/magic/click_on/candela/check_turf_cast(turf/target)
	. = ..()
	if(is_blocked_turf(target))
		to_chat(owner.current, "<font color='purple'><i>This place is occupied! I can't place a magic latern here!</i></font>")
		return FALSE
	if(locate(/obj/effect/candela) in target.contents)
		return FALSE


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

	orb.set_light(5, 1, chosen_color)
	orb.color = chosen_color
	QDEL_IN(orb, 3000)


/obj/effect/candela
	name = "glowing orb"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "resurrection"