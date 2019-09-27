/mob/living/simple_animal/hostile/hellspawn/zombie/civilian
	desc = "A former civilian."
	blunt_weapon = list(/obj/item/weapon/extinguisher/outpost,/obj/item/weapon/crowbar,/obj/item/weapon/twohanded/fireaxe)
	cutting_weapon = list(/obj/item/weapon/kitchenknife,/obj/item/weapon/switchblade/extended,/obj/item/weapon/hatchet/tomahawk)
	range_weapon = list(/obj/item/weapon/gun/projectile/pistol,/obj/item/weapon/gun/projectile/revolver/doublebarrel)
	spawn_coeff = 5

/mob/living/simple_animal/hostile/hellspawn/zombie/civilian/generate_icons()
	..()
	var/image/gear = image('icons/mob/hellspawn/zombie_gear.dmi', "civilian_[pick(1,2,3,4,5,6)]-[pick("a","b","c")]")
	overlays += gear

	if(prob(50))
		var/image/bloodsies = image('icons/mob/hellspawn/zombie_blood.dmi', "[pick("uniform","armor","suit")]blood")
		overlays += bloodsies
	if(prob(25))
		var/image/bloodsies_secondary = image('icons/mob/hellspawn/zombie_blood.dmi', "[pick("shoe","hands")]blood")
		overlays += bloodsies_secondary