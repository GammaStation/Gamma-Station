/obj/effect/proc_holder/magic/click_on/haze
	name = "White haze"
	desc = ""
	delay = HAZE_DELAY
	mana_cost = HAZE_MANACOST
	types_to_click = list("turfs")

/obj/effect/proc_holder/magic/click_on/haze/check_turf_cast(turf/target)
	if(is_blocked_turf(target))
		return TRUE

/obj/effect/proc_holder/magic/click_on/haze/cast_on_turf(turf/target)
	var/datum/effect/effect/system/smoke_spread/white_haze/S = new
	S.attach(target)
	S.set_up(10, 0, target)
	S.start()


/datum/effect/effect/system/smoke_spread/white_haze
	smoke_type = /obj/effect/effect/smoke/white_haze


/obj/effect/effect/smoke/white_haze
	name = "strange haze"
	alpha = 0
	opacity = FALSE
	time_to_live = HAZE_LINGER_TIME
	var/power = 0


/obj/effect/effect/smoke/white_haze/atom_init()
	. = ..()
	var/icon/I = icon('icons/effects/chemsmoke.dmi')
	I += "#FFFFFF"
	icon = I
	animate(src, alpha = 255, time = 50)
	START_PROCESSING(SSobj, src)


/obj/effect/effect/smoke/white_haze/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)


/obj/effect/effect/smoke/white_haze/affect(atom/A)
	if(ismob(A))
		var/mob/living/M = A
		M.take_bodypart_damage(HAZE_DAMAGE_MULT*power)
		if(ishuman(M))
			M.adjustCloneLoss(HAZE_DAMAGE_MULT*power)
			if(power > 2)
				M.emote("scream",,, 1)

			if(prob(power*4))
				var/bodypart = pick(list(BP_R_ARM , BP_L_ARM , BP_R_LEG , BP_L_LEG))
				var/mob/living/carbon/human/H = M
				var/obj/item/organ/external/BP = H.bodyparts_by_name[bodypart]
				if (BP && !(BP.status & ORGAN_DESTROYED))
					BP.droplimb(no_explode = FALSE, clean = TRUE, disintegrate = DROPLIMB_BLUNT)

		else if(issilicon(M))
			M.emp_act(max(3-power,1))
	else if(istype(A, /obj/item))
		var/obj/item/O = A
		if(!O.unacidable)
			if(prob(20))
				if(prob(50))
					new /obj/effect/decal/cleanable/ash(O.loc)
				qdel(O)


/obj/effect/effect/smoke/white_haze/process()
	if(power < 4)
		++power

	if(power == 2)
		opacity = TRUE

	for(var/atom/A in get_turf(src))
		affect(A)

/*
for(var/obj/item/I in H.contents)
			if(istype(I, /obj/item/weapon/implant))
				continue
			I.make_wet()
*/

#undef HAZE_MANACOST
#undef HAZE_DELAY
#undef HAZE_DAMAGE_MULT
#undef HAZE_LINGER_TIME
