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
	var/cooldown = 0		//In seconds
	var/cooldown_left
	var/list/required_schools = list()

/obj/effect/proc_holder/magic/atom_init()
	cooldown_left = cooldown
	START_PROCESSING(SSobj, src)

/obj/effect/proc_holder/magic/process()
	if(cooldown_left < cooldown)
		++cooldown_left

/obj/effect/proc_holder/magic/Destroy()
	owner = null
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/proc_holder/magic/proc/can_cast()		//Nondirect spells have NO target
	if(!iswizard(owner.current))
		return FALSE

	if(cooldown_left < cooldown)
		to_chat(owner.current, "<span class='wizard'>I can't cast this spell so frequently!</span>")
		owner.current << sound('sound/magic/magicfail.ogg')
		return FALSE

	if(owner.wizard_power_system.mana < mana_cost)
		to_chat(owner.current, "<span class='wizard'>I have not enough mana!</span>")
		owner.current << sound('sound/magic/magicfail.ogg')
		return FALSE

	if(req_stat < owner.current.stat)
		to_chat(owner.current, "<span class='wizard'>How am I supposed to cast a spell when I lost consciousness?!</span>")
		owner.current << sound('sound/magic/magicfail.ogg')
		return FALSE
	return TRUE



/obj/effect/proc_holder/magic/nondirect/proc/cast()
	return


/obj/effect/proc_holder/magic/nondirect/proc/spell_specific_checks()
	return


/obj/effect/proc_holder/magic/nondirect/proc/handle_cast_nondirect()
	if(!can_cast())
		return

	if(spell_specific_checks())
		return

// if(user.is_busy()) return


	if(delay)		//Multicast delay spells
		if(owner.current.busy_with_action == TRUE)
			return
		to_chat(owner.current, "<span class='wizard'>I start to cast [name]!</span>")		//proc for delay stuff
		owner.current.visible_message("<span class = 'danger'>[owner.current] starts to chant something!</span>")
		if(!do_after(owner.current,delay, needhand = FALSE, target = owner.current))
			return
		if(!can_cast())
			return

	if(!cast())		//Negative so I do not have to post . = ..() everywhere
		owner.wizard_power_system.spend_mana(mana_cost)
		if(cooldown > 0)
			cooldown_left = 0
	else
		owner.current << sound('sound/magic/magicfail.ogg')



/obj/effect/proc_holder/magic/nondirect/Click()
	handle_cast_nondirect()
	return

/*
	M.attack_log += "\[[time_stamp()]\] <b>[user]/[user.ckey]</b> shot <b>[M]/[M.ckey]</b> with a <b>syringegun</b> ([R])"
	user.attack_log += "\[[time_stamp()]\] <b>[user]/[user.ckey]</b> shot <b>[M]/[M.ckey]</b> with a <b>syringegun</b> ([R])"
	msg_admin_attack("[user.name] ([user.ckey]) shot [M.name] ([M.ckey]) with a syringegun ([R]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
*/

#undef DEFAULT_DELAY
