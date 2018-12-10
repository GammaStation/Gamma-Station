/obj/effect/proc_holder/magic/click_on/tukima_dance
	name = "Tukima's dance"
	desc = ""
	mana_cost = DANCE_MANACOST
	types_to_click = list("mobs", "objects")


/obj/effect/proc_holder/magic/click_on/tukima_dance/check_mob_cast(mob/living/target)
	if(!target.get_active_hand())
		return TRUE

/obj/effect/proc_holder/magic/click_on/tukima_dance/check_object_cast(obj/item/target)
	if(is_type_in_list(target, protected_objects))
		return TRUE
	if(!istype(target, /obj/item) && !istype(target, /obj/structure))
		return TRUE

//Lifetime for mobs


/obj/effect/proc_holder/magic/click_on/tukima_dance/cast_on_mob(mob/living/target)
	if(istype(target, /mob/living/simple_animal/hostile/mimic/copy))
		var/mob/living/simple_animal/hostile/mimic/copy/C = target
		C.ChangeOwner(owner.current)
	else
		var/obj/item/item = target.get_active_hand()
		if(item)
			if(!check_object_cast(item))
				target.drop_item()
				cast_on_object(item)


/obj/effect/proc_holder/magic/click_on/tukima_dance/cast_on_object(obj/item/target)
	var/obj/O = target
	new /mob/living/simple_animal/hostile/mimic/copy(O.loc, O, owner.current)