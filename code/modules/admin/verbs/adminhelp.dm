/client/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "\red Speech is currently admin-disabled.")
		return

	if(!mob || !msg)
		return	//this doesn't happen

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<font color='red'>Error: Admin-PM: You cannot send adminhelps (Muted).</font>")
		return
	if(src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

		// handle ticket
	var/datum/client_lite/client_lite = client_repository.get_lite_client(src)
	var/datum/ticket/ticket = get_open_ticket_by_client(client_lite)
	if(!ticket)
		ticket = new /datum/ticket(client_lite)
	else if(ticket.status == TICKET_ASSIGNED)
		// manually check that the target client exists here as to not spam the usr for each logged out admin on the ticket
		var/admin_found = 0
		for(var/datum/client_lite/admin in ticket.assigned_admins)
			var/client/admin_client = client_by_ckey(admin.ckey)
			if(admin_client)
				admin_found = 1
				src.cmd_admin_pm(admin_client, msg, ticket)
				break
		if(!admin_found)
			to_chat(src, "<span class='warning'>Error: Private-Message: Client not found. They may have lost connection, so please be patient!</span>")
		return

	ticket.msgs += new /datum/ticket_msg(src.ckey, null, msg)
	update_ticket_panels()

	staffhelp(msg, ticket, help_type = "AH")
