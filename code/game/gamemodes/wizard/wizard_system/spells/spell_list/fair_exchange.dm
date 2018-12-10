/obj/effect/proc_holder/magic/nondirect/fair_exchange
	name = "Fair exchange"
	desc = ""
	mana_cost = EXCHANGE_MANACOST
	delay = EXCHANGE_DELAY
	var/obj/item/item_to_transform


/obj/effect/proc_holder/magic/nondirect/fair_exchange/spell_specific_checks()
	var/obj/item/old_item = owner.current.get_active_hand()
	if(!old_item)
		return TRUE

	if(old_item.flags & ABSTRACT || old_item.flags & NODROP)
		return TRUE

	item_to_transform = old_item


/obj/effect/proc_holder/magic/nondirect/fair_exchange/cast()
	playsound(owner.current.loc, 'sound/effects/phasein.ogg', 100, 1)
	for(var/mob/living/carbon/human/M in viewers(owner.current))
		if(M:eyecheck() <= 0)
			M.flash_eyes()

	var/obj/item/new_item
	if(item_to_transform.parent_type == /obj/item || item_to_transform.parent_type == /obj/item/weapon)
		new_item = safepick(subtypesof(item_to_transform))
	else
		new_item = safepick(subtypesof(item_to_transform.parent_type) - item_to_transform.type)

	if(!new_item)
		to_chat(owner.current, "<font color='purple'><i>The spell failed! There is no equivalent of this item in the parallel dimension!</i></font>")
		return

	var/obj/item/to_put_in_hand = new new_item(owner.current.loc)
	owner.current.drop_item()
	owner.current.put_in_hands(to_put_in_hand)
	message_admins("[usr] ([usr.ckey]) transformed [item_to_transform] into [to_put_in_hand].(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
	qdel(item_to_transform)

#undef EXCHANGE_MANACOST
#undef EXCHANGE_DELAY