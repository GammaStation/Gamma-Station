/obj/effect/proc_holder/magic/click_on/deteriorate
	name = "Deteriorate"
	desc = ""
	mana_cost = DETERIORATE_MANACOST
	types_to_click = list("mobs", "objects")

/obj/effect/proc_holder/magic/click_on/deteriorate/cast_on_mob(mob/living/target)
	playsound(target, 'sound/magic/curse5.ogg', 50, 1)
	for(var/obj/item/I in target.contents)
		if(I.flags & ABSTRACT)
			continue
		if(istype(I, /obj/item/weapon/implant))
			continue

		if(prob(25))
			if(!I.old)
				I.make_old()
			else
				new /obj/effect/decal/cleanable/ash(target.loc)
				qdel(I)

/obj/effect/proc_holder/magic/click_on/deteriorate/check_object_cast(obj/target)
	if(target.flags & ABSTRACT)
		return TRUE

/obj/effect/proc_holder/magic/click_on/deteriorate/cast_on_object(obj/target)
	if(!target.old)
		target.make_old()
	else
		new /obj/effect/decal/cleanable/ash(target.loc)
		qdel(target)

#undef DETERIORATE_MANACOST