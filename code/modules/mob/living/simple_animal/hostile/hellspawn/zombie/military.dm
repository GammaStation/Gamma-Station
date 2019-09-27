/mob/living/simple_animal/hostile/hellspawn/zombie/military
	desc = "A former military"
	maxHealth = 85
	health = 85
	blunt_weapon = list()
	cutting_weapon = list()
	range_weapon = list(/obj/item/weapon/gun/projectile/automatic/assault_rifle,/obj/item/weapon/gun/projectile/revolver/doublebarrel)
	sight_sound = list(
	'sound/mob/army_zombie/zombie_sight1.ogg',\
	'sound/mob/army_zombie/zombie_sight2.ogg',\
	'sound/mob/army_zombie/zombie_sight3.ogg',\
	'sound/mob/army_zombie/zombie_sight4.ogg',\
	'sound/mob/army_zombie/zombie_sight5.ogg',\
	'sound/mob/army_zombie/zombie_sight6.ogg',\
	'sound/mob/army_zombie/zombie_sight7.ogg',\
	'sound/mob/army_zombie/zombie_sight8.ogg',\
	'sound/mob/army_zombie/zombie_sight9.ogg',\
	'sound/mob/army_zombie/zombie_sight10.ogg',\
	'sound/mob/army_zombie/zombie_sight11.ogg',\
	'sound/mob/army_zombie/zombie_sight12.ogg',\
	'sound/mob/army_zombie/zombie_sight13.ogg',\
	'sound/mob/army_zombie/zombie_sight14.ogg'
	)
	death_sound = list(
	'sound/mob/army_zombie/zombie_death1.ogg',\
	'sound/mob/army_zombie/zombie_death2.ogg',\
	'sound/mob/army_zombie/zombie_death3.ogg',\
	'sound/mob/army_zombie/zombie_death4.ogg',\
	'sound/mob/army_zombie/zombie_death5.ogg',\
	'sound/mob/army_zombie/zombie_death6.ogg',\
	'sound/mob/army_zombie/zombie_death7.ogg'
	)
/mob/living/simple_animal/hostile/hellspawn/zombie/military/generate_icons()
	..()
	var/image/gear = image('icons/mob/hellspawn/zombie_gear.dmi', "military_[pick(1)]-[pick("a","b","c")]")
	overlays += gear



	if(prob(50))
		var/image/bloodsies = image('icons/mob/hellspawn/zombie_blood.dmi', "[pick("uniform","armor","suit")]blood")
		overlays += bloodsies
	if(prob(25))
		var/image/bloodsies_secondary = image('icons/mob/hellspawn/zombie_blood.dmi', "[pick("shoe","hands")]blood")
		overlays += bloodsies_secondary

/mob/living/simple_animal/hostile/hellspawn/zombie/military/get_weapon()
	var/obj/item/weapon/pickup
	pickup = pick(range_weapon)

	weapon = new pickup(src)
	melee_damage_lower = (weapon.force/2)
	melee_damage_upper = weapon.force
	attack_message = weapon.attack_verb
	attack_sound = weapon.hitsound
	var/item_state_overlay
	item_state_overlay = weapon.icon_custom ? "[weapon.item_state]_r" : weapon.item_state
	var/obj/item/weapon/gun/projectile/G = weapon
	ranged = 1
	projectilesound = G.fire_sound
	casingtype = G.magazine.ammo_type
	shots_before_reload = G.magazine.max_ammo
	var/obj/item/ammo_casing/boolet = new G.magazine.ammo_type
	projectiletype = boolet.projectile_type
	if(!G.isHandgun())
		item_state_overlay = "[G.item_state]_wield"

	weapon_overlay = image(weapon.righthand_file,item_state_overlay)
	overlays += weapon_overlay