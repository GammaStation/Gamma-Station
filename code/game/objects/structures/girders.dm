/obj/structure/girder
	icon_state = "girder"
	anchored = TRUE
	density = TRUE
	layer = 2.9
	var/state = 0
	var/health = 200
	var/sheet_type = /obj/item/stack/sheet/metal
	var/wall_type = /turf/simulated/wall

/obj/structure/girder/attackby(obj/item/W, mob/user)
	if(user.is_busy()) return
	if(istype (W,/obj/item/weapon/changeling_hammer))
		var/obj/item/weapon/changeling_hammer/C = W
		visible_message("\red <B>[user]</B> has punched \the <B>[src]!</B>")
		user.do_attack_animation(src)
		user.SetNextMove(CLICK_CD_MELEE)
		if(C.use_charge(user, 1) && prob(40))
			playsound(loc, pick('sound/effects/explosion1.ogg', 'sound/effects/explosion2.ogg'), 50, 1)
			qdel(src)
	else if(istype(W, /obj/item/weapon/wrench) && state == 0)
		if(anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			to_chat(user, "\blue Now disassembling the girder")
			if(do_after(user,40,target = src))
				if(!src) return
				to_chat(user, "\blue You dissasembled the girder!")
				new sheet_type(get_turf(src), 2)
				qdel(src)
		else if(!anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			to_chat(user, "\blue Now securing the girder")
			if(do_after(user,40, target = src))
				to_chat(user, "\blue You secured the girder!")
				anchored = TRUE
				icon_state = "[initial(icon_state)]"

	else if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
		to_chat(user, "\blue Now slicing apart the girder")
		if(do_after(user,30,target = src))
			if(!src) return
			to_chat(user, "\blue You slice apart the girder!")
			new sheet_type(get_turf(src), 2)
			qdel(src)

	else if(istype(W, /obj/item/weapon/pickaxe/drill/diamond_drill))
		to_chat(user, "\blue You drill through the girder!")
		new sheet_type(get_turf(src)) //drill destroys metal
		qdel(src)

	else if(istype(W, /obj/item/weapon/crowbar) && state == 0 && anchored )
		playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
		to_chat(user, "\blue Now dislodging the girder")
		if(do_after(user, 40,target = src))
			if(!src) return
			to_chat(user, "\blue You dislodged the girder!")
			anchored = FALSE
			icon_state = "[icon_state]_displaced"

	else if(istype(W, /obj/item/stack/sheet))

		var/obj/item/stack/sheet/S = W
		if(istype(S,sheet_type))
			if(S.get_amount() < 2)
				return ..()
			to_chat(user, "\blue Now adding plating...")
			if (do_after(user, 40, target = src))
				if(QDELETED(src) || QDELETED(S) || !S.use(2))
					return
				to_chat(user, "\blue You added the plating!")
				var/turf/Tsrc = get_turf(src)
				Tsrc.ChangeTurf(wall_type)
				var/turf/simulated/X = wall_type
				for(X in Tsrc.loc)
					X.add_hiddenprint(usr)
				qdel(src)
			return

		if(S.sheettype)
			var/M = S.sheettype
			if(S.get_amount() < 2)
				return ..()
			to_chat(user, "\blue Now adding plating...")
			if (do_after(user, 40, target = src))
				if(QDELETED(src) || QDELETED(S) || !S.use(2))
					return
				to_chat(user, "\blue You added the plating!")
				var/turf/Tsrc = get_turf(src)
				Tsrc.ChangeTurf(text2path("/turf/simulated/wall/mineral/[M]"))
				for(var/turf/simulated/wall/mineral/X in Tsrc.loc)
					X.add_hiddenprint(usr)
				qdel(src)
			return

		add_hiddenprint(usr)

	else if(istype(W, /obj/item/pipe))
		var/obj/item/pipe/P = W
		if (P.pipe_type in list(0, 1, 5))	//simple pipes, simple bends, and simple manifolds.
			user.drop_item()
			P.loc = src.loc
			to_chat(user, "\blue You fit the pipe into the [src]!")
	else
		..()

/obj/structure/girder/bullet_act(obj/item/projectile/Proj)
	if(istype(Proj, /obj/item/projectile/beam))
		health -= Proj.damage
		..()
		if(health <= 0)
			new sheet_type(get_turf(src))
			qdel(src)

		return

/obj/structure/girder/blob_act()
	if(prob(40))
		qdel(src)


/obj/structure/girder/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(30))
				var/remains = pick(/obj/item/stack/rods,sheet_type)
				new remains(loc)
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				var/remains = pick(/obj/item/stack/rods,sheet_type)
				new remains(loc)
				qdel(src)
			return
		else
	return

/obj/structure/girder/attack_animal(mob/living/simple_animal/M)
	if(M.environment_smash)
		..()
		M.visible_message("<span class='warning'>[M] smashes against [src].</span>", \
			 "<span class='warning'>You smash against [src].</span>", \
			 "You hear twisting metal.")
		playsound(loc, 'sound/effects/grillehit.ogg', 80, 1)
		health -= M.melee_damage_upper
		if(health <= 0)
			new sheet_type(get_turf(src))
			qdel(src)

/obj/structure/girder/displaced
	icon_state = "girder_displaced"
	anchored = FALSE

/obj/structure/girder/reinforced
	icon_state = "reinforced"
	sheet_type = /obj/item/stack/sheet/plasteel
	wall_type = /turf/simulated/wall/r_wall
	state = 2
	health = 500

/obj/structure/girder/reinforced/attackby(obj/item/W, mob/user)
	..()
	if(istype(W, /obj/item/weapon/screwdriver) && state == 2)
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
		to_chat(user, "\blue Now unsecuring support struts")
		if(do_after(user,40,target = src))
			if(!src) return
			to_chat(user, "\blue You unsecured the support struts!")
			state = 1

	else if(istype(W, /obj/item/weapon/wirecutters) && state == 1)
		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		to_chat(user, "\blue Now removing support struts")
		if(do_after(user,40,target = src))
			if(!src) return
			to_chat(user, "\blue You removed the support struts!")
			new /obj/structure/girder(loc)
			new sheet_type(get_turf(src), 2)
			qdel(src)


/obj/structure/cultgirder
	icon= 'icons/obj/cult.dmi'
	icon_state= "cultgirder"
	anchored = 1
	density = 1
	layer = 2.9
	var/health = 250

	attackby(obj/item/W, mob/user)
		if(user.is_busy()) return
		if(istype(W, /obj/item/weapon/wrench))
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			to_chat(user, "\blue Now disassembling the girder")
			if(do_after(user,40,target = src))
				to_chat(user, "\blue You dissasembled the girder!")
				new /obj/effect/decal/remains/human(get_turf(src))
				qdel(src)

		else if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
			to_chat(user, "\blue Now slicing apart the girder")
			if(do_after(user,30,target = src))
				to_chat(user, "\blue You slice apart the girder!")
			new /obj/effect/decal/remains/human(get_turf(src))
			qdel(src)

		else if(istype(W, /obj/item/weapon/pickaxe/drill/diamond_drill))
			to_chat(user, "\blue You drill through the girder!")
			new /obj/effect/decal/remains/human(get_turf(src))
			qdel(src)

	blob_act()
		if(prob(40))
			qdel(src)

	bullet_act(obj/item/projectile/Proj) //No beam check- How else will you destroy the cult girder with silver bullets?????
		health -= Proj.damage
		..()
		if(health <= 0)
			new /obj/item/stack/sheet/metal(get_turf(src))
			qdel(src)

		return

	ex_act(severity)
		switch(severity)
			if(1.0)
				qdel(src)
				return
			if(2.0)
				if (prob(30))
					new /obj/effect/decal/remains/human(loc)
					qdel(src)
				return
			if(3.0)
				if (prob(5))
					new /obj/effect/decal/remains/human(loc)
					qdel(src)
				return
			else
		return
