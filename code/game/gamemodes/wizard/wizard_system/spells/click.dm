/obj/effect/proc_holder/magic/click_on
	var/list/types_to_click = list("turfs", "objects", "mobs")

/obj/effect/proc_holder/magic/click_on/Click()
	if(!iswizard(owner.current))
		return

	if(!(owner.wizard_power_system.chosen_spell) || owner.wizard_power_system.chosen_spell != src)
		set_spell(owner)
	else
		unset_spell(owner)


/obj/effect/proc_holder/magic/click_on/proc/set_spell()
	to_chat(owner.current, "<font color='purple'><i>I have prepared [name]</i></font>")
	owner.wizard_power_system.chosen_spell = src

/obj/effect/proc_holder/magic/click_on/proc/unset_spell()
	to_chat(owner.current, "<font color='purple'><i>I have dismissed [name]</i></font>")
	owner.wizard_power_system.chosen_spell = null


/obj/effect/proc_holder/magic/click_on/proc/handle_targeted_cast(atom/spell_target)
	if(!can_cast(spell_target))
		return

	if(!spell_specific_checks(spell_target))
		return

	if(delay)		//Multicast delay spells
		if(owner.current.busy_with_action == TRUE)
			return
		to_chat(owner.current, "<font color='purple'><i>I start to cast [name]!</i></font>")		//proc for delay stuff
		if(!do_after(owner.current,delay, needhand = FALSE, target = spell_target))
			return

	targeted_cast(spell_target)
	owner.wizard_power_system.spend_mana(mana_cost)
	return


/obj/effect/proc_holder/magic/click_on/proc/targeted_cast(atom/target)
//Depending on what we click, we call the appropriate proc.
//If we can't cast spell on type we click, but can cast spell on turf, we cast spell on turf, on which that object is standing
//So you won't, for example, be unable to create a forcewall because you clicked on vent, and not on turf with that vent
//Maybe I can make this a bit less ugly

	if(istype(target, /mob/living))
		if("mobs" in owner.wizard_power_system.chosen_spell.types_to_click)
			owner.wizard_power_system.chosen_spell.cast_on_mob(target)
		else if("turfs" in owner.wizard_power_system.chosen_spell.types_to_click)
			owner.wizard_power_system.chosen_spell.cast_on_turf(get_turf(target))
	else if(istype(target, /obj))
		if("objects" in owner.wizard_power_system.chosen_spell.types_to_click)
			owner.wizard_power_system.chosen_spell.cast_on_object(target)
		else if("turfs" in owner.wizard_power_system.chosen_spell.types_to_click)
			owner.wizard_power_system.chosen_spell.cast_on_turf(get_turf(target))
	else if(isturf(target) && ("turfs" in owner.wizard_power_system.chosen_spell.types_to_click))
		owner.wizard_power_system.chosen_spell.cast_on_turf(target)

/obj/effect/proc_holder/magic/click_on/proc/cast_on_mob(mob/living/target)
	return

/obj/effect/proc_holder/magic/click_on/proc/cast_on_object(obj/target)
	return

/obj/effect/proc_holder/magic/click_on/proc/cast_on_turf(turf/target)
	return


/obj/effect/proc_holder/magic/click_on/shoot
	var/projectile


/obj/effect/proc_holder/magic/click_on/shoot/targeted_cast(atom/target)
	if(!can_cast())
		return

	if(istype(target, /turf))		//This fixes bug of projectile just remaining in the air, if caster tries to shoot on his own turf
		var/turf/targetturf = target
		if(owner.current.TurfAdjacent(targetturf))
			return

	var/obj/item/projectile/P = new projectile(owner.current.loc)
	P.Fire(target, owner.current)


