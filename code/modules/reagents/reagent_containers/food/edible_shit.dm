/obj/item/weapon/reagent_containers/food/snacks/solid_shit
	name = "poo"
	desc = "It's a poo..."
	icon = 'icons/obj/poo.dmi'
	icon_state = "poop1"
	item_state = "poop"
	bitesize = 3
	var/random_icon_states = list("poop1", "poop2", "poop3", "poop4", "poop5", "poop6", "poop7")

/obj/item/weapon/reagent_containers/food/snacks/solid_shit/atom_init()
	. = ..()
	icon_state = pick(random_icon_states)
	reagents.add_reagent("poo", 5)