/obj/effect/proc_holder/magic/nondirect/mark_recall
	name = "Mark & Recall"
	desc = ""
	mana_cost = 0
	delay = 0
	var/obj/item/marked_item

//istype check
//delete check
//
/obj/effect/proc_holder/magic/nondirect/mark_recall/can_cast()
	. = ..()
	if(!marked_item && !owner.current.get_active_hand())
		return FALSE

	else if(marked_item && QDELETED(marked_item))
		marked_item = null
		return FALSE

/obj/effect/proc_holder/magic/nondirect/mark_recall/cast()
	var/obj/item/item_in_hand = owner.current.get_active_hand()
	if(item_in_hand)
		to_chat(owner.current, "<font color='purple'><i>Item marked!</i></font>")
		marked_item = item_in_hand
	else
		owner.current.put_in_any_hand_if_possible(marked_item)