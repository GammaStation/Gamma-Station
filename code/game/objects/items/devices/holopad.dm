//
#define CALL_NONE 0
#define CALL_CALLING 1
#define CALL_RINGING 2
#define CALL_IN_CALL 3

/obj/item/device/holopad
	name = "Holopad"
	desc = "Small handheld disk with controls."
	icon = 'icons/ashtray.dmi'
	icon_state = "ashtray_half_br"
	item_state = "card-id"
	w_class = 2
	var/id
	var/obj/item/device/holopad/abonent = null
	var/call_state = CALL_NONE
	var/obj/effect/hologram = null
	var/updatingPos = 0
	origin_tech = "programming=4;bluespace=2;magnets=4"

/obj/item/device/holopad/New()
	..()
	id = rand(1000,9999)
	name = "[initial(name)] [id]"

/obj/item/device/holopad/verb/setID()
	set name="Set ID"
	set category = "Object"
	set src in usr
	var/newid = input(usr,"What would be new ID?") as text
	if(newid)
		id=newid
		name = "[initial(name)] [id]"

/obj/item/device/holopad/proc/getName(var/override_busy = 0)
	if(call_state!=CALL_NONE && !override_busy)
		return "Holopad [id] - busy"
	else
		return "Holopad [id]"

/obj/item/device/holopad/proc/incall(var/obj/item/device/holopad/caller)
	if(call_state != CALL_NONE) return 0
	abonent = caller
	call_state = CALL_RINGING
	icon_state = "holopad_ringing"
	desc = "[initial(desc)] Incoming call from [caller.getName()]"
	spawn(0)
		ring()
	return 1

/obj/item/device/holopad/proc/ring()
	if(call_state != CALL_RINGING) return
	if(isliving(loc) && loc:client)
		loc<<"bzzzzt"
		playsound(loc, 'sound/machines/twobeep.ogg', 25, -5)
	spawn(50)
		ring()

/obj/item/device/holopad/proc/placeCall()
	var/list/Targets = list()
	for(var/obj/item/device/holopad/H in world)
		if(H == src) continue
		Targets[H.getName()] = H
	var/selection = input("Who do you want to call?") as null|anything in Targets
	if(!selection) return
	var/obj/item/device/holopad/target = Targets[selection]
	if(!target) return
	if(target.incall(src))
		call_state = CALL_CALLING
		abonent = target
		icon_state = "holopad_calling"
		usr << "Calling [sanitize(abonent.getName(1))]"
	else
		usr << "Remote device is busy"

/obj/item/device/holopad/proc/acceptCall()
	if(call_state == CALL_RINGING)
		if(abonent && abonent.call_state == CALL_CALLING)
			abonent.acceptCall()
			call_state = CALL_IN_CALL
			icon_state = "holopad_in_call"
			spawn(1) update_holo()
			if(isliving(loc)) loc << "Connection established"
		else
			call_state = CALL_NONE
			icon_state = initial(icon_state)
			desc = initial(desc)
			abonent = null
	else if(call_state == CALL_CALLING)
		call_state = CALL_IN_CALL
		icon_state = "holopad_in_call"
		spawn(1) update_holo()
		if(isliving(loc)) loc << "Connection established"

/obj/item/device/holopad/proc/hangUp(var/remote = 0)
	if(!remote && abonent)
		abonent.hangUp(1)
	if(call_state==CALL_NONE) return

	if(isliving(loc)) loc << "Connection closed"

	call_state = CALL_NONE
	icon_state = initial(icon_state)
	desc = initial(desc)
	abonent = null
	del(hologram)

/obj/item/device/holopad/dropped()
	update_holo()
	..()

/obj/item/device/holopad/proc/update_holo()
	if(call_state == CALL_IN_CALL)
		if(!abonent) return
		if(!abonent.hologram)
			abonent.hologram = new()
			abonent.hologram.name = "Hologram [sanitize(id)]"
			abonent.hologram.layer = 5
		if(isliving(loc))
			abonent.hologram.icon = getHologramIcon(build_composite_icon_omnidir(loc))
		else
			abonent.hologram.icon = icon('icons/effects/effects.dmi', "icon_state"="nothing")
		if(!abonent.updatingPos)
			abonent.update_holo_pos()

/obj/item/device/holopad/proc/update_holo_pos()
	if(call_state != CALL_IN_CALL)
		updatingPos = 0
		return
	updatingPos = 1
	if(isliving(loc))
		var/mob/living/L = loc
		hologram.dir = turn(L.dir,180)
		hologram.loc = L.loc
		hologram.pixel_x = ((L.dir&4)?48:((L.dir&8)?-48:0))
		hologram.pixel_y = ((L.dir&1)?48:((L.dir&2)?-48:0))
	else if(isturf(loc))
		hologram.dir = 2
		hologram.loc = loc
		hologram.pixel_x = 0
		hologram.pixel_y = 0
	else
		hangUp()
	spawn(2)
		src.update_holo_pos()

/obj/item/device/holopad/attack_self(mob/user as mob)
	switch(call_state)
		if(CALL_NONE)
			placeCall()
		if(CALL_CALLING)
			hangUp()
		if(CALL_RINGING)
			acceptCall()
		if(CALL_IN_CALL)
			hangUp()

/obj/item/device/holopad/hear_talk(mob/living/M, text, verb, datum/language/speaking)
	if(call_state == CALL_IN_CALL)
		abonent.receive(text,M==loc)

/obj/item/device/holopad/proc/receive(text, verb, isowner)
	var/list/listening = get_mobs_in_view(2,loc)
	for(var/mob/M in player_list)
		if (!M.client)
			continue
		if (istype(M, /mob))
			continue
		if(M.stat == 2)
			listening|=M
	var/voice = "Holopad Background Voice"
	if(isowner)
		voice = "Holopad [sanitize(abonent.id)]"
	var/rendered = "<span class='game say'><span class='name'>transmits, \"[voice]\"</span> <span class='message'>[sanitize(text)]</span></span>"
	for(var/mob/M in listening)
		M:show_message(rendered, 2)


#undef CALL_NONE
#undef CALL_CALLING
#undef CALL_RINGING
#undef CALL_IN_CALL
