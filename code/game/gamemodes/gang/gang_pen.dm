/*
 * Gang Boss Pens
 */
/obj/item/weapon/pen/gang
	origin_tech = "materials=2;syndicate=5"
	var/cooldown
	var/last_convert_time

/obj/item/weapon/pen/gang/attack(mob/living/M, mob/user)
	if(!istype(M))
		return
	if(!ismob(M))
		return

	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been stabbed with [name]  by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [name] to stab [M.name] ([M.ckey])</font>")
	msg_admin_attack("[user.name] ([user.ckey]) Used the [name] to stab [M.name] ([M.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	if(ishuman(M) && ishuman(user) && M.stat != DEAD)
		if(user.mind && ((user.mind in ticker.mode.A_bosses) || (user.mind in ticker.mode.B_bosses)))
			if(!M.mind || !M.client)
				return //He is fucking braindead
			if(world.time <(last_convert_time + cooldown))
				to_chat(user, "<span class='warning'>[src] needs more time to recharge before it can be used.</span>")
				return
			var/gang_letter
			if(user.mind in ticker.mode.A_bosses)
				gang_letter = "A"
			else if(user.mind in ticker.mode.B_bosses)
				gang_letter = "B"
			var/choice = alert(M,"Asked by [user]: Do you want to join the gang?","Align Thyself with the gang!","No!","Yes!")
			if(choice == "Yes!")
				var/recruitable = ticker.mode.add_gangster(M.mind, gang_letter)
				switch(recruitable)
					if(2)
						if(gang_letter == "A")
							cooldown = max(100,((ticker.mode.A_gang.len - ticker.mode.B_gang.len)*400))
						else if (gang_letter == "B")
							cooldown = max(100,((ticker.mode.A_gang.len - ticker.mode.B_gang.len)*400))
						last_convert_time = world.time
						icon_state = "pen_blink"
						addtimer(CALLBACK(src, .proc/cooldown_end),cooldown)
						to_chat(M, "<span class='notice'>You join the gang!</span>")
						to_chat(user, "<span class='warning'>[M] joins the gang!</span>")
					if(1)
						to_chat(user, "<span class='warning'>This mind is resistant to recruitment!</span>")
					else
						to_chat(user, "<span class='warning'>This mind has already been recruited into a gang!</span>")
			else if(choice == "No!")
				to_chat(M, "<span class='warning'>You reject this offer!</span>")
				to_chat(user, "<span class='warning'>[M] rejected your offer!</span>")

/obj/item/weapon/pen/gang/proc/cooldown_end()
	icon_state = "pen"
	var/mob/M = get(src, /mob)
	to_chat(M, "<span class='notice'>[bicon(src)] [src][(src.loc == M)?(""):(" in your [src.loc]")] vibrates softly.</span>")
