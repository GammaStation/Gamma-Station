///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to modify existing food. They all
//	leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
//	to mixed-drinks code. If you want an object that starts pre-loaded, you need to make it in addition to the other code.

//Food items that aren't eaten normally and leave an empty container behind.
/obj/item/weapon/reagent_containers/food/condiment
	name = "Condiment Container"
	desc = "Just your average condiment container."
	icon = 'icons/obj/food.dmi'
	icon_state = "emptycondiment"
	flags = OPENCONTAINER
	possible_transfer_amounts = list(1,5,10)
	volume = 50

	attackby(obj/item/weapon/W, mob/user)

		return
	attack_self(mob/user)
		return
	attack(mob/M, mob/user, def_zone)

		if(!CanEat(user, M, src, "swallow")) return

		var/datum/reagents/R = src.reagents

		if(!R || !R.total_volume)
			to_chat(user, "\red None of [src] left, oh no!")
			return 0

		if(isliving(M))
			var/mob/living/L = M
			if(taste)
				L.taste_reagents(reagents)
		if(M == user)
			to_chat(M, "\blue You swallow some of contents of the [src].")
			if(reagents.total_volume)
				reagents.trans_to_ingest(M, 10)

			playsound(M.loc,'sound/items/drink.ogg', rand(10,50), 1)
			return 1
		else

			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] attempts to feed [M] [src].", 1)
			if(!do_mob(user, M)) return
			for(var/mob/O in viewers(world.view, user))
				O.show_message("\red [user] feeds [M] [src].", 1)

			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [reagentlist(src)]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [src.name] by [M.name] ([M.ckey]) Reagents: [reagentlist(src)]</font>")
			msg_admin_attack("[user.name] ([user.ckey]) fed [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

			if(reagents.total_volume)
				reagents.trans_to_ingest(M, 10)

			playsound(M.loc,'sound/items/drink.ogg', rand(10,50), 1)
			return 1
		return 0

	attackby(obj/item/I, mob/user)

		return

	afterattack(obj/target, mob/user , flag)
		if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

			if(!target.reagents.total_volume)
				to_chat(user, "\red [target] is empty.")
				return

			if(reagents.total_volume >= reagents.maximum_volume)
				to_chat(user, "\red [src] is full.")
				return

			var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
			to_chat(user, "\blue You fill [src] with [trans] units of the contents of [target].")

		//Something like a glass or a food item. Player probably wants to transfer TO it.
		else if(target.is_open_container() || istype(target, /obj/item/weapon/reagent_containers/food/snacks))
			if(!reagents.total_volume)
				to_chat(user, "\red [src] is empty.")
				return
			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				to_chat(user, "\red you can't add anymore to [target].")
				return
			var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
			to_chat(user, "\blue You transfer [trans] units of the condiment to [target].")

	on_reagent_change()
		if(icon_state == "saltshakersmall" || icon_state == "peppermillsmall")
			return
		if(reagents.reagent_list.len > 0)
			switch(reagents.get_master_reagent_id())
				if("ketchup")
					name = "Ketchup"
					desc = "You feel more American already."
					icon_state = "ketchup"
				if("capsaicin")
					name = "Hotsauce"
					desc = "You can almost TASTE the stomach ulcers now!"
					icon_state = "hotsauce"
				if("enzyme")
					name = "Universal Enzyme"
					desc = "Used in cooking various dishes."
					icon_state = "enzyme"
				if("soysauce")
					name = "Soy Sauce"
					desc = "A salty soy-based flavoring."
					icon_state = "soysauce"
				if("frostoil")
					name = "Coldsauce"
					desc = "Leaves the tongue numb in its passage."
					icon_state = "coldsauce"
				if("sodiumchloride")
					name = "Salt Shaker"
					desc = "Salt. From space oceans, presumably."
					icon_state = "saltshakersmall"
				if("blackpepper")
					name = "Pepper Mill"
					desc = "Often used to flavor food or make people sneeze."
					icon_state = "peppermillsmall"
				if("cornoil")
					name = "Corn Oil"
					desc = "A delicious oil used in cooking. Made from corn."
					icon_state = "oliveoil"
				if("flour")
					name = "Flour"
					desc = "A small bag filled with some flour."
					icon_state = "flour"
				if("sugar")
					name = "Sugar"
					desc = "Tastey space sugar!"
				else
					name = "Misc Condiment Bottle"
					if (reagents.reagent_list.len==1)
						desc = "Looks like it is [reagents.get_master_reagent_name()], but you are not sure."
					else
						desc = "A mixture of various condiments. [reagents.get_master_reagent_name()] is one of them."
					icon_state = "mixedcondiments"
		else
			icon_state = "emptycondiment"
			name = "Condiment Bottle"
			desc = "An empty condiment bottle."
			return

/obj/item/weapon/reagent_containers/food/condiment/enzyme
	name = "Universal Enzyme"
	desc = "Used in cooking various dishes."
	icon_state = "enzyme"

/obj/item/weapon/reagent_containers/food/condiment/enzyme/atom_init()
	. = ..()
	reagents.add_reagent("enzyme", 50)

/obj/item/weapon/reagent_containers/food/condiment/flour
	name = "Flour"
	desc = "A small bag filled with some flour."
	icon_state = "flour"

/obj/item/weapon/reagent_containers/food/condiment/flour/atom_init()
	. = ..()
	reagents.add_reagent("flour", 30)

/obj/item/weapon/reagent_containers/food/condiment/sugar

/obj/item/weapon/reagent_containers/food/condiment/sugar/atom_init()
	. = ..()
	reagents.add_reagent("sugar", 50)

/obj/item/weapon/reagent_containers/food/condiment/saltshaker		//Seperate from above since it's a small shaker rather then
	name = "Salt Shaker"											//	a large one.
	desc = "Salt. From space oceans, presumably."
	icon_state = "saltshakersmall"
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20

/obj/item/weapon/reagent_containers/food/condiment/saltshaker/atom_init()
	. = ..()
	reagents.add_reagent("sodiumchloride", 20)

/obj/item/weapon/reagent_containers/food/condiment/peppermill
	name = "Pepper Mill"
	desc = "Often used to flavor food or make people sneeze."
	icon_state = "peppermillsmall"
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20

/obj/item/weapon/reagent_containers/food/condiment/peppermill/atom_init()
	. = ..()
	reagents.add_reagent("blackpepper", 20)

//MRE condiments and drinks.
/obj/item/weapon/reagent_containers/food/condiment/small
	possible_transfer_amounts = list(1,20)
	amount_per_transfer_from_this = 1
	volume = 20

/obj/item/weapon/reagent_containers/food/condiment/small/on_reagent_change()
	return

/obj/item/weapon/reagent_containers/food/condiment/small/packet
	icon_state = "packet_small"
	w_class = ITEM_SIZE_TINY
	possible_transfer_amounts = list(1,5,10)
	amount_per_transfer_from_this = 1
	volume = 10

/obj/item/weapon/reagent_containers/food/condiment/small/packet/ketchup
	name = "ketchup packet"
	desc = "Contains 5u of ketchup."
	icon_state = "packet_small_red"

/obj/item/weapon/reagent_containers/food/condiment/small/packet/ketchup/atom_init()
	. = ..()
	reagents.add_reagent("ketchup", 5)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/salt
	name = "salt packet"
	desc = "Contains 5u of table salt."
	icon_state = "packet_small_white"

/obj/item/weapon/reagent_containers/food/condiment/small/packet/salt/atom_init()
	. = ..()
	reagents.add_reagent("sodiumchloride", 5)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/pepper
	name = "pepper packet"
	desc = "Contains 5u of black pepper."
	icon_state = "packet_small_black"

/obj/item/weapon/reagent_containers/food/condiment/small/packet/pepper/atom_init()
	. = ..()
	reagents.add_reagent("blackpepper", 5)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/sugar
	name = "sugar packet"
	desc = "Contains 5u of refined sugar."
	icon_state = "packet_small_white"

/obj/item/weapon/reagent_containers/food/condiment/small/packet/sugar/atom_init()
	. = ..()
	reagents.add_reagent("sugar", 5)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/mayo
	name = "mayonnaise packet"
	desc = "Contains 5u of mayonnaise."
	icon_state = "packet_small_white"

/obj/item/weapon/reagent_containers/food/condiment/small/packet/mayo/atom_init()
	. = ..()
	reagents.add_reagent("mayo", 5)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/capsaicin
	name = "hot sauce packet"
	desc = "Contains 5u of hot sauce. Enjoy in moderation."
	icon_state = "packet_small_red"

/obj/item/weapon/reagent_containers/food/condiment/small/packet/capsaicin/atom_init()
	. = ..()
	reagents.add_reagent("capsaicin", 5)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/jelly
	name = "jelly packet"
	desc = "Contains 10u of cherry jelly. Best used for spreading on crackers."
	icon_state = "packet_medium"

/obj/item/weapon/reagent_containers/food/condiment/small/packet/jelly/atom_init()
	. = ..()
	reagents.add_reagent("cherryjelly", 10)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/honey
	name = "honey packet"
	desc = "Contains 10u of honey."
	icon_state = "packet_medium"

/obj/item/weapon/reagent_containers/food/condiment/small/packet/honey/atom_init()
	. = ..()
	reagents.add_reagent("honey", 10)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/soy
	name = "soy sauce packet"
	desc = "Contains 5u of soy sauce."
	icon_state = "packet_small_black"

/obj/item/weapon/reagent_containers/food/condiment/small/packet/soy/atom_init()
	. = ..()
	reagents.add_reagent("soysauce", 5)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/tea
	name = "tea powder packet"
	desc = "Contains 5u of black tea powder."

/obj/item/weapon/reagent_containers/food/condiment/small/packet/tea/atom_init()
	. = ..()
	reagents.add_reagent("tea", 5)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/cocoa
	name = "cocoa powder packet"
	desc = "Contains 5u of cocoa powder."

/obj/item/weapon/reagent_containers/food/condiment/small/packet/cocoa/atom_init()
	. = ..()
	reagents.add_reagent("hot_coco", 5)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/coffee
	name = "coffee powder packet"
	desc = "Contains 5u of coffee powder."

/obj/item/weapon/reagent_containers/food/condiment/small/packet/coffee/atom_init()
	. = ..()
	reagents.add_reagent("coffee", 5)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/grape
	name = "grape juice powder packet"
	desc = "Contains 5u of powdered grape juice."

/obj/item/weapon/reagent_containers/food/condiment/small/packet/grape/atom_init()
	. = ..()
	reagents.add_reagent("grapejuice", 5)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/orange
	name = "orange juice powder packet"
	desc = "Contains 5u of powdered orange juice."

/obj/item/weapon/reagent_containers/food/condiment/small/packet/orange/atom_init()
	. = ..()
	reagents.add_reagent("orangejuice", 5)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/watermelon
	name = "watermelon juice powder packet"
	desc = "Contains 5u of powdered watermelon juice."

/obj/item/weapon/reagent_containers/food/condiment/small/packet/watermelon/atom_init()
	. = ..()
	reagents.add_reagent("watermelonjuice", 5)

/obj/item/weapon/reagent_containers/food/condiment/small/packet/berry
	name = "berry juice powder packet"
	desc = "Contains 5u of powdered berry juice."

/obj/item/weapon/reagent_containers/food/condiment/small/packet/berry/atom_init()
	. = ..()
	reagents.add_reagent("berryjuice", 5)