/mob/living/simple_animal/hostile/hellspawn/zombie/service
	desc = "A former serviceman"
	blunt_weapon = list(/obj/item/weapon/shovel,/obj/item/weapon/twohanded/fireaxe)
	cutting_weapon = list(/obj/item/weapon/butch,/obj/item/weapon/broken_bottle,/obj/item/weapon/hatchet)
	range_weapon = list(/obj/item/weapon/gun/projectile/pistol,/obj/item/weapon/gun/projectile/revolver/doublebarrel)
	spawn_coeff = 5

/mob/living/simple_animal/hostile/hellspawn/zombie/service/generate_icons()
	..()
	var/image/gear = image('icons/mob/hellspawn/zombie_gear.dmi', "service_[pick(1,2,3)]-[pick("a","b","c")]")
	overlays += gear

	if(prob(50))
		var/image/bloodsies = image('icons/mob/hellspawn/zombie_blood.dmi', "[pick("uniform","armor","suit")]blood")
		overlays += bloodsies
	if(prob(25))
		var/image/bloodsies_secondary = image('icons/mob/hellspawn/zombie_blood.dmi', "[pick("shoe","hands")]blood")
		overlays += bloodsies_secondary