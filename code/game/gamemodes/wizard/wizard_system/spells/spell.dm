var/list/magic_spells = typesof(/obj/effect/proc_holder/magic)

/obj/effect/proc_holder/magic
	panel = "Spells"
	name = "Master Spell"
	desc = "" // Fluff
	var/mana_cost = 0
	var/delay = DEFAULT_DELAY
	var/req_stat = CONSCIOUS // Can this spell be cast when you are incapacitated/dead?
	var/robeless = FALSE
	var/datum/mind/owner		//Owner mind of the spell. Honestly, not sure if this is good idea, to use owner.current instead of user. And owner instead of user.mind.
	var/cooldown = 0		//In seconds
	var/cooldown_left
	var/ultimate = FALSE	//Ultimate spell reduces your max mana
	var/cast_message		//Message when finished casting
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
	if(ultimate && istype(owner.current,/mob/living/carbon/human/shadow_twin))
		to_chat(owner.current, "<span class='wizard'>This form is too frail for such a spell!</span>")
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


	if(delay)		//Multicast delay spells
		if(owner.current.is_busy())
			return
		if(!ultimate)
			to_chat(owner.current, "<span class='wizard'>I start to cast [name]!</span>")
			owner.current.visible_message("<span class = 'danger'>[owner.current] starts to chant something!</span>")
		else
			for(var/mob/M in view(7,owner.current))
				if(M.client)
					shake_camera(M, 7, 1)
			to_chat(owner.current, "<span class='wizard'><b>I start to cast [name]!</b></span>")
			owner.current.visible_message("<span class = 'big'>[owner.current] glows with power as they loudly chant something!</span>")
			owner.wizard_power_system.spend_mana(mana_cost)
		if(!do_after(owner.current,delay, needhand = FALSE, target = owner.current))
			return
		if(!can_cast())
			return

	if(!cast())		//Negative so I do not have to post . = ..() everywhere
		if(!ultimate)
			owner.wizard_power_system.spend_mana(mana_cost)		//Non ultimate spells spend mana after chanting. Ultimate spend mana at the beginning
		if(cooldown > 0)
			cooldown_left = 0
		if(ultimate)
			owner.wizard_power_system.maxmana -= WIZARD_ULTIMATE_SPELL_MANA_PENALTY
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
