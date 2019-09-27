/obj/item/ammo_casing/a357
	desc = "A .357 bullet casing."
	caliber = "357"
	projectile_type = "/obj/item/projectile/bullet/revbullet"



/obj/item/ammo_casing/c38
	desc = "A .38 bullet casing."
	caliber = "38"
	projectile_type = "/obj/item/projectile/bullet/weakbullet"



/obj/item/ammo_casing/a12mm
	desc = "A 12mm bullet casing."
	caliber = "12mm"
	projectile_type = "/obj/item/projectile/bullet/midbullet2"

/obj/item/ammo_casing/a762
	desc = "A 7.62mm bullet casing."
	caliber = "a762"
	projectile_type = "/obj/item/projectile/bullet/a762"

/obj/item/ammo_casing/a145
	desc = "A 14.5mm shell."
	icon_state = "lcasing"
	caliber = "14.5mm"
	projectile_type = /obj/item/projectile/bullet/heavy/a145


/obj/item/ammo_casing/r4046
	name = "A 40x46mm grenade"
	desc = "A 40x46mm grenade (rubber)."
	icon_state = "40x46"
	caliber = "40x46"
	projectile_type = /obj/item/projectile/bullet/grenade/r4046

/obj/item/ammo_casing/r4046/chem/teargas
	desc = "A 40x46mm grenade (teargas)."
	projectile_type = /obj/item/projectile/bullet/chem/teargas

/obj/item/ammo_casing/r4046/chem/EMP
	desc = "A 40x46mm grenade (EMP)."
	projectile_type = /obj/item/projectile/bullet/chem/EMP

/obj/item/ammo_casing/r4046/chem/Exp
	desc = "A 40x46mm grenade (Exp)."
	projectile_type = /obj/item/projectile/bullet/chem/Exp


/obj/item/ammo_casing/caseless
	desc = "A caseless bullet casing."

/obj/item/ammo_casing/caseless/fire(atom/target, mob/living/user, params, distro, quiet)
	if (..())
		loc = null
		return 1
	else
		return 0

/obj/item/ammo_casing/caseless/a75
	desc = "A .75 bullet casing."
	caliber = "75"
	projectile_type = /obj/item/projectile/bullet/gyro

/obj/item/ammo_casing/caseless/rocket
	name = "HE rocket shell"
	desc = "A high explosive designed to be fired from a launcher."
	icon_state = "rocket-he"
	projectile_type = "/obj/item/projectile/missile"
	caliber = "rocket"

/obj/item/ammo_casing/caseless/rocket/emp
	name = "EMP rocket shell"
	desc = "A EMP rocket designed to be fired from a launcher."
	icon_state = "rocket-emp"
	projectile_type = "/obj/item/projectile/missile/emp"
	caliber = "rocket"

/obj/item/ammo_casing/chameleon
	name = "chameleon bullets"
	desc = "A set of bullets for the Chameleon Gun."
	projectile_type = "/obj/item/projectile/bullet/chameleon"
	caliber = ".45"

/obj/item/ammo_casing/a3006
	desc = "A .30-06 bullet casing."
	caliber = "a3006"
	projectile_type = "/obj/item/projectile/bullet/midbullet3"

/obj/item/ammo_casing/l10
	caliber = "energy"
	projectile_type = "/obj/item/projectile/l10"

/obj/item/ammo_casing/flare
	desc = "A flare for flare gun."
	caliber = "flare"
	icon_state = "flare"
	projectile_type = "/obj/item/projectile/bullet/flare"

/obj/item/ammo_casing/c38m
	desc = "A .38 bullet casing."
	caliber = "38"
	projectile_type = /obj/item/projectile/bullet/midbullet2

/obj/item/ammo_casing/a556
	desc = "A 5.56mm bullet casing."
	caliber = "5.56mm"
	projectile_type = /obj/item/projectile/bullet/rifle2

/obj/item/ammo_casing/a556i
	desc = "A 5.56mm incendiary bullet casing."
	caliber = "5.56mm"
	projectile_type = /obj/item/projectile/bullet/incendiary

/obj/item/ammo_casing/om36
	desc = "A 5.56mm bullet casing."
	caliber = "5.56mm"
	projectile_type = /obj/item/projectile/bullet/rifle3


