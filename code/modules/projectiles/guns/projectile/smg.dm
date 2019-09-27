/obj/item/weapon/gun/projectile/automatic/smg
	name = "submachine gun"
	desc = "Saber - a lightweight, fast firing gun. Uses 9mm rounds."
	icon = 'icons/obj/guns/projectile/smgs.dmi'
	icon_state = "saber"
	item_state = "saber"
	origin_tech = "combat=4;materials=2"
	mag_type = /obj/item/ammo_box/magazine/msmg9mm

/obj/item/weapon/gun/projectile/automatic/smg/update_icon()
	..()
	overlays.Cut()
	if(magazine)
		overlays += image(icon, "[initial(icon_state)]-mag")
	icon_state = "[initial(icon_state)][(!chambered) ? "-e" : ""]"
