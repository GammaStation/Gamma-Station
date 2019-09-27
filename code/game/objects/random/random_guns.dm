//GUNS RANDOM
/obj/random/guns/handgun_security
	name = "Random Handgun"
	desc = "This is a random security sidearm."
	icon = 'icons/obj/guns/projectile/pistols.dmi'
	icon_state = "wjp250"
/obj/random/guns/handgun_security/item_to_spawn()
		return pick(\
						prob(3);/obj/item/weapon/gun/projectile/pistol/sec_pistol,\
						prob(1);/obj/item/weapon/gun/projectile/pistol/sec_pistol/spec
					)

/obj/random/guns/projectile_security
	name = "Random Projectile Weapon"
	desc = "This is a random security weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"
/obj/random/guns/projectile_security/item_to_spawn()
		return pick(\
						prob(3);/obj/item/weapon/gun/projectile/shotgun,\
						prob(1);/obj/item/weapon/gun/projectile/shotgun/combat\
					)

/obj/random/guns/energy_weapon
	name = "Random Energy Weapon"
	desc = "This is a random energy weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "laser"
/obj/random/guns/energy_weapon/item_to_spawn()
		return pick(\
						prob(25);/obj/item/weapon/gun/energy/taser,\
						prob(15);/obj/item/weapon/gun/energy/laser/retro,\
						prob(15);/obj/item/weapon/gun/energy/laser/practice,\
						prob(10);/obj/item/weapon/gun/energy/toxgun,\
						prob(10);/obj/item/weapon/gun/energy/laser,\
						prob(8);/obj/item/weapon/gun/energy/ionrifle,\
						prob(4);/obj/item/weapon/gun/projectile/automatic/l10c,\
						prob(4);/obj/item/weapon/gun/energy/xray,\
						prob(4);/obj/item/weapon/gun/energy/gun,\
						prob(4);/obj/item/weapon/gun/energy/decloner,\
						prob(4);/obj/item/weapon/gun/energy/mindflayer,\
						prob(3);/obj/item/weapon/gun/energy/sniperrifle,\
						prob(3);/obj/item/weapon/gun/energy/gun/nuclear,\
						prob(2);/obj/item/weapon/gun/energy/laser/selfcharging/captain,\
						prob(2);/obj/item/weapon/gun/energy/crossbow,\
						prob(1);/obj/item/weapon/gun/energy/pulse_rifle\
					)

/obj/random/guns/projectile_handgun
	name = "Random Handgun"
	desc = "This is a random pistol."
	icon = 'icons/obj/gun.dmi'
	icon_state = "revolver"
/obj/random/guns/projectile_handgun/item_to_spawn()
		return pick(\
						prob(15);/obj/item/weapon/gun/projectile/pistol/sec_pistol,\
						prob(15);/obj/item/weapon/gun/projectile/pistol,\
						prob(15);/obj/item/weapon/gun/projectile/pistol/syndicate,\
						prob(15);/obj/item/weapon/gun/projectile/pistol/colt1911,\
						prob(15);/obj/item/weapon/gun/projectile/revolver/peacemaker,\
						prob(15);/obj/item/weapon/gun/projectile/revolver/detective,\
						prob(5);/obj/item/weapon/gun/projectile/revolver/syndie,\
						prob(5);/obj/item/weapon/gun/projectile/revolver,\
						prob(5);/obj/item/weapon/gun/projectile/pistol/deagle,\
						prob(2);/obj/item/weapon/gun/projectile/pistol/sec_pistol/spec,\
						prob(2);/obj/item/weapon/gun/projectile/pistol/deagle/gold,\
						prob(2);/obj/item/weapon/gun/projectile/revolver/mateba\
					)

/obj/random/guns/projectile_shotgun
	name = "Random Shotgun"
	desc = "This is a random shotgun."
	icon = 'icons/obj/gun.dmi'
	icon_state = "shotgun"
/obj/random/guns/projectile_shotgun/item_to_spawn()
		return pick(\
						prob(20);/obj/item/weapon/gun/projectile/revolver/doublebarrel,\
						prob(10);/obj/item/weapon/gun/projectile/shotgun,\
						prob(7);/obj/item/weapon/gun/projectile/shotgun/combat,\
						prob(5);/obj/item/weapon/gun/projectile/automatic/bulldog\
					)

/obj/random/guns/projectile_assault
	name = "Random Shotgun"
	desc = "This is a random shotgun."
	icon = 'icons/obj/gun.dmi'
	icon_state = "shotgun"
/obj/random/guns/projectile_assault/item_to_spawn()
		return pick(\
						prob(15);/obj/item/weapon/gun/projectile/automatic,\
						prob(14);/obj/item/weapon/gun/projectile/automatic/c20r,\
						prob(12);/obj/item/weapon/gun/projectile/automatic/mini_uzi,\
						prob(8);/obj/item/weapon/gun/projectile/automatic/assault_rifle/a28,\
						prob(8);/obj/item/weapon/gun/projectile/automatic/assault_rifle,\
						prob(5);/obj/item/weapon/gun/projectile/heavyrifle,\
						prob(5);/obj/item/weapon/gun/projectile/automatic/l6_saw\
					)

/obj/random/guns/projectile_grenade
	name = "Random Grenade Launcher"
	desc = "This is a random shotgun."
	icon = 'icons/obj/gun.dmi'
	icon_state = "riotgun"
/obj/random/guns/projectile_grenade/item_to_spawn()
		return pick(\
						prob(6);/obj/item/weapon/gun/grenadelauncher,\
						prob(1);/obj/item/weapon/gun/projectile/revolver/rocketlauncher,\
						prob(3);/obj/item/weapon/gun/projectile/m79\
					)

/obj/random/guns/weapon_item
	name = "Random Weapon"
	desc = "This is a random weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "saber-18"
/obj/random/guns/weapon_item/item_to_spawn()
		return pick(\
						prob(100);/obj/random/guns/energy_weapon,\
						prob(70);/obj/random/guns/projectile_handgun,\
						prob(50);/obj/random/guns/projectile_assault,\
						prob(30);/obj/random/guns/projectile_shotgun,\
						prob(10);/obj/random/guns/projectile_grenade\
					)

/obj/random/guns/set_9mm
	name = "Random 9mm Weapon with ammunition"
	desc = "This is a random weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "pistol"
/obj/random/guns/set_9mm/item_to_spawn()
		return pick(\
						prob(180);/obj/item/ammo_casing/c9mm,\
						prob(25);/obj/item/ammo_casing/c9mmr,\
						prob(5);/obj/item/ammo_box/c9mm,\
						prob(2);/obj/item/weapon/gun/projectile/pistol/sec_pistol,\
						prob(2);/obj/item/weapon/gun/projectile/pistol/syndicate,\
						prob(1);/obj/item/weapon/gun/projectile/automatic/mini_uzi\
					)

/obj/random/guns/set_shotgun
	name = "Random shotgun Weapon with ammunition"
	desc = "This is a random weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "saber-18"
/obj/random/guns/set_shotgun/item_to_spawn()
		return pick(\
						prob(100);/obj/item/ammo_casing/shotgun/beanbag,\
						prob(75);/obj/item/ammo_casing/shotgun/stunslug,\
						prob(50);/obj/item/ammo_casing/shotgun/buckshot,\
						prob(50);/obj/item/ammo_casing/shotgun/incendiary,\
						prob(50);/obj/item/ammo_casing/shotgun/dart,\
						prob(10);/obj/item/ammo_box/shotgun,\
						prob(10);/obj/random/guns/projectile_shotgun\
					)

/obj/random/guns/set_357
	name = "Random lethal Weapon with ammunition"
	desc = "This is a random weapon."
	icon = 'icons/obj/gun.dmi'
	icon_state = "saber-18"
/obj/random/guns/set_357/item_to_spawn()
		return pick(\
						prob(200);/obj/item/ammo_casing/a357,\
						prob(20);/obj/item/ammo_box/a357,\
						prob(2);/obj/item/weapon/gun/projectile/revolver/mateba,\
						prob(2);/obj/item/weapon/gun/projectile/revolver/,\
						prob(2);/obj/item/weapon/gun/projectile/revolver/syndie\
					)
