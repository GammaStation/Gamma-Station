/obj/effect/proc_holder/magic/nondirect/emp
	name = "Electromagnetic distortion"
	desc = ""
	delay = 30
	mana_cost = 0


/obj/effect/proc_holder/magic/nondirect/emp/cast()
	owner.current.tesla_ignore = TRUE
	message_admins("[usr] ([usr.ckey]) used EMP spell at [get_area(usr)].(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
	log_game("usr] ([usr.ckey]) used EMP spell at [get_area(usr)]")
	empulse(owner.current.loc, 4, 7)
	for(var/mob/living/carbon/human/H in view (owner.current, 7))
		if(H.w_uniform.wet)
			H.electrocute_act(10, H.w_uniform, def_zone = pick(BP_CHEST , BP_GROIN))
		if(H.wear_suit.wet)
			H.electrocute_act(10, H.wear_suit, def_zone = BP_CHEST)
		if(H.head.wet)
			H.electrocute_act(10, H.head, def_zone = BP_HEAD)