/obj/effect/proc_holder/magic/nondirect/fair_exchange
	name = "Fair exchange"
	desc = ""
	mana_cost = 0
	delay = 0

//NODROP items


/obj/effect/proc_holder/magic/nondirect/fair_exchange/cast()
	var/obj/item/old_item = owner.current.get_active_hand()
	if(old_item)
		owner.current.drop_item()
		var/obj/item/new_item = pick(subtypesof(old_item.parent_type))
		var/obj/item/to_put_in_hand = new new_item(owner.current.loc)
		owner.current.put_in_active_hand(to_put_in_hand)
		qdel(old_item)