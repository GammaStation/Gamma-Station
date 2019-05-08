/obj/item/weapon/gun/energy/gun/bison
	name = "pp-91 bison"
	desc = "A trophy soviet laser gun with two settings: Stun and kill."
	icon_state = "bull"
	item_state = null	//so the human update icon uses the icon_state instead.
	ammo_type = list(/obj/item/ammo_casing/energy/stun, /obj/item/ammo_casing/energy/laser)
	origin_tech = "combat=4;magnets=3"
	modifystate = 2

/obj/item/weapon/gun/energy/gun/bison/atom_init()
	. = ..()
	if(power_supply)
		power_supply.maxcharge = 2000
		power_supply.charge = 2000