/obj/item/ammo_casing/shotgun
	name = "shotgun slug"
	desc = "A 12 gauge slug."
	icon_state = "blshell"
	caliber = "shotgun"
	projectile_type = /obj/item/projectile/bullet
	m_amt = 12500

/obj/item/ammo_casing/shotgun/buckshot
	name = "shotgun shell"
	desc = "A 12 gauge shell."
	icon_state = "gshell"
	projectile_type = /obj/item/projectile/bullet/pellet
	pellets = 5
	variance = 0.8

/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag shell"
	desc = "A weak beanbag shell."
	icon_state = "bshell"
	projectile_type = /obj/item/projectile/bullet/weakbullet/beanbag
	m_amt = 500

/obj/item/ammo_casing/shotgun/stunslug
	name = "stun shell"
	desc = "An electrified, stunning taser slug for shotguns."
	icon_state = "stunshell"
	projectile_type = /obj/item/projectile/bullet/stunslug
	m_amt = 2500

/obj/item/ammo_casing/shotgun/incendiary
	name = "incendiary shell"
	desc = "An incendiary slug."
	icon_state = "ishell"
	projectile_type = /obj/item/projectile/bullet/incendiary
	m_amt = 2500

/obj/item/ammo_casing/shotgun/dart
	name = "shotgun darts"
	desc = "A dart for use in shotguns."
	icon_state = "dart"
	projectile_type = /obj/item/projectile/energy/dart
	m_amt = 12500