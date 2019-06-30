/obj/effect/proc_holder/magic/click_on/heal
	name = "Heal"
	desc = ""
	delay = 50
	mana_cost = 0
	types_to_click = list("mobs")
	closerange = TRUE

/obj/effect/proc_holder/magic/click_on/heal/check_mob_cast(mob/living/target)
	if(!ishuman(target))
		to_chat(owner.current, "<span class='wizard'>This spell works on humans only!</span>")
		return TRUE

	if(target.stat == DEAD)
		to_chat(owner.current, "<span class='wizard'>Such spell is unable to resurrect dead!</span>")
		return TRUE


/obj/effect/proc_holder/magic/click_on/heal/cast_on_mob(mob/living/carbon/human/target)
	var/hamt = -20
	target.cure_all_viruses()
	target.remove_any_mutations()
	target.apply_damages(hamt, hamt, hamt, hamt, hamt, hamt)
	target.apply_effects(hamt, hamt, hamt)		//So no "Your clothes feels warm"
