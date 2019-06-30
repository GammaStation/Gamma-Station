/obj/effect/proc_holder/magic/click_on/shoot/soulspark
	name = "Soul spark"
	desc = ""
	mana_cost = 0
	projectile = /obj/item/projectile/magic/soulspark
	ultimate = TRUE
	delay = 20
	shootsound = 'sound/magic/soulspark.ogg'

//buff damage and explosion, give cooldown

/obj/item/projectile/magic/soulspark
	name = "aether ball"
	icon_state = "ice_1"
	light_color = "#00BFFF"
	light_power = 2
	light_range = 2
	nodamage = FALSE
	damage = SOULSPARK_BASE_DAMAGE
	damage_type = BURN
	var/matrix/Mx = matrix()
	var/power = 0
	step_delay = 4

/obj/item/projectile/magic/soulspark/before_move()
	. = ..()
	if(power < 16)
		++power
		damage += 5
		Mx.Scale(1.1)
		transform = Mx
	if(power == 2)
		--step_delay
	else if(power == 4)
		--step_delay
	else if(power == 8)
		--step_delay

/obj/item/projectile/magic/soulspark/on_hit(atom/target)
	var/obj/effect/blueboom = new/obj/effect/explosion(loc)
	blueboom.color = "#00BFFF"
	explosion(get_turf(src), light_impact_range = power/2, flash_range = power, forbid_floor_removal = 1)
	/*
	if(isliving(target))
		if(power == 16)
			var/mob/living/L = target
			L.gib()
	*/
	return ..()

#undef SOULSPARK_MANACOST
#undef SOULSPARK_BASE_DAMAGE
#undef SOULSPARK_EXPLOSION_POWER
