//default pistol mag
/obj/item/ammo_box/magazine/m9mm_pistol
	name = "magazine (9mm)"
	icon_state = "pistol_mag"
	origin_tech = "combat=2"
	ammo_type = /obj/item/ammo_casing/c9mm
	caliber = "9mm"
	max_ammo = 8
	multiple_sprites = 2

/obj/item/ammo_box/magazine/m9mm_pistol/rubber
	name = "magazine (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/c9mmr

//Colt 1911 mags
/obj/item/ammo_box/magazine/colt_45c
	name = "Colt magazine (.45)"
	icon_state = "colt_mag"
	ammo_type = /obj/item/ammo_casing/c45
	caliber = ".45"
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_box/magazine/colt_45c/rubber
	name = "Colt magazine (.45 rubber)"
	ammo_type = /obj/item/ammo_casing/c45r

//Deagle mag
/obj/item/ammo_box/magazine/m50
	name = "magazine (.50ae)"
	icon_state = "deagle_mag"
	origin_tech = "combat=2"
	ammo_type = /obj/item/ammo_casing/a50
	caliber = ".50"
	max_ammo = 7
	multiple_sprites = 2

//Thunderfield stuff
/obj/item/ammo_box/magazine/c22cb
	name = "magazine (.22 CB)"
	icon_state = "9mm_mag"
	ammo_type = /obj/item/ammo_casing/c22cb
	caliber = "22"
	max_ammo = 8