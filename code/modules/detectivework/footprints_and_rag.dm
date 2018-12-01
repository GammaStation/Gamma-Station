/mob
	var/bloody_hands = 0
	var/mob/living/carbon/human/bloody_hands_mob
	var/track_blood = 0
	var/list/feet_blood_DNA
	var/track_blood_type
	var/datum/dirt_cover/feet_dirt_color

/obj/item/clothing/gloves
	var/transfer_blood = 0
	var/mob/living/carbon/human/bloody_hands_mob

/obj/item/clothing/shoes/
	var/track_blood = 0

/obj/item/weapon/reagent_containers/glass/rag
	name = "damp rag"
	desc = "For cleaning up messes, you suppose."
	w_class = 1
	icon = 'icons/obj/toy.dmi'
	icon_state = "rag"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5)
	volume = 5
	can_be_placed_into = null

/obj/item/weapon/reagent_containers/glass/rag/attack_self(mob/user)
	return

/obj/item/weapon/reagent_containers/glass/rag/attack(atom/target, mob/user , flag)
	if(ismob(target) && target.reagents && reagents.total_volume)
		user.visible_message("<span class='warning'>The [target] has been smothered with the [src] by the [user]!</span>", "<span class='warning'> You smother the [target] with the [src]!</span>", "You hear some struggling and muffled cries of surprise")
		src.reagents.reaction(target, TOUCH)
		spawn(5) src.reagents.clear_reagents()
		return
	else
		..()

/obj/item/weapon/reagent_containers/glass/rag/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return
	if(user.is_busy()) return
	if(!istype(A, /obj/item/weapon/reagent_containers/food/drinks/drinkingglass) && A in user.client.screen)
		to_chat(user, "<span class='notice'>You need to take that [A] off before cleaning it.</span>")
	else if(istype(A) && src in user)
		user.visible_message("[user] starts to wipe down [A] with [src]!")
		if((istype(A, /obj/item/weapon/reagent_containers/food/drinks/drinkingglass) && do_after(user,30,target = user)) || (!istype(A,/obj/item/weapon/reagent_containers/food/drinks/drinkingglass) && do_after(user,30,target = A)))
			user.visible_message("[user] finishes wiping off the [A]!")
			A.clean_blood()
	return

/obj/item/weapon/reagent_containers/glass/rag/examine()
	if (!usr)
		return
	to_chat(usr, "That's \a [src].")
	to_chat(usr, desc)
	return
