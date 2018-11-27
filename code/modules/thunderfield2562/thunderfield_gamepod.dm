#define RESPAWNS_FOR_PAYMENT 5
#define PRICE_PER_USE 100
#define POINTS_FOR_CHEATER 30
/obj/machinery/gamepod
	name = "\improper gamepod"
	desc = "A gaming pod for wasting time."
	icon = 'icons/obj/machines/gamepod.dmi'
	icon_state = "gamepod_open"
	density = TRUE
	anchored = TRUE
	var/is_payed = FALSE
	var/datum/mind/occupant_mind
	power_channel = EQUIP
	use_power = 1
	idle_power_usage = 80
	active_power_usage = 1000
	var/list/prohibited_roles = list("Shadowling", "Ninja", "Revolutionary", "Operative", "Blob", "Abductor", "Mutineer", "Wizard", "Raider", "Cultist")

/obj/machinery/gamepod/atom_init()
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/gamepod(null)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(null)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(null)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(null)
	component_parts += new /obj/item/stack/cable_coil/random(null, 1)
	RefreshParts()

//Code for attackby

/obj/machinery/gamepod/attackby(obj/item/I, mob/user)
	user.SetNextMove(CLICK_CD_INTERACT)
	if(istype(I, /obj/item/weapon/card/id))
		if(is_payed)
			to_chat(usr, "<span class='notice'><B>[bicon(src)] It is already payed.</B></span>")
			return
		scan_card(I)
	else if(istype(I, /obj/item/weapon/card/emag))
		if(emagged)
			to_chat(usr, "<span class='notice'><B>[bicon(src)] It is already broken.</B></span>")
			return
		else
			to_chat(usr, "<span class='notice'><B>[bicon(src)] You broke something.</B></span>")
		emagged = TRUE
	else if(istype(I, /obj/item/weapon/screwdriver))
		if(occupant)
			to_chat(usr, "<span class='notice'><B>[bicon(src)] Pod is in use.</B></span>")
			return
		playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(!panel_open)
			panel_open = 1
			to_chat(user, "<span class='notice'>[bicon(src)] You open the maintenance hatch of [src].</span>")
			return
		panel_open = 0
		to_chat(user, "<span class='notice'>[bicon(src)] You close the maintenance hatch of [src].</span>")
		return
	else if(istype(I, /obj/item/weapon/crowbar))
		if(occupant)
			to_chat(usr, "<span class='notice'><B>[bicon(src)] Pod is in use.</B></span>")
			return
		if(!panel_open)
			to_chat(user, "<span class='notice'>[bicon(src)] You must open the maintenance hatch first.</span>")
			return
		playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
		to_chat(user, "<span class='notice'>[bicon(src)] You pry off the circutry.</span>")
		var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(loc)
		M.state = 2
		M.icon_state = "box_1"
		for(var/obj/item/T in component_parts)
			T.loc = src.loc
		qdel(src)
		return

/obj/machinery/gamepod/proc/scan_card(obj/item/weapon/card/id/C)
	visible_message("<span class='info'><B>[usr] swipes a card through [src].</B></span>")
	if(!station_account)
		return
	if(!get_account(C.associated_account_number))
		to_chat(usr, "<span class='warning'>[bicon(src)] There is no account associated with your ID!</span>")
		return
	var/datum/money_account/D = get_account(C.associated_account_number)
	var/attempt_pin = 0
	if(D.security_level && D.security_level > 0)
		attempt_pin = input("Enter pin code", "Transaction") as num
	if(attempt_pin)
		D = attempt_account_access(C.associated_account_number, attempt_pin, 2)
	if(!D)
		to_chat(usr, "<span class='warning'>[bicon(src)] No access granted!</span>")
		return
	var/transaction_amount = PRICE_PER_USE
	if(transaction_amount > D.money)
		to_chat(usr, "<span class='warning'>[bicon(src)] You don't have that much money!</span>")
		return
	D.money -= transaction_amount
	station_account.money += transaction_amount
	var/datum/transaction/T = new()
	T.target_name = "[station_account.owner_name] (via [src.name])"
	T.purpose = "Purchase of thunderfield gamepod use"
	T.amount = "[transaction_amount]"
	T.source_terminal = src.name
	T.date = current_date_string
	T.time = worldtime2text()
	D.transaction_log.Add(T)
	T.target_name = D.owner_name
	station_account.transaction_log.Add(T)
	QDEL_NULL(T)
	to_chat(usr, "<span class='notice'><B>[bicon(src)] Transaction successful. Have a nice time.</B></span>")
	is_payed = TRUE
	if(occupant)
		create_body()

//Block for handling player coming in and out

/obj/machinery/gamepod/verb/get_inside()
	set name = "Enter Pod"
	set category = "Object"
	set src in oview(1)

	if(usr.stat != CONSCIOUS || !(ishuman(usr)))
		return

	if(!is_payed)
		to_chat(usr, "<span class='notice'><B>[bicon(src)] Pay first.</B></span>")
		return
	move_inside(usr)

/obj/machinery/gamepod/MouseDrop_T(mob/target, mob/user)
	if(user != target || target.stat != CONSCIOUS || !(ishuman(target)))
		return
	if(!is_payed)
		to_chat(usr, "<span class='notice'><B>[bicon(src)] Pay first.</B></span>")
		return
	move_inside(target)

/obj/machinery/gamepod/proc/move_inside(mob/living/carbon/human/H)
	if(occupant)
		to_chat(usr, "<span class='notice'><B>The gamepod is in use.</B></span>")
		return

	if(!powered())
		return

	for(var/mob/living/carbon/slime/S in range(1, H))
		if(S.Victim == H)
			to_chat(usr, "<span class='danger'>You're too busy getting your life sucked out of you.</span>")
			return

	if(!role_check(H.mind))
		to_chat(usr, "<span class='danger'>You have more important tasks than playing.</span>")
		return

	if(!code_check())
		to_chat(usr, "<span class='danger'>You can play only in green code.</span>")
		return

	close_machine(H)
	icon_state = "gamepod"
	create_body()

/obj/machinery/gamepod/proc/create_body()
	if(!thunderfield_spawns_list.len)
		to_chat(usr, "<span class='warning'><B>[bicon(src)] No spawn points are available. Something went wrong.</B></span>")
		return
	if(!occupant.mind)//How that can even happen?
		return
	var/obj/effect/landmark/spawnpoint = pick(thunderfield_spawns_list)
	//Here should be some checks for safety of new vrbody
	var/mob/living/carbon/human/vrhuman/vrbody = new /mob/living/carbon/human/vrhuman(spawnpoint.loc)

	if(emagged)
		occupant.mind.thunderfield_cheater = TRUE
	occupant.mind.thunder_respawns = RESPAWNS_FOR_PAYMENT
	occupant.mind.thunderfield_owner = occupant
	vrbody.vr_mind = occupant.mind
	vrbody.vr_shop.vr_mind = occupant.mind
	occupant_mind = occupant.mind //We need to store user's mind to return it to his original body in case of some problems
	occupant.mind.transfer_to(vrbody)
	is_payed = FALSE

/obj/machinery/gamepod/verb/get_outside()
	set name = "Exit Pod"
	set category = "Object"
	set src in oview(1)

	if(usr != occupant || usr.stat != CONSCIOUS || !(ishuman(usr) || !(ismonkey(usr))))
		to_chat(usr, "<span class='notice'><B>You cant do that.</B></span>")
		return
	open_machine()
	icon_state = "gamepod_open"

/obj/machinery/gamepod/relaymove(mob/user)
	..()
	open_machine()
	icon_state = "gamepod_open"

/obj/machinery/gamepod/proc/force_move_outside()
	if(!occupant_mind)
		return
	if(isvrhuman(occupant_mind.current))
		var/mob/living/carbon/human/vrhuman/vrbody = occupant_mind.current
		vrbody.force_return()
		vrbody = null
		to_chat(occupant,"<span class='warning'><B> [bicon(src)]Temporary issues, VR aborted.</B></span>")
		occupant_mind.thunderfield_cheater = FALSE
		occupant_mind = null
	open_machine()
	icon_state = "gamepod_open"

//Code for _act() and other stuff

/obj/machinery/gamepod/emp_act()
	if(occupant)
		force_move_outside()
	..()

/obj/machinery/gamepod/blob_act()
	if(occupant)
		force_move_outside()
	..()

/obj/machinery/gamepod/power_change()
	if(powered())
		return
	force_move_outside()

/obj/machinery/gamepod/Destroy()
	if(occupant)
		force_move_outside()
	return ..()

/obj/machinery/gamepod_controller
	name = "\improper gamepod controller"
	desc = "High-powerful GPU for VR gamepod."
	icon = 'icons/obj/machines/gamepod.dmi'
	icon_state = "gamepodc_on"
	density = TRUE
	anchored = TRUE

/obj/machinery/gamepod_controller/power_change()
	if(powered())
		icon_state = "gamepodc_on"
	else
		icon_state = "gamepodc_off"

/obj/machinery/gamepod/proc/code_check()
	if(security_level != SEC_LEVEL_GREEN)
		return FALSE
	else
		return TRUE

/obj/machinery/gamepod/proc/role_check(var/datum/mind/user_mind)
	for(var/A in prohibited_roles)
		if(user_mind.special_role == A)
			return FALSE
	return TRUE

#undef RESPAWNS_FOR_PAYMENT
#undef PRICE_PER_USE
#undef POINTS_FOR_CHEATER