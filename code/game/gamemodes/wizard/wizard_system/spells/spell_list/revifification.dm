/obj/effect/proc_holder/magic/click_on/revivification
	name = "Borgnjor's revivification"
	desc = ""
	delay = REVIVE_DELAY
	mana_cost = REVIVE_MANACOST
	types_to_click = list("mobs")
	closerange = TRUE

//Maybe non-contagious zombies instead of skeletons?

/obj/effect/proc_holder/magic/click_on/revivification/check_mob_cast(mob/living/carbon/human/target)
	if(!ishuman(target))
		to_chat(owner.current, "<font color = 'purple'><i>I can't cast this spell on non humans!</i></font>")
		return TRUE
	if(target.species.name == SKELETON)
		to_chat(owner.current, "<font color = 'purple'><i>Even Borgnjor couldn't think of a way to heal this!</i></font>")
		return
	if(target.stat == DEAD)
		if(!target.mind || !target.client)
			to_chat(owner.current, "<font color = 'purple'><i>There is no soul connected to this body...</i></font>")
			return

/obj/effect/proc_holder/magic/click_on/revivification/cast_on_mob(mob/living/carbon/human/target)
	if(target.stat != DEAD)
		target.heal_overall_damage(200, 200)
		for(var/obj/item/organ/external/E in target.bodyparts)
			if(prob(25))
				E.germ_level += pick(INFECTION_LEVEL_ONE, INFECTION_LEVEL_ONE_PLUS, INFECTION_LEVEL_ONE_PLUS_PLUS)
				target.bad_bodyparts += E
	else
		target.set_species(SKELETON)
		target.revive()
		to_chat(target, "<span class='userdanger'>You have been revived by </span><B>[owner.current.real_name]!</B>")
		to_chat(target, "<span class='userdanger'>[owner.current.real_name] your master now, assist them even if it costs you your new life!</span>")
//		equip_roman_skeleton(target)
		target.regenerate_icons()

