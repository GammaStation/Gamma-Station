//Checks if the item is being held by a mob, and if so, updates the held icons
/obj/item/proc/update_twohanding()
	update_held_icon()

/obj/item/proc/update_held_icon()
	if(ismob(src.loc))
		var/mob/M = src.loc
		if(M.l_hand == src)
			M.update_inv_l_hand()
		else if(M.r_hand == src)
			M.update_inv_r_hand()

/obj/item/proc/is_held_twohanded(mob/living/M)

	var/check_hand
	if(M.l_hand == src && !M.r_hand)
		check_hand = BP_R_ARM //item in left hand, check right hand
	else if(M.r_hand == src && !M.l_hand)
		check_hand = BP_L_ARM //item in right hand, check left hand
	else
		return FALSE

	//would check is_broken() and is_malfunctioning() here too but is_malfunctioning()
	//is probabilistic so we can't do that and it would be unfair to just check one.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/hand = H.bodyparts_by_name[check_hand]
		if(istype(hand) && hand.is_usable())
			return TRUE
	return FALSE