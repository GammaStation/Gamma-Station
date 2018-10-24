/obj/machinery/chem_master
	name = "ChemMaster 3000"
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0"
	use_power = 1
	idle_power_usage = 20
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/obj/item/weapon/storage/pill_bottle/loaded_pill_bottle = null
	var/mode = 1
	var/condi = 0
	var/useramount = 30 // Last used amount
	var/pillamount = 10
	var/bottlesprite = 1
	var/pillsprite = 1
	var/client/has_sprites = list()
	var/max_pill_count = 20


/obj/machinery/chem_master/atom_init()
	. = ..()
	var/datum/reagents/R = new/datum/reagents(100)
	reagents = R
	R.my_atom = src

/obj/machinery/chem_master/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return

/obj/machinery/chem_master/blob_act()
	if (prob(50))
		qdel(src)

/obj/machinery/chem_master/meteorhit()
	qdel(src)
	return

/obj/machinery/chem_master/power_change()
	if(powered())
		stat &= ~NOPOWER
	else
		spawn(rand(0, 15))
			stat |= NOPOWER

/obj/machinery/chem_master/attackby(obj/item/B, mob/user)

	if(default_unfasten_wrench(user, B))
		return

	if(istype(B, /obj/item/weapon/reagent_containers/glass))
		if(src.beaker)
			to_chat(user, "<span class='alert'>A beaker is already loaded into the machine.</span>")
			return
		src.beaker = B
		user.drop_item()
		B.loc = src
		to_chat(user, "You add the beaker to the machine!")
		src.updateUsrDialog()
		icon_state = "mixer1"

	else if(!condi && istype(B, /obj/item/weapon/storage/pill_bottle))
		if(src.loaded_pill_bottle)
			to_chat(user, "<span class='alert'>A pill bottle is already loaded into the machine.</span>")
			return

		src.loaded_pill_bottle = B
		user.drop_item()
		B.loc = src
		to_chat(user, "You add the pill bottle into the dispenser slot!")
		src.updateUsrDialog()

	return

/obj/machinery/chem_master/Topic(href, href_list)
	. = ..()
	if(!.)
		return
	if(href_list["ejectp"])
		if(loaded_pill_bottle)
			loaded_pill_bottle.loc = src.loc
			loaded_pill_bottle = null

	else if(href_list["close"])
		usr << browse(null, "window=chemmaster")
		usr.unset_machine()
		return FALSE

	else if(href_list["toggle"])
		mode = !mode

	else if(href_list["createbottle"])
		if(!condi)
			var/name = sanitize_safe(input(usr, "Name:","Name your bottle!", (reagents.total_volume ? reagents.get_master_reagent_name() : " ")), MAX_NAME_LEN)
			if(!name)
				return FALSE
			var/obj/item/weapon/reagent_containers/glass/bottle/P = new/obj/item/weapon/reagent_containers/glass/bottle(src.loc)
			P.name = "[name] bottle"
			P.icon_state = "bottle[bottlesprite]"
			P.pixel_x = rand(-7, 7) //random position
			P.pixel_y = rand(-7, 7)
			reagents.trans_to(P, 30)
		else
			var/obj/item/weapon/reagent_containers/food/condiment/P = new/obj/item/weapon/reagent_containers/food/condiment(src.loc)
			reagents.trans_to(P, 50)

	else if(href_list["changepill"])
		var/dat = "<B>Choose pill colour</B><BR>"

		dat += "<TABLE><TR>"
		for(var/i = 1 to MAX_PILL_SPRITE)
			if(!((i-1)%9)) //New row every 9 icons
				dat +="</TR><TR>"
			dat += "<TD><A href='?src=\ref[src];set=1;value=[i] '><IMG src=pill[i].png></A></TD>"
		dat += "</TR></TABLE>"

		dat += "<BR><A href='?src=\ref[src];main=1'>Back</A>"

		var/datum/browser/popup = new(usr, "chem_master", name)
		popup.set_content(dat)
		popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
		popup.open(1)
		return

	else if(href_list["changebottle"])
		var/dat = "<B>Choose bottle</B><BR>"

		dat += "<TABLE><TR>"
		for(var/i = 1 to MAX_BOTTLE_SPRITE)
			if(!((i-1)%9)) //New row every 9 icons
				dat += "</TR><TR>"
			dat += "<TD><A href='?src=\ref[src];set=2;value=[i] '><IMG src=bottle[i].png></A></TD>"

		dat += "</TR></TABLE>"

		dat += "<BR><A href='?src=\ref[src];main=1'>Back</A>"

		var/datum/browser/popup = new(usr, "chem_master", name)
		popup.set_content(dat)
		popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
		popup.open(1)
		return

	else if(href_list["set"])
		if(href_list["value"])
			if(href_list["set"] == "1")
				src.pillsprite = text2num(href_list["value"])
			else
				src.bottlesprite = text2num(href_list["value"])
		attack_hand(usr)
		return

	else if(href_list["main"]) // Used to exit the analyze screen.
		attack_hand(usr)
		return

	if(beaker)
		if(href_list["analyze"])
			if(locate(href_list["reagent"]))
				var/datum/reagent/R = locate(href_list["reagent"])
				if(R)
					var/dat = ""
					dat += "<H1>[condi ? "Condiment" : "Chemical"] information:</H1>"
					dat += "<B>Name:</B> [initial(R.name)]<BR><BR>"
					dat += "<B>State:</B> "
					if(initial(R.reagent_state) == 1)
						dat += "Solid"
					else if(initial(R.reagent_state) == 2)
						dat += "Liquid"
					else if(initial(R.reagent_state) == 3)
						dat += "Gas"
					else
						dat += "Unknown"
					dat += "<BR>"
					dat += "<B>Color:</B> <span style='color:[initial(R.color)];background-color:[initial(R.color)];font:Lucida Console'>[initial(R.color)]</span><BR><BR>"
					dat += "<B>Description:</B> [initial(R.description)]<BR><BR>"
					if(initial(R.name) == "Blood")
						var/datum/reagent/blood/G = R
						var/A = G.data["blood_type"]
						var/B = G.data["blood_DNA"]
						dat += "<B>Blood Type:</B> [A]<br>"
						dat += "<B>DNA:</B> [B]<BR><BR><BR>"
					var/const/P = 3 //The number of seconds between life ticks
					var/T = initial(R.custom_metabolism) * (60 / P)
					dat += "<B>Metabolization Rate:</B> [T]u/minute<BR>"
					dat += "<B>Overdose Threshold:</B> [initial(R.overdose) ? "[initial(R.overdose)]u" : "none"]<BR>"
					//dat += "<B>Addiction Threshold:</B> [initial(R.addiction_threshold) ? "[initial(R.addiction_threshold)]u" : "none"]<BR><BR>"
					dat += "<BR><A href='?src=\ref[src];main=1'>Back</A>"
					var/datum/browser/popup = new(usr, "chem_master", name)
					popup.set_content(dat)
					popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
					popup.open(1)
					return


		else if(href_list["add"])
			if(href_list["amount"])
				var/id = href_list["add"]
				var/amount = text2num(href_list["amount"])
				if (amount > 0)
					beaker.reagents.trans_id_to(src, id, amount)

		else if(href_list["addcustom"])
			var/id = href_list["addcustom"]
			var/amt_temp = isgoodnumber(input(usr, "Select the amount to transfer.", "Transfer how much?", useramount) as num|null)
			if(!amt_temp)
				return FALSE
			useramount = amt_temp
			if(useramount < 0)
				message_admins("[key_name_admin(usr)] tried to exploit a chemistry by entering a negative value: [useramount]</a> ! (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
				log_admin("EXPLOIT : [key_name(usr)] tried to exploit a chemistry by entering a negative value: [useramount] !")
				return FALSE
			if(useramount > 300)
				return FALSE
			src.Topic(null, list("amount" = "[useramount]", "add" = "[id]"))

		else if(href_list["remove"])
			if(href_list["amount"])
				var/id = href_list["remove"]
				var/amount = text2num(href_list["amount"])
				if (amount > 0)
					if(mode)
						reagents.trans_id_to(beaker, id, amount)
					else
						reagents.remove_reagent(id, amount)

		else if(href_list["removecustom"])
			var/id = href_list["removecustom"]
			var/amt_temp = isgoodnumber(input(usr, "Select the amount to transfer.", "Transfer how much?", useramount) as num|null)
			if(!amt_temp)
				return FALSE
			useramount = amt_temp
			if(useramount < 0)
				message_admins("[key_name_admin(usr)] tried to exploit a chemistry by entering a negative value: [useramount]</a> ! (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
				log_admin("EXPLOIT : [key_name(usr)] tried to exploit a chemistry by entering a negative value: [useramount] !")
				return FALSE
			if(useramount > 300)
				return FALSE
			src.Topic(null, list("amount" = "[useramount]", "remove" = "[id]"))

		else if(href_list["eject"])
			if(beaker)
				beaker.loc = src.loc
				beaker = null
				reagents.clear_reagents()
				icon_state = "mixer0"

		else if(href_list["createpill"]) //Also used for condiment packs.
			if(reagents.total_volume == 0)
				return FALSE
			if(!condi)
				var/amount = 1
				var/vol_each = min(reagents.total_volume, 50)
				if(text2num(href_list["many"]))
					amount = min(max(round(input(usr, "Max 10. Buffer content will be split evenly.", "How many pills?", amount) as num|null), 0), 10)
					if(!amount)
						return FALSE
					vol_each = min(reagents.total_volume / amount, 50)
				var/name = sanitize_safe(input(usr,"Name:","Name your pill!", "[reagents.get_master_reagent_name()] ([vol_each]u)"), MAX_NAME_LEN)
				if(!name || !reagents.total_volume)
					return FALSE
				var/obj/item/weapon/reagent_containers/pill/P

				for(var/i = 0; i < amount; i++)
					if(loaded_pill_bottle && loaded_pill_bottle.contents.len < loaded_pill_bottle.storage_slots)
						P = new/obj/item/weapon/reagent_containers/pill(loaded_pill_bottle)
					else
						P = new/obj/item/weapon/reagent_containers/pill(src.loc)
					P.name = "[name] pill"
					P.icon_state = "pill[pillsprite]"
					P.pixel_x = rand(-7, 7) //random position
					P.pixel_y = rand(-7, 7)
					reagents.trans_to(P,vol_each)

	src.updateUsrDialog()

/obj/machinery/chem_master/ui_interact(mob/user)
	if(!(user.client in has_sprites))
		spawn()
			has_sprites += user.client
			for(var/i = 1 to MAX_PILL_SPRITE)
				usr << browse_rsc(icon('icons/obj/chemical.dmi', "pill[i]"), "pill[i].png")
			for(var/i = 1 to MAX_BOTTLE_SPRITE)
				usr << browse_rsc(icon('icons/obj/chemical.dmi', "bottle[i]"), "bottle[i].png")
			src.updateUsrDialog()

	var/dat = ""
	if(beaker)
		dat += "Beaker \[[beaker.reagents.total_volume]/[beaker.volume]\] <A href='?src=\ref[src];eject=1'>Eject and Clear Buffer</A><BR>"
	else
		dat = "Please insert beaker.<BR>"

	dat += "<HR><B>Add to buffer:</B><UL>"
	if(beaker)
		if(beaker.reagents.total_volume)
			for(var/datum/reagent/G in beaker.reagents.reagent_list)
				dat += "<LI>[G.name], [G.volume] Units - "
				dat += "<A href='?src=\ref[src];analyze=1;reagent=\ref[G]'>Analyze</A> "
				dat += "<A href='?src=\ref[src];add=[G.id];amount=1'>1</A> "
				dat += "<A href='?src=\ref[src];add=[G.id];amount=5'>5</A> "
				dat += "<A href='?src=\ref[src];add=[G.id];amount=10'>10</A> "
				dat += "<A href='?src=\ref[src];add=[G.id];amount=[G.volume]'>All</A> "
				dat += "<A href='?src=\ref[src];addcustom=[G.id]'>Custom</A>"
		else
			dat += "<LI>Beaker is empty."
	else
		dat += "<LI>No beaker."

	dat += "</UL><HR><B>Transfer to <A href='?src=\ref[src];toggle=1'>[(!mode ? "disposal" : "beaker")]</A>:</B><UL>"
	if(reagents.total_volume)
		for(var/datum/reagent/N in reagents.reagent_list)
			dat += "<LI>[N.name], [N.volume] Units - "
			dat += "<A href='?src=\ref[src];analyze=1;reagent=\ref[N]'>Analyze</A> "
			dat += "<A href='?src=\ref[src];remove=[N.id];amount=1'>1</A> "
			dat += "<A href='?src=\ref[src];remove=[N.id];amount=5'>5</A> "
			dat += "<A href='?src=\ref[src];remove=[N.id];amount=10'>10</A> "
			dat += "<A href='?src=\ref[src];remove=[N.id];amount=[N.volume]'>All</A> "
			dat += "<A href='?src=\ref[src];removecustom=[N.id]'>Custom</A>"
	else
		dat += "<LI>Buffer is empty."
	dat += "</UL><HR>"


	dat += "<A href='?src=\ref[src];changepill=1'><img src='pill[src.pillsprite].png'></A>"
	dat += "<A href='?src=\ref[src];changebottle=1'><img src='bottle[src.bottlesprite].png'></A>"


	dat += "<HR>"
	if(!condi)
		if(src.loaded_pill_bottle)
			dat += "Pill Bottle \[[loaded_pill_bottle.contents.len]/[loaded_pill_bottle.storage_slots]\] <A href='?src=\ref[src];ejectp=1'>Eject</A>"
		else
			dat += "No pill bottle inserted."
	else
		dat += "<BR>"

	dat += "<UL>"
	if(!condi)
		if(beaker && reagents.total_volume)
			dat += "<LI><A href='?src=\ref[src];createpill=1;many=0'>Create pill</A> (50 units max)"
			dat += "<LI><A href='?src=\ref[src];createpill=1;many=1'>Create multiple pills</A><BR>"
		else
			dat += "<LI><span class='linkOff'>Create pill</span> (50 units max)"
			dat += "<LI><span class='linkOff'>Create multiple pills</span><BR>"
	else
		if(beaker && reagents.total_volume)
			dat += "<LI><A href='?src=\ref[src];createpill=1'>Create pack</A> (10 units max)<BR>"
		else
			dat += "<LI><span class='linkOff'>Create pack</span> (10 units max)<BR>"
	dat += "<LI><A href='?src=\ref[src];createbottle=1'>Create bottle</A> ([condi ? "50" : "30"] units max)"
	dat += "</UL>"
	dat += "<BR><A href='?src=\ref[src];close=1'>Close</A>"

	var/datum/browser/popup = new(user, "chem_master", name, 470, 500)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open(1)

/obj/machinery/chem_master/proc/isgoodnumber(num)
	if(isnum(num))
		return Clamp(round(num), 0, 200)
	else
		return 0


/obj/machinery/chem_master/condimaster
	name = "CondiMaster 3000"
	condi = 1

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/chem_master/constructable
	name = "ChemMaster 2999"
	desc = "Used to seperate chemicals and distribute them in a variety of forms."

/obj/machinery/chem_master/constructable/atom_init()
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/chem_master(null)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(null)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(null)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(null)

/obj/machinery/chem_master/constructable/attackby(obj/item/B, mob/user, params)

	if(default_deconstruction_screwdriver(user, "mixer0_nopower", "mixer0_", B))
		if(beaker)
			beaker.loc = src.loc
			beaker = null
			reagents.clear_reagents()
		if(loaded_pill_bottle)
			loaded_pill_bottle.loc = src.loc
			loaded_pill_bottle = null
		return

	if(exchange_parts(user, B))
		return

	if(panel_open)
		if(istype(B, /obj/item/weapon/crowbar))
			default_deconstruction_crowbar(B)
			return 1
		else
			to_chat(user, "<span class='warning'>You can't use the [src.name] while it's panel is opened.</span>")
			return 1

	if(istype(B, /obj/item/weapon/reagent_containers/glass))
		if(src.beaker)
			to_chat(user, "<span class='alert'>A beaker is already loaded into the machine.</span>")
			return
		src.beaker = B
		user.drop_item()
		B.loc = src
		to_chat(user, "You add the beaker to the machine!")
		src.updateUsrDialog()
		icon_state = "mixer1"

	else if(!condi && istype(B, /obj/item/weapon/storage/pill_bottle))
		if(src.loaded_pill_bottle)
			to_chat(user, "<span class='alert'>A pill bottle is already loaded into the machine.</span>")
			return
		src.loaded_pill_bottle = B
		user.drop_item()
		B.loc = src
		to_chat(user, "You add the pill bottle into the dispenser slot!")
		src.updateUsrDialog()

	return
