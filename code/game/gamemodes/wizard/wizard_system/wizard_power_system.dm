proc/iswizard(mob/living/M)
	return ishuman(M) && M.mind && (M.mind.wizard_power_system)

/datum/wizard_powers
	var/list/learned_schools = list()
	var/list/passive_abilities = list()
	var/list/spells = list()
	var/mana = WIZARD_MAX_MANA		//3000
	var/maxmana = WIZARD_MAX_MANA		//3000
	var/mana_regen = WIZARD_MANA_REGEN
	var/obj/effect/proc_holder/magic/click_on/chosen_spell

/datum/wizard_powers/New()
	START_PROCESSING(SSobj, src)

/datum/wizard_powers/process()
	mana = Clamp(mana + mana_regen, 0, maxmana)
	mana_regen = Clamp(mana_regen + WIZARD_MANA_REGEN_GROWTH, 0, WIZARD_MANA_REGEN_TRESHOLD)

/datum/wizard_powers/proc/spend_mana(var/amount)
	mana -= amount
	mana_regen = WIZARD_MANA_REGEN


/datum/mind/proc/make_wizard()
	special_role = "Wizard"
	wizard_power_system = new /datum/wizard_powers
	ticker.mode.wizards += src

/datum/mind/proc/remove_wizard()
	ticker.mode.wizards -= src
	QDEL_NULL(wizard_power_system)

/datum/mind/proc/add_spell(var/obj/effect/proc_holder/magic/spell)
	if(!iswizard(current))
		return
	else
		var/obj/effect/proc_holder/magic/spell_to_add = new spell
		spell_to_add.owner = src
		wizard_power_system.spells += spell_to_add

/datum/mind/proc/add_all_spells()
	for(var/spell in magic_spells)
		add_spell(spell)


/datum/mind/proc/remove_spell(var/obj/effect/proc_holder/magic/spell)
	if(iswizard(current))
		wizard_power_system.spells -= spell
	qdel(spell)


/mob/living/carbon/human/proc/get_clothes_strength()
	var/robestrength = 0
	if(!istype(wear_suit, /obj/item/clothing/suit/wizrobe))
		return FALSE
	else
		++robestrength

	if(istype(shoes, /obj/item/clothing/shoes/sandal))
		++robestrength
	if(istype(head, /obj/item/clothing/head/wizard))
		++robestrength

	return robestrength


/mob/living/proc/spellremove(mob/M)		//SLATED FOR REMOVAL
	for(var/obj/effect/proc_holder/magic/spell_to_remove in src.spell_list)
		qdel(spell_to_remove)
	spell_list.Cut()
	mind.spell_list.Cut()

#undef WIZARD_MAX_MANA
#undef WIZARD_MANA_REGEN
#undef WIZARD_MANA_REGEN_GROWTH
#undef WIZARD_MANA_REGEN_TRESHOLD


