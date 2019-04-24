/obj/effect/proc_holder/magic/click_on/spirits
	name = "Spirit of the Element"
	desc = ""
	mana_cost = 0
	types_to_click = list("turfs")


//Effects and shit
//Can place through walls

/obj/effect/proc_holder/magic/click_on/spirits/check_turf_cast(turf/target)
	if(is_blocked_turf(target))
		to_chat(owner.current, "<font color='purple'><i>This place is occupied! I can't summon a magical spirit here!</i></font>")
		return TRUE


/obj/effect/proc_holder/magic/click_on/spirits/cast_on_turf(turf/target)
	var/mob/living/simple_animal/hostile/spirit/summoned_spirit
	switch(owner.current.a_intent)
		if("help")
			summoned_spirit = new /mob/living/simple_animal/hostile/spirit/earth_spirit(target)
		if("disarm")
			summoned_spirit = new /mob/living/simple_animal/hostile/spirit/ice_spirit(target)
		if("hurt")
			summoned_spirit = new /mob/living/simple_animal/hostile/spirit/fire_spirit(target)
		if("grab")
			summoned_spirit = new /mob/living/simple_animal/hostile/spirit/thunder_spirit(target)

	summoned_spirit.friends += owner.current
	QDEL_IN(summoned_spirit, 200)


/mob/living/simple_animal/hostile/spirit
	name = "Spirit of the Primordial Element"
	desc = "One of the Elemental Spirits, summoned to our plane via either scientific experiment or magical spell"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "resurrection"
	faction = "conjured"
	light_power = 2
	light_range = 2
	maxHealth = 1
	health = 1
	harm_intent_damage = 1
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/mob/living/simple_animal/hostile/spirit/death()
	..()
	visible_message("<b>[src]</b> vanishes!")
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return



/mob/living/simple_animal/hostile/spirit/earth_spirit
	name = "Spirit of Earth"
	light_color = "#32CD32"
	melee_damage_lower = 15
	melee_damage_upper = 20
	attacktext = "pulverizes"
	speed = 1

/mob/living/simple_animal/hostile/spirit/earth_spirit/atom_init()
	. = ..()
	color = "#32CD32"

/mob/living/simple_animal/hostile/spirit/ice_spirit
	name = "Spirit of Ice"
	attacktext = "chills"
	melee_damage_lower = 3
	melee_damage_upper = 3
	light_color = "#0000FF"


/mob/living/simple_animal/hostile/spirit/ice_spirit/atom_init()
	. = ..()
	color = "#0000FF"


/mob/living/simple_animal/hostile/spirit/ice_spirit/AttackingTarget()
	..()
	var/mob/living/L = target
	if(istype(L))
		L.bodytemperature -= 140
		L.reagents.add_reagent("frostoil", 10)


/mob/living/simple_animal/hostile/spirit/fire_spirit
	name = "Spirit of Fire"
	attacktext = "scorches"
	light_color = "#FF0000"
	melee_damage_lower = 3
	melee_damage_upper = 3

/mob/living/simple_animal/hostile/spirit/fire_spirit/atom_init()
	. = ..()
	color = "#FF0000"

/mob/living/simple_animal/hostile/spirit/fire_spirit/AttackingTarget()
	..()
	var/mob/living/L = target
	if(istype(L))
		L.adjust_fire_stacks(5)
		L.IgniteMob()

/mob/living/simple_animal/hostile/spirit/thunder_spirit
	name = "Spirit of Thunder"
	icon = 'code/modules/anomaly/anomalies.dmi'
	icon_state = "flux2"
	attacktext = "shocks"
	ranged = 1
	retreat_distance = 5
	minimum_distance = 5
	projectiletype = /obj/item/projectile/tiny_tesla
	speed = -2
	light_color = "#FFE194"

/obj/item/projectile/tiny_tesla
	name = "shock sphere"
	damage = 5
	damage_type = BURN
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "tesla_projectile"


/obj/item/projectile/tiny_tesla/atom_init()
	. = ..()
	var/matrix/Mx = matrix()
	Mx.Scale(0.5)
	transform = Mx
	color = "#FFE194"


/obj/item/projectile/tiny_tesla/on_hit(atom/target)
	if(istype(target, /mob/living))
		var/mob/living/L = target
		L.electrocute_act(10, src)
	return ..()