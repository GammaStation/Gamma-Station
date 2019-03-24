//allows right clicking mobs to send an admin PM to their client, forwards the selected mob's client to cmd_admin_pm
/client/proc/cmd_admin_pm_context(mob/M as mob in mob_list)
	set category = null
	set name = "Admin PM Mob"
	if(!check_rights(R_ADMIN))
		to_chat(src, "<font color='red'>Error: Admin-PM-Context: Only administrators may use this command.</font>")
		return
	if( !ismob(M) || !M.client )	return
	cmd_admin_pm(M.client,null)
	feedback_add_details("admin_verb","APMM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//shows a list of clients we could send PMs to, then forwards our choice to cmd_admin_pm
/client/proc/cmd_admin_pm_panel()
	set category = "Admin"
	set name = "Admin PM"
	if(!check_rights(R_ADMIN))
		to_chat(src, "<font color='red'>Error: Admin-PM-Panel: Only administrators may use this command.</font>")
		return
	var/list/client/targets[0]
	for(var/client/T)
		if(T.mob)
			if(isnewplayer(T.mob))
				targets["(New Player) - [T]"] = T
			else if(isobserver(T.mob))
				targets["[T.mob.name](Ghost) - [T]"] = T
			else
				targets["[T.mob.real_name](as [T.mob.name]) - [T]"] = T
		else
			targets["(No Mob) - [T]"] = T
	var/list/sorted = sortList(targets)
	var/target = input(src,"To whom shall we send a message?","Admin PM",null) in sorted|null
	cmd_admin_pm(targets[target],null)
	feedback_add_details("admin_verb","APM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_ahelp_reply(whom)
	if(prefs.muted & MUTE_ADMINHELP || ((src in mentors) && (prefs.muted & MUTE_MENTORHELP)))
		to_chat(src, "<font color='red'>Error: Admin-PM: You are unable to use admin PM-s (muted).</font>")
		return
	var/client/C
	C = whom
	if(!C)
		if(holder)
			to_chat(src, "<font color='red'>Error: Admin-PM: Client not found.</font>")
		return
	if(usr.client in mentors)
		message_mentors("[key_name(src, 0, 0, 0)] has started replying to [key_name(C, 0, 0, 0)]'s help request.")
//	if(usr in mentors)
	message_admins("[key_name_admin(src)] has started replying to [key_name(C, 0, 0)]'s help request.")
	var/msg = sanitize(input(src,"Message:", "Private message to [key_name(C, 0, 0)]") as text|null)
	if (!msg)
		message_admins("[key_name_admin(src)] has cancelled their reply to [key_name(C, 0, 0)]'s help request.")
		if(usr.client in mentors)
			message_mentors("[key_name(src, 0, 0, 0)] has cancelled their reply to [key_name(C, 0, 0, 0)]'s help request.")
		return
	cmd_admin_pm(whom, msg)

//takes input from cmd_admin_pm_context, cmd_admin_pm_panel or /client/Topic and sends them a PM.
//Fetching a message if needed. src is the sender and C is the target client

/client/proc/cmd_admin_pm(client/C, msg = null, datum/ticket/ticket = null)
	if(prefs.muted & MUTE_ADMINHELP || ((src in mentors) && (prefs.muted & MUTE_MENTORHELP)))
		to_chat(src, "<font color='red'>Error: Private-Message: You are unable to use PM-s (muted).</font>")
		return

	if(!istype(C,/client))
		if(holder)
			to_chat(src, "<font color='red'>Error: Private-Message: Client not found.</font>")
		else
			adminhelp(msg)	//admin we are replying to left. adminhelp instead
		return

	//get message text, limit it's length.and clean/escape html
	if(!msg)
		msg = sanitize(input(src,"Message:", "Private message to [key_name(C, 0, holder ? 1 : 0, holder ? 1 : 0)]") as text|null)

		if(!msg)
			return
		if(!C)
			if(holder)
				to_chat(src, "<font color='red'>Error: Admin-PM: Client not found.</font>")
			else
				to_chat(src, "<span class='warning'>Error: Private-Message: Client not found. They may have lost connection, so try using an adminhelp!</span>")
//				adminhelp(msg)	//admin we are replying to has vanished, adminhelp instead
			return

	if (src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	var/datum/client_lite/receiver_lite = client_repository.get_lite_client(C)
	var/datum/client_lite/sender_lite = client_repository.get_lite_client(src)

	// searches for an open ticket, in case an outdated link was clicked
	// I'm paranoid about the problems that could be caused by accidentally finding the wrong ticket, which is why this is strict
	if(isnull(ticket))
		if(holder)
			ticket = get_open_ticket_by_client(receiver_lite) // it's more likely an admin clicked a different PM link, so check admin -> player with ticket first
			if(isnull(ticket) && C.holder)
				ticket = get_open_ticket_by_client(sender_lite) // if still no dice, try an admin with ticket -> admin
		else
			ticket = get_open_ticket_by_client(sender_lite) // lastly, check player with ticket -> admin

	if(isnull(ticket)) // finally, accept that no ticket exists
		if(holder && sender_lite.ckey != receiver_lite.ckey)
			ticket = new /datum/ticket(receiver_lite)
			ticket.take(sender_lite)
		else
			to_chat(src, "<span class='notice'>You do not have an open ticket. Please use the adminhelp verb to open a ticket.</span>")
			return
	else if(ticket.status != TICKET_ASSIGNED && sender_lite.ckey == ticket.owner.ckey)
		to_chat(src, "<span class='notice'>Your ticket is not open for conversation. Please wait for an administrator to receive your adminhelp.</span>")
		return

	// if the sender is an admin and they're not assigned to the ticket, ask them if they want to take/join it, unless the admin is responding to their own ticket
	if(holder && !(sender_lite.ckey in ticket.assigned_admin_ckeys()))
		if(sender_lite.ckey != ticket.owner.ckey && !ticket.take(sender_lite))
			return

	var/recieve_color = "purple"
	var/send_pm_type = " "
	var/recieve_pm_type = "Player"


	if(holder)
		//mentor PMs are maroon
		//PMs sent from admins display their rank
		if(C.holder && (holder.rights & R_ADMIN))
			recieve_color = "red"
		else
			recieve_color = "maroon"
		send_pm_type = holder.rank + " "
		if(!C.holder && holder && holder.fakekey)
			recieve_pm_type = "Admin"
		else
			recieve_pm_type = holder.rank
	else if(src in mentors)
		recieve_color = "maroon"
		send_pm_type = "Mentor "
		recieve_pm_type = "Mentor"
	else if(!C.holder && !(C in mentors))
		to_chat(src, "<font color='red'>Error: Admin-PM: Non-admin to non-admin PM communication is forbidden.</font>")
		return

	var/recieve_message = ""

	if(((src in mentors) || holder) && !C.holder)
		recieve_message = "<font color='[recieve_color]' size='3'><b>-- Click the [recieve_pm_type]'s name to reply --</b></font>\n"
		if(C.adminhelped)
			to_chat(C, recieve_message)
			C.adminhelped = 0

		//AdminPM popup for ApocStation and anybody else who wants to use it. Set it with POPUP_ADMIN_PM in config.txt ~Carn
		if(config.popup_admin_pm)
			spawn(0)	//so we don't hold the caller proc up
				var/sender = src
				var/sendername = key
				var/reply = sanitize(input(C, msg,"[recieve_pm_type] PM from-[sendername]", "") as text|null)		//show message and await a reply
				if(C && reply)
					if(sender)
						C.cmd_admin_pm(sender,reply)										//sender is still about, let's reply to them
					else
						adminhelp(reply)													//sender has left, adminhelp instead
				return

	recieve_message = "<font color='[recieve_color]'>[recieve_pm_type] PM from-<b>[get_options_bar(src, C.holder ? 1 : 0, C.holder ? 1 : 0, 1)]</b>: <span class='emojify linkify'>[msg]</span></font>"
	to_chat(C, recieve_message)
	to_chat(src, "<font color='blue'>[send_pm_type]PM to-<b>[get_options_bar(C, holder ? 1 : 0, holder ? 1 : 0, 1)]</b>: <span class='emojify linkify'>[msg]</span></font>")

	//play the recieving admin the adminhelp sound (if they have them enabled)
	//non-admins shouldn't be able to disable this
	if(C.prefs && C.prefs.toggles & SOUND_ADMINHELP)
		C << 'sound/effects/adminhelp.ogg'

	log_admin("PM: [key_name(src)]->[key_name(C)]: [msg]")
	send2slack_logs("[key_name(src)]->[key_name(C)]",  msg, "(PM)")

	ticket.msgs += new /datum/ticket_msg(src.ckey, C.ckey, msg)
	update_ticket_panels()

	//we don't use message_admins here because the sender/receiver might get it too
	for(var/client/X in admins)
		//check client/X is an admin and isn't the sender or recipient
		if(X == C || X == src)
			continue
		if(X.key != key && X.key != C.key && X.holder.rights & R_ADMIN)
			to_chat(X, "<B><font color='blue'>PM: [key_name(src, X, 0)]-&gt;[key_name(C, X, 0)]:</B> <span class='emojify linkify'>[msg]</span></font>")//inform X
	for(var/client/X in mentors)
		if(X == C || X == src)
			continue
		if(X.key != key && X.key != C.key && !C.holder && !src.holder)
			to_chat(X, "<B><font color='blue'>PM: [key_name(src, X, 0, 0)]-&gt;[key_name(C, X, 0, 0)]:</B> <span class='emojify linkify'>[msg]</span></font>")//inform X

/client/proc/cmd_admin_irc_pm()
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<font color='red'>Error: Private-Message: You are unable to use PM-s (muted).</font>")
		return

	var/msg = sanitize(input(src,"Message:", "Private message to admins on IRC / 400 character limit") as text|null)

	if(!msg)
		return

	if(length(msg) > 400) // TODO: if message length is over 400, divide it up into seperate messages, the message length restriction is based on IRC limitations.  Probably easier to do this on the bots ends.
		to_chat(src, "\red Your message was not sent because it was more then 400 characters find your message below for ease of copy/pasting")
		to_chat(src, "\blue [msg]")
		return

	to_chat(src, "<font color='blue'>IRC PM to-<b>IRC-Admins</b>: [msg]</font>")

	log_admin("PM: [key_name(src)]->IRC: [msg]")
	for(var/client/X in admins)
		if(X == src)
			continue
		if(X.holder.rights & R_ADMIN)
			to_chat(X, "<B><font color='blue'>PM: [key_name(src, X, 0)]-&gt;IRC-Admins:</B> \blue [msg]</font>")

