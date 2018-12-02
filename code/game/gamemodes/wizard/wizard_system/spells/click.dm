/obj/effect/proc_holder/magic/click_on
	var/list/types_to_click = list("turfs", "objects", "mobs")

/obj/effect/proc_holder/magic/click_on/Click()
	if(!iswizard(owner.current))
		return

	if(owner.wizard_power_system.chosen_spell != src)
		set_spell(owner)
	else
		unset_spell(owner)


/obj/effect/proc_holder/magic/click_on/proc/set_spell()
	to_chat(owner.current, "<font color='purple'><i>I have prepared [name]</i></font>")
	owner.wizard_power_system.chosen_spell = src

/obj/effect/proc_holder/magic/click_on/proc/unset_spell()
	to_chat(owner.current, "<font color='purple'><i>I have dismissed [name]</i></font>")
	owner.wizard_power_system.chosen_spell = null


/obj/effect/proc_holder/magic/click_on/proc/get_target_type(atom/target)		//Checks should return nothing for spell to be succeeded. Not TRUE.
	if(isliving(target))
		if(("mobs" in types_to_click) && !check_mob_cast(target))
			return "mob"
		else if(("turfs" in types_to_click) && !check_turf_cast(get_turf(target)))
			return "turf"
	else if(istype(target, /obj))
		if(("objects" in types_to_click) && !check_object_cast(target))
			return "object"
		else if(("turfs" in types_to_click) && !check_turf_cast(get_turf(target)))
			return "turf"
	else if(isturf(target) && ("turfs" in types_to_click))
		if(!check_turf_cast(get_turf(target)))
			return "turf"

	owner.current << sound('sound/magic/magicfail.ogg')
	return


/obj/effect/proc_holder/magic/click_on/proc/handle_targeted_cast(atom/spell_target)
	if(!can_cast())
		return

	var/target_type = get_target_type(spell_target)
	if(!target_type)
		return

	if(delay)
		if(owner.current.busy_with_action)
			return
		to_chat(owner.current, "<font color='purple'><i>I start to cast [name]!</i></font>")		//proc for delay stuff
		owner.current.visible_message("<span class = 'danger'>[owner.current] starts to chant something!</span>")
		if(!do_after(owner.current,delay, needhand = FALSE, target = spell_target))
			return
		if(!can_cast())
			return

	targeted_cast(spell_target,target_type)
	return


/obj/effect/proc_holder/magic/click_on/proc/targeted_cast(atom/target, targettype)
//Depending on what we click, we call the appropriate proc.
//If we can't cast spell on type we click, but can cast spell on turf, we cast spell on turf, on which that object is standing
//So you won't, for example, be unable to create a forcewall because you clicked on vent, and not on turf with that vent
	switch(targettype)
		if("mob")
			cast_on_mob(target)
		if("object")
			cast_on_object(target)
		if("turf")
			cast_on_turf(get_turf(target))
		else
			return

	owner.wizard_power_system.spend_mana(mana_cost)

/obj/effect/proc_holder/magic/click_on/proc/cast_on_mob(mob/living/target)
	return

/obj/effect/proc_holder/magic/click_on/proc/cast_on_object(obj/target)
	return

/obj/effect/proc_holder/magic/click_on/proc/cast_on_turf(turf/target)
	return

/obj/effect/proc_holder/magic/click_on/proc/check_mob_cast(mob/living/target)
	return

/obj/effect/proc_holder/magic/click_on/proc/check_object_cast(obj/target)
	return

/obj/effect/proc_holder/magic/click_on/proc/check_turf_cast(turf/target)
	return


/obj/effect/proc_holder/magic/click_on/shoot
	var/projectile
	var/shootsound


/obj/effect/proc_holder/magic/click_on/shoot/targeted_cast(atom/target)
	if(!can_cast())
		return

	if(istype(target, /turf))		//This fixes bug of projectile just remaining in the air, if caster tries to shoot on his own turf
		var/turf/targetturf = target
		if(locate(owner.current) in targetturf.contents)
			return
	if(shootsound)
		playsound(owner.current, shootsound, 50)
	var/obj/item/projectile/P = new projectile(owner.current.loc)
	P.Fire(target, owner.current)
	owner.wizard_power_system.spend_mana(mana_cost)


