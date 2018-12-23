/obj/item/weapon
	name = "weapon"
	icon = 'icons/obj/weapons.dmi'
	var/wielded = FALSE
	var/force_unwielded = 0
	var/force_wielded = 0
	var/wieldsound = null
	var/unwieldsound = null
	var/obj/item/weapon/twohanded/offhand/offhand_item = /obj/item/weapon/twohanded/offhand
	var/wielded_righthand_file = 'icons/mob/inhands/weapons_wielded_righthand.dmi'
	var/wielded_lefthand_file = 'icons/mob/inhands/weapons_wielded_lefthand.dmi'
	var/wielded_state = null

/obj/item/weapon/attack_self(mob/user)
	if(can_be_wielded())
		if(istype(user,/mob/living/carbon/monkey))
			to_chat(user, "<span class='warning'>It's too heavy for you to wield fully.</span>")
			return
		change_grip(user)
	..()

/obj/item/weapon/proc/change_grip(mob/living/user)
	if(wielded)
		to_chat(user, "<span class='notice'>You are now carrying the [name] with one hand.</span>")
		if(user.hand)
			user.update_inv_l_hand()
		else
			user.update_inv_r_hand()
		var/obj/item/weapon/twohanded/offhand/O = user.get_inactive_hand()
		if(istype(O))
			user.drop_from_inventory(O)
		unwield()
	else
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			var/W = H.wield(src, initial(name))
			if(W)
				wield()

/obj/item/weapon/pickup(mob/user)
	if(can_be_wielded())
		unwield()
		grant_actions(user)
	return ..()

/obj/item/weapon/dropped(mob/user)
	if(!can_be_wielded())
		return ..()
	if(user)
		var/obj/item/weapon/twohanded/O = user.get_inactive_hand()
		if(istype(O))
			user.drop_from_inventory(O)
		remove_actions(user)
	return unwield()

/obj/item/weapon/mob_can_equip(M, slot)
	if(wielded)
		to_chat(M, "<span class='warning'>Unwield the [initial(name)] first!</span>")
		return FALSE

	return ..()

/obj/item/weapon/proc/wield()//Left this in case someone would like to inherit and change smthng
	wielded = TRUE
	force = force_wielded
	name = "[initial(name)] (Wielded)"
	lefthand_file = wielded_lefthand_file
	righthand_file = wielded_righthand_file

	update_icon()

/obj/item/weapon/proc/unwield()//Left this in case someone would like to inherit and change smthng
	wielded = FALSE
	force = force_unwielded
	name = "[initial(name)]"
	lefthand_file = initial(lefthand_file)
	righthand_file = initial(righthand_file)
	update_icon()

/obj/item/weapon/MouseDrop(obj/over)
	var/mob/M = usr
	if (src.loc != usr)
		return
	if (!over)
		return
	if (!usr.restrained() && !usr.stat)
		switch(over.name)
			if("r_hand")
				if(!M.unEquip(src))
					return
				M.put_in_r_hand(src)
			if("l_hand")
				if(!M.unEquip(src))
					return
				M.put_in_l_hand(src)

/obj/item/weapon/proc/can_be_wielded()
	return FALSE

////Offhand slotholder

/obj/item/weapon/twohanded/offhand
	w_class = 5.0
	icon_state = "offhand"
	name = "offhand"
	flags = ABSTRACT|DROPDEL

/obj/item/weapon/twohanded/offhand/unwield()
	qdel(src)

/obj/item/weapon/twohanded/offhand/wield()
	qdel(src)

/obj/item/weapon/twohanded/offhand/dropped(mob/user)
	var/obj/item/weapon/G = user.get_inactive_hand()
	if(istype(G))
		to_chat(user, "<span class='notice'>You are now carrying the [name] with one hand.</span>")
		G.unwield()
	..()

/obj/item/weapon/twohanded/offhand/throw_at(atom/target, range, speed, mob/thrower, spin = TRUE, diagonals_first = FALSE, datum/callback/callback)
	dropped(thrower)