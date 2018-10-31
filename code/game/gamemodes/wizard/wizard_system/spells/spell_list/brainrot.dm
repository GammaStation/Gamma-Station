/obj/effect/proc_holder/magic/click_on/brainrot
	name = "Brainrot"
	desc = ""
	delay = BRAINROT_DELAY
	mana_cost = BRAINROT_MANACOST
	types_to_click = list("mobs")


/obj/effect/proc_holder/magic/click_on/brainrot/spell_specific_checks(atom/target)
	. = ..()
	if(!istype(target, /mob))		//So no message spam on missclicks
		return FALSE

	if(!ishuman(target))
		to_chat(owner.current, "<font color = 'purple'><span class = 'bold'>I can't influence this creature's mind!</span></font>")
		return FALSE


/obj/effect/proc_holder/magic/click_on/brainrot/cast_on_mob(mob/living/carbon/human/target)
	if(ismindshielded(target))
		to_chat(target, "<span class='danger'>Your mindshield implant suddenly beeps!</span>")
		to_chat(owner.current, "<font color = 'purple'><span class = 'bold'>Something prevents my magic to affect this creature's brain!</span></font>")
		return

	switch(owner.current.a_intent)
		if("help")
			target.AdjustStunned(-BRAINROT_STUN_REDUCTION)
			target.AdjustWeakened(-BRAINROT_STUN_REDUCTION)
			target.AdjustParalysis(-BRAINROT_STUN_REDUCTION)
			target.halloss = max(target.halloss - BRAINROT_HALLOSS_REDUCTION, 0)
			target.shock_stage = max(target.shock_stage - BRAINROT_PAIN_REDUCTION, 0)
			to_chat(target, "<font color = 'blue'>You suddenly feel a strange surge of vigor!</font>")
		if("disarm")
			if(!target.eye_blind || !target.ear_deaf)
				to_chat(target, "<font color = 'red'>Suddenly, you vision becomes more and more dark. All sounds become more and more distant...</font>")
			target.eye_blind += BRAINROT_BLIND
			target.ear_deaf += BRAINROT_DEAF
		if("hurt")
			target.apply_effect(BRAINROT_PAIN, AGONY)
			target.flash_weak_pain()
			target.emote("scream",,, 1)
			to_chat(target, "\red <font size=5>You feel excrutiating pain all over your body!</font>")
		if("grab")
			target.silent += BRAINROT_SILENCE
	target.adjustBrainLoss(BRAINROT_BRAIN_DAMAGE)


#undef BRAINROT_DELAY
#undef BRAINROT_MANACOST
#undef BRAINROT_STUN_REDUCTION
#undef BRAINROT_HALLOSS_REDUCTION
#undef BRAINROT_PAIN_REDUCTION
#undef BRAINROT_BLIND
#undef BRAINROT_DEAF
#undef BRAINROT_PAIN
#undef BRAINROT_SILENCE
#undef BRAINROT_BRAIN_DAMAGE