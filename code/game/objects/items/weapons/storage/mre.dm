var/list/mre_candy = list(/obj/item/weapon/reagent_containers/food/snacks/candy/candybar,/obj/item/weapon/reagent_containers/food/snacks/candy/proteinbar,/obj/item/weapon/reagent_containers/food/snacks/candy/fruitbar)
var/list/mre_spread = list(/obj/item/weapon/reagent_containers/food/condiment/small/packet/jelly, /obj/item/weapon/reagent_containers/food/condiment/small/packet/honey)
var/list/mre_drinks = list(
/obj/item/weapon/reagent_containers/food/condiment/small/packet/coffee,
/obj/item/weapon/reagent_containers/food/condiment/small/packet/tea,
/obj/item/weapon/reagent_containers/food/condiment/small/packet/cocoa,
/obj/item/weapon/reagent_containers/food/condiment/small/packet/grape,
/obj/item/weapon/reagent_containers/food/condiment/small/packet/orange,
/obj/item/weapon/reagent_containers/food/condiment/small/packet/watermelon,
/obj/item/weapon/reagent_containers/food/condiment/small/packet/berry)

/obj/item/weapon/storage/mre
	name = "standard MRE"
	desc = "A vacuum-sealed bag containing a day's worth of nutrients for an adult in strenuous situations. There is no visible expiration date on the package."
	icon = 'icons/obj/food.dmi'
	icon_state = "mre"
	storage_slots = 7
	max_w_class = ITEM_SIZE_SMALL
	var/opened = FALSE
	var/open_sound = 'sound/effects/rip1.ogg'

/obj/item/weapon/storage/mre/atom_init()
	. = ..()
	new /obj/item/weapon/storage/fancy/crackers(src)
	new /obj/item/weapon/kitchen/utensil/pfork(src)


	var/candy_pick = pick(mre_candy)
	new candy_pick(src)

	var/dessert_pick = pick(subtypesof(/obj/item/weapon/storage/mrebag/dessert))
	new dessert_pick(src)

	var/spread_pick = pick(mre_spread)
	new spread_pick(src)

	var/drink_pick = pick(mre_drinks)
	new drink_pick(src)

	var/sauce_pick = pick(subtypesof(/obj/item/weapon/storage/mrebag/sauce))
	new sauce_pick(src)


	var/meal_pick = pick(subtypesof(/obj/item/weapon/storage/mrebag/meal))
	new meal_pick(src)
	make_exact_fit()



/obj/item/weapon/storage/mre/attack_self(mob/user)
	open(user)

/obj/item/weapon/storage/mre/open(mob/user)
	if(!opened)
		opened = TRUE
		playsound(loc, open_sound, 50, 1, -5)
		icon_state = "[initial(icon_state)][opened]"
		to_chat(usr, "<span class='notice'>You tear open the bag, breaking the vacuum seal.</span>")
	..()

/obj/item/weapon/storage/mrebag
	name = "mre bag"
	desc = "This shouldn't be here."
	icon = 'icons/obj/food.dmi'
	icon_state = "pouch_medium"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_SMALL
	storage_slots = 1
	var/message = "The pouch heats up as you break the vaccum seal."
	var/opened = FALSE
	var/open_sound = 'sound/effects/bubbles.ogg'
	var/meal = /obj/item/weapon/reagent_containers/food/snacks/enchiladas

/obj/item/weapon/storage/mrebag/open(mob/user)
	if(!opened)
		opened = TRUE
		playsound(loc, open_sound, 50, 1, -5)
		icon_state = "[initial(icon_state)][opened]"
		to_chat(usr, "<span class='notice'>[message]</span>")
	..()

/obj/item/weapon/storage/mrebag/meal
	name = "main course"
	desc = "A vacuum-sealed bag containing the MRE's main course. Self-heats when opened."
	icon_state = "pouch_medium"
	message = "The pouch heats up as you break the vaccum seal."
	open_sound = 'sound/effects/bubbles.ogg'
	meal = /obj/item/weapon/reagent_containers/food/snacks/enchiladas

/obj/item/weapon/storage/mrebag/meal/atom_init()
	. = ..()
	new meal(src)

/obj/item/weapon/storage/mrebag/meal/menu2
	meal = /obj/item/weapon/reagent_containers/food/snacks/margheritaslice

/obj/item/weapon/storage/mrebag/meal/menu2
	meal = /obj/item/weapon/reagent_containers/food/snacks/margheritaslice

/obj/item/weapon/storage/mrebag/meal/menu3
	meal = /obj/item/weapon/reagent_containers/food/snacks/pastatomato

/obj/item/weapon/storage/mrebag/meal/menu4
	meal = /obj/item/weapon/reagent_containers/food/snacks/monkeyburger

/obj/item/weapon/storage/mrebag/meal/menu5
	meal = /obj/item/weapon/reagent_containers/food/snacks/taco

/obj/item/weapon/storage/mrebag/meal/menu6
	meal = /obj/item/weapon/reagent_containers/food/snacks/meatbreadslice

/obj/item/weapon/storage/mrebag/meal/menu7
	meal = /obj/item/weapon/reagent_containers/food/snacks/tossedsalad

/obj/item/weapon/storage/mrebag/meal/menu8
	meal = /obj/item/weapon/reagent_containers/food/snacks/hotchili

/obj/item/weapon/storage/mrebag/meal/menu9
	meal = /obj/item/weapon/reagent_containers/food/snacks/boiledrice

/obj/item/weapon/storage/mrebag/meal/menu10
	meal = /obj/item/weapon/reagent_containers/food/snacks/meatsteak

/obj/item/weapon/storage/mrebag/dessert
	name = "dessert"
	desc = "A vacuum-sealed bag containing the MRE's dessert."
	icon_state = "pouch_small"
	open_sound = 'sound/effects/rip1.ogg'
	message = "You tear open the bag, breaking the vacuum seal."
	meal = /obj/item/weapon/reagent_containers/food/snacks/donut/normal

/obj/item/weapon/storage/mrebag/dessert/menu2
	meal = /obj/item/weapon/reagent_containers/food/snacks/donut/cherryjelly

/obj/item/weapon/storage/mrebag/dessert/menu3
	meal = /obj/item/weapon/reagent_containers/food/snacks/cookie

/obj/item/weapon/storage/mrebag/dessert/menu4
	meal = /obj/item/weapon/reagent_containers/food/snacks/poppypretzel

/obj/item/weapon/storage/mrebag/dessert/menu5
	meal = /obj/item/weapon/reagent_containers/food/snacks/chocolatebar

/obj/item/weapon/storage/mrebag/dessert/menu6
	meal = /obj/item/weapon/reagent_containers/food/snacks/orangecakeslice

/obj/item/weapon/storage/mrebag/dessert/menu7
	meal = /obj/item/weapon/reagent_containers/food/snacks/chocolatecakeslice

/obj/item/weapon/storage/mrebag/dessert/menu8
	meal = /obj/item/weapon/reagent_containers/food/snacks/spacetwinkie

/obj/item/weapon/storage/mrebag/dessert/menu9
	meal = /obj/item/weapon/reagent_containers/food/snacks/plumphelmetbiscuit

/obj/item/weapon/storage/mrebag/sauce
	name = "sauce"
	desc = "A vacuum-sealed bag containing the MRE's sauce."
	storage_slots = 5
	icon_state = "pouch_small"
	open_sound = 'sound/effects/rip1.ogg'
	message = "You tear open the bag, breaking the vacuum seal."
	meal = /obj/item/weapon/reagent_containers/food/condiment/small/packet/ketchup

/obj/item/weapon/storage/mrebag/sauce/atom_init()
	. = ..()
	new /obj/item/weapon/reagent_containers/food/condiment/small/packet/salt(src)
	new /obj/item/weapon/reagent_containers/food/condiment/small/packet/pepper(src)
	new /obj/item/weapon/reagent_containers/food/condiment/small/packet/sugar(src)
	new meal(src)

/obj/item/weapon/storage/mrebag/sauce/menu2
	meal = /obj/item/weapon/reagent_containers/food/condiment/small/packet/capsaicin

/obj/item/weapon/storage/mrebag/sauce/menu3
	meal = /obj/item/weapon/reagent_containers/food/condiment/small/packet/mayo

/obj/item/weapon/storage/mrebag/sauce/menu4
	meal = /obj/item/weapon/reagent_containers/food/condiment/small/packet/soy