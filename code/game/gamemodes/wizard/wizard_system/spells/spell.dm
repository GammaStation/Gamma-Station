var/list/magic_spells = typesof(/obj/effect/proc_holder/magic)

/obj/effect/proc_holder/magic
	panel = "Spells"
	name = "Master Spell"
	desc = "" // Fluff
	var/mana_cost = 0
	var/delay = DEFAULT_DELAY
	var/continuous = FALSE
	var/req_stat = CONSCIOUS // Can this spell be cast when you are incapacitated/dead?
	var/robeless = FALSE
	var/datum/mind/owner		//Owner mind of the spell. Honestly, not sure if this is good idea, to use owner.current instead of user. And owner instead of user.mind.
	var/list/required_schools = list()

/obj/effect/proc_holder/magic/Destroy()
	owner = null
	return ..()

/obj/effect/proc_holder/magic/proc/can_cast()		//Nondirect spells have NO target
	if(!iswizard(owner.current))
		return FALSE

	if(owner.wizard_power_system.mana < mana_cost)
		to_chat(owner.current, "<font color='purple'><i>I have not enough mana!</i></font>")
		return FALSE

	if(req_stat < owner.current.stat)
		to_chat(owner.current, "<font color='purple'><i>How am I supposed to cast a spell when I lost consciousness?!</i></font>")
		return FALSE
	return TRUE


/obj/effect/proc_holder/magic/proc/spell_specific_checks(atom/spell_target)
	return TRUE



/obj/effect/proc_holder/magic/nondirect/proc/cast()
	return


/obj/effect/proc_holder/magic/nondirect/proc/handle_cast_nondirect()
	if(!can_cast(owner.current))
		return

	if(!spell_specific_checks())
		return

	if(delay)		//Multicast delay spells
		if(owner.current.busy_with_action == TRUE)
			return
		to_chat(owner.current, "<font color='purple'><i>I start to cast [name]!</i></font>")		//proc for delay stuff
		if(!do_after(owner.current,delay, needhand = FALSE, target = owner.current))
			return

	cast()
	owner.wizard_power_system.spend_mana(mana_cost)
	return



/obj/effect/proc_holder/magic/nondirect/Click()
	handle_cast_nondirect()
	return

/*
	M.attack_log += "\[[time_stamp()]\] <b>[user]/[user.ckey]</b> shot <b>[M]/[M.ckey]</b> with a <b>syringegun</b> ([R])"
	user.attack_log += "\[[time_stamp()]\] <b>[user]/[user.ckey]</b> shot <b>[M]/[M.ckey]</b> with a <b>syringegun</b> ([R])"
	msg_admin_attack("[user.name] ([user.ckey]) shot [M.name] ([M.ckey]) with a syringegun ([R]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
*/

#undef DEFAULT_DELAY
