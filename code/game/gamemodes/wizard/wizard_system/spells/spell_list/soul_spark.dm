/obj/effect/proc_holder/magic/click_on/shoot/soulspark
	name = "Soul spark"
	desc = ""
	mana_cost = SOULSPARK_MANACOST
	projectile = /obj/item/projectile/magic/soulspark
	shootsound = 'sound/magic/soulspark.ogg'

/obj/item/projectile/magic/soulspark
	name = "aether ball"
	icon_state = "ice_1"
	light_color = "#00BFFF"
	light_power = 2
	light_range = 2
	nodamage = FALSE
	damage = SOULSPARK_BASE_DAMAGE
	damage_type = BURN

/obj/item/projectile/magic/soulspark/atom_init()
	..()
	var/matrix/Mx = matrix()
	Mx.Scale(2)
	transform = Mx

/obj/item/projectile/magic/soulspark/on_hit(atom/target)
	var/obj/effect/blueboom = new/obj/effect/explosion(loc)
	blueboom.color = "#00BFFF"
	explosion(get_turf(target), SOULSPARK_EXPLOSION_POWER)
	return ..()

#undef SOULSPARK_MANACOST
#undef SOULSPARK_BASE_DAMAGE
#undef SOULSPARK_EXPLOSION_POWER
