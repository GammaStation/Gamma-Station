#define MOVING_TO_TARGET 1

/mob/living/simple_animal/hostile/hellspawn
	name = "hellspawn"
	desc = "You shouldn't see this"
	icon = 'icons/mob/hellspawn/hellspawn.dmi'
	icon_state = "hellspawn"
	faction = "hellspawn"
	weather_immunities = list("ash")

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	environment_smash = 0
	stat_attack = 1

	speak_emote = list("growls", "roars")
	emote_hear = list("rawrs","grumbles","grawls")
	emote_see = list("stares ferociously", "stomps")

	var/spawn_coeff = 1

	var/turf/spawn_point = null
	var/obj/effect/landmark/way_point/rally_point = null
	var/turf/way_point = null


	var/list/priority_objects = list()

	var/sight_sound = list()
//	var/sight_message = list("growls","nashes")

	var/pain_sound = list()
	var/death_sound = list()

	var/busy = 0

	search_objects = 0
//	 = list()
//	wanted_objects = list(/obj/structure/window/reinforced/outpost/full)



/mob/living/simple_animal/hostile/hellspawn/atom_init()
	. = ..()
//	rally()

/mob/living/simple_animal/hostile/hellspawn/death()
	..()
	playsound(src, pick(death_sound), 100, 0)

/mob/living/simple_animal/hostile/hellspawn/FindTarget()
	. = ..()
	if(.)
	//	custom_emote(1,"[pick(sight_message)] at [.]")
		playsound(src, pick(sight_sound), 100, 0)


/mob/living/simple_animal/hostile/hellspawn/Life()
	..()
	switch(stance)
		if(HOSTILE_STANCE_IDLE)
			if(environment_smash)
				EscapeConfinement()
			var/new_target = FindTarget()
			GiveTarget(new_target)
		if(HOSTILE_STANCE_RUSHING)
			stop_automated_movement = 1
		//	priority_objects = list()

		//	if(environment_smash)
		//		EscapeConfinement()
			var/new_target = FindTarget()
			GiveTarget(new_target)
			DestroySurroundings()
			var/area = get_area(src)
			if(rally_point && rally_point.loc in range(5, src))
				if(istype(area,/area/outpost))
					stance = HOSTILE_STANCE_IDLE
				else
					rally_point = give_waypoint(rally_point.number+1,rally_point.id)
					rally()

			if(spawn_point)
				var/dist = get_dist(src,spawn_point)
				if(dist < 7)
					rally()
/*			var/area = get_area(src)
			if((rally_point in range(3,src)) && (!istype(area,/area/outpost)))
				breach()
			if((rally_point in range(3,src)) && !breach() && waypoints.len)
				way_point = get_turf(pick(waypoints))
				Goto(way_point, move_to_delay, 1)
*/
/*

	if(stance == HOSTILE_STANCE_IDLE)
		wanted_objects = list()
		var/dist = get_dist(src,spawn_point)
		if(dist < 5)
			rally()
		var/area = get_area(src)
		if((rally_point in range(3,src)) && (!istype(area,/area/outpost)))
			breach()

		if(environment_smash)
			EscapeConfinement()
		var/new_target = FindTarget()
		GiveTarget(new_target)
*/
/mob/living/simple_animal/hostile/hellspawn/proc/give_waypoint(number = 1,id)
	var/list/right_points = list()
	for(var/obj/effect/landmark/way_point/W in waypoints)
		if(W.id == id && W.number == number)
			right_points += W
	if(right_points.len)
		var/obj/effect/landmark/way_point/T = pick(right_points)
		return T

/mob/living/simple_animal/hostile/hellspawn/DestroySurroundings()
	if(environment_smash)
		EscapeConfinement()
		var/turf/T = get_step(src, dir)
		if(environment_smash > 1)
			if(istype(T, /turf/simulated/wall) || istype(T, /turf/simulated/mineral))
				if(T.Adjacent(src))
					T.attack_animal(src)

		for(var/obj/structure/window/W in get_step(src, dir))
			if(W.dir == reverse_dir[dir]) // So that windows get smashed in the right order
				W.attack_animal(src)
				return
		for(var/atom/A in T)
			if(!A.Adjacent(src))
				continue
			if(istype(A, /obj/structure/window) || istype(A, /obj/structure/closet) || istype(A, /obj/structure/table) || istype(A, /obj/structure/grille) || istype(A, /obj/structure/rack) || istype(A, /obj/machinery/door/window) || istype(A, /obj/structure/girder) || istype(A,/obj/machinery/hydroponics))
				A.attack_animal(src)
			if(istype(A, /obj/item/tape))
				var/obj/item/tape/Tp = A
				Tp.breaktape(null, src, TRUE)

/mob/living/simple_animal/hostile/hellspawn/proc/rally()
	if(rally_point && rally_point.z == z)
		Goto(rally_point, move_to_delay, 1)

/mob/living/simple_animal/hostile/hellspawn/adjustBruteLoss(damage)
	..()
	if(!stat)
		if(stance == HOSTILE_STANCE_RUSHING)
			walk(src,0)  //stop rushing when hurt
			stance = HOSTILE_STANCE_IDLE
		playsound(src, pick(pain_sound), 100, 0)


//TIER 1
/mob/living/simple_animal/hostile/hellspawn/imp
	name = "imp"
	desc = "A ferocious, fang-bearing creature from depths of Hell."
	icon_state = "imp"
	icon_living = "imp"
	icon_dead = "imp_dead"
	bypass_icon = "bypass/mob/hellspawn.dmi"
	maxHealth = 100
	health = 100
	environment_smash = 1
	melee_damage_lower = 8
	melee_damage_upper = 14
	attack_message = list("bites","claws","slashes")
	sight_sound = list('sound/mob/imp/imp_sight1.ogg','sound/mob/imp/imp_sight2.ogg')
	pain_sound = list('sound/mob/imp/imp_pain1.ogg','sound/mob/imp/imp_pain2.ogg')
	death_sound = list('sound/mob/imp/imp_death1.ogg','sound/mob/imp/imp_death2.ogg')
	attack_sound = 'sound/weapons/slashmiss.ogg'
	speed = 5
	move_to_delay = 5
	spawn_coeff = 4

/mob/living/simple_animal/hostile/hellspawn/hellrunner
	name = "hell runner"
	desc = "A sanguinary, canine-like monster."
	icon_state = "hellrunner"
	icon_living = "hellrunner"
	icon_dead = "hellrunner_dead"
	bypass_icon = "bypass/mob/hellspawn.dmi"
	maxHealth = 80
	health = 80
	speed = 1
	move_to_delay = 3
	melee_damage_lower = 6
	melee_damage_upper = 12
	attack_sound = 'sound/weapons/slashmiss.ogg'
	sight_sound = list('sound/mob/hellhound/hellhound_sight1.ogg','sound/mob/hellhound/hellhound_sight2.ogg','sound/mob/hellhound/hellhound_sight3.ogg','sound/mob/hellhound/hellhound_sight4.ogg')
	death_sound = list('sound/mob/hellhound/hellhound_death1.ogg','sound/mob/hellhound/hellhound_death2.ogg','sound/mob/hellhound/hellhound_death3.ogg','sound/mob/hellhound/hellhound_death4.ogg','sound/mob/hellhound/hellhound_death5.ogg')
	pain_sound = list(
	'sound/mob/hellhound/hellhound_pain1.ogg',\
	'sound/mob/hellhound/hellhound_pain2.ogg',\
	'sound/mob/hellhound/hellhound_pain3.ogg',\
	'sound/mob/hellhound/hellhound_pain4.ogg',\
	'sound/mob/hellhound/hellhound_pain5.ogg',\
	'sound/mob/hellhound/hellhound_pain6.ogg',\
	'sound/mob/hellhound/hellhound_pain7.ogg')
	spawn_coeff = 5

//TIER 2
/mob/living/simple_animal/hostile/hellspawn/imp/fierce
	name = "fierce imp"
	desc = "A ferocious, fang-bearing creature from depths of Hell."
	icon_state = "fierce-imp"
	icon_living = "fierce-imp"
	icon_dead = "fierce-imp_dead"
	maxHealth = 180
	health = 180
	environment_smash = 1
	melee_damage_lower = 8
	melee_damage_upper = 16
	attack_message = list("bites","claws","slashes")
	sight_sound = list('sound/mob/imp/imp_sight1.ogg','sound/mob/imp/imp_sight2.ogg')
	pain_sound = list('sound/mob/imp/imp_pain1.ogg','sound/mob/imp/imp_pain2.ogg')
	death_sound = list('sound/mob/imp/imp_death1.ogg','sound/mob/imp/imp_death2.ogg')
	attack_sound = 'sound/weapons/slashmiss.ogg'
	speed = 5
	move_to_delay = 5
	spawn_coeff = 4

/mob/living/simple_animal/hostile/hellspawn/imp/fierce/AttackingTarget()
	. =..()
	if(isliving(target))
		var/mob/living/L = target
		if(prob(15))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

/mob/living/simple_animal/hostile/hellspawn/imp/fast
	name = "fast imp"
	desc = "A ferocious, fang-bearing creature from depths of Hell."
	icon_state = "imp-fast"
	icon_living = "imp-fast"
	icon_dead = "imp-fast_dead"

	maxHealth = 150
	health = 150
	melee_damage_lower = 8
	melee_damage_upper = 14
	speed = 4
	move_to_delay = 4
	var/turbo = FALSE
	var/turbo_count = 8
	var/turbo_max = 8

/mob/living/simple_animal/hostile/hellspawn/imp/fast/FindTarget()
	. = ..()
	if(.)
		visible_message("<span class='notice'>[name] is rushes to prey!</span>",1)
		turbo = TRUE
		playsound(src, pick(sight_sound), 100, 0)

/mob/living/simple_animal/hostile/hellspawn/imp/fast/Life()
	..()
	manage_turbo()
	if(stance == HOSTILE_STANCE_IDLE)
		turbo = FALSE

/mob/living/simple_animal/hostile/hellspawn/imp/fast/proc/manage_turbo()
	if(turbo)
		move_to_delay = 3
		if(turbo_count > 0)
			turbo_count--
		else
			turbo = FALSE
			move_to_delay = 4
	else
		if(turbo_count < turbo_max)
			turbo_count++

/mob/living/simple_animal/hostile/hellspawn/imp/fire
	name = "fire imp"
	icon_state = "fire-imp"
	icon_living = "fire-imp"
	icon_dead = "fire-imp_dead"
	maxHealth = 125
	health = 125
	ranged = 1

	projectiletype = /obj/item/projectile/energy/hell_fireball
	projectilesound = 'sound/mob/imp/imp_fire1.ogg'

/obj/item/projectile/energy/hell_fireball
	name = "fireball"
	icon_state = "fireball"
	light_color = "orange"
	light_power = 2
	light_range = 2
	pass_flags = PASSTABLE
	damage = 20
	damage_type = BURN

/mob/living/simple_animal/hostile/hellspawn/imp/fire/dark
	name = "dark imp"
	icon_state = "dark_imp"
	icon_living = "dark_imp"
	icon_dead = "dark_imp_dead"
	maxHealth = 150
	health = 150
	ranged = 1
	sight_sound = list('sound/mob/fiend/fiend_sight1.ogg','sound/mob/fiend/fiend_sight2.ogg','sound/mob/fiend/fiend_sight3.ogg','sound/mob/fiend/fiend_sight4.ogg')
	death_sound = list('sound/mob/fiend/fiend_death1.ogg','sound/mob/fiend/fiend_death2.ogg','sound/mob/fiend/fiend_death3.ogg','sound/mob/fiend/fiend_death4.ogg')
	pain_sound = list('sound/mob/fiend/fiend_pain1.ogg','sound/mob/fiend/fiend_pain2.ogg','sound/mob/fiend/fiend_pain3.ogg')
	projectiletype = /obj/item/projectile/neurotox
	projectilesound = 'sound/mob/imp/imp_fire1.ogg'

//TIER 3
/mob/living/simple_animal/hostile/hellspawn/hellknight
	name = "hell knight"
	desc = "A massive, tireless beast."
	icon_state = "hellknight"
	icon_living = "hellknight"
	icon_dead = "hellknight_dead"
	bypass_icon = "bypass/mob/hellspawn-big.dmi"
	maxHealth = 300
	health = 300
	melee_damage_lower = 15
	melee_damage_upper = 25
	environment_smash = 2
	attack_message = list("bites","claws","slashes")
	attack_sound = 'sound/mob/hellknight/hellknight_attack1.ogg'
	sight_sound = list('sound/mob/hellknight/hellknight_sight1.ogg','sound/mob/hellknight/hellknight_sight2.ogg','sound/mob/hellknight/hellknight_sight3.ogg')
	pain_sound = list('sound/mob/hellknight/hellknight_pain1.ogg','sound/mob/hellknight/hellknight_pain2.ogg','sound/mob/hellknight/hellknight_pain3.ogg')
	death_sound = list('sound/mob/hellknight/hellknight_death1.ogg','sound/mob/hellknight/hellknight_death2.ogg','sound/mob/hellknight/hellknight_death3.ogg')

/mob/living/simple_animal/hostile/hellspawn/hellknight/MoveToTarget()
	..()
	if(get_dist(src,target) == 4 && AStar(src,target.loc,/turf/proc/Distance,4))
		hk_jump()

/mob/living/simple_animal/hostile/hellspawn/hellknight/proc/hk_jump()
	if (istype(loc,/mob/) || istype(loc,/obj/) || lying || stunned || buckled || stat)
		to_chat(src, "\red You can't jump right now!")
		return

	if (istype(loc,/turf/) && !(istype(loc,/turf/space)))
		for(var/mob/M in range(src, 1))
			if(M.pulling == src)
				M.stop_pulling()

		visible_message("\red <b>[name]</b> takes a huge leap!",1)
		playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1)

		var/prevLayer = layer
		flick("[icon_state]_jump",src)
		layer = 9
		var/cur_dir = dir
		var/turf/simulated/floor/tile = loc
		if(tile)
			tile.break_tile()
		var/o=3
		for(var/i=0, i<14, i++)
			density = 0
			canmove = 0
			o++
			if(o == 4)
				o = 0

				step(src, cur_dir)
			if(i < 7) pixel_y += 8
			else pixel_y -= 8
			sleep(1)
		playsound(loc, 'sound/effects/explosionfar.ogg', 50, 1)

		for(tile in range(1, src))
			if(prob(50))
				tile.break_tile()
		for(var/mob/living/M in loc.contents)
			if(M != src)
			//	src.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [M.name] ([M.ckey]) with jump</font>"
			//	M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [name] with jump</font>"
			//	msg_admin_attack("[key_name(usr)] attacked [key_name(M)] with hulk_jump")
				var/mob/living/carbon/human/H = M
				if(istype(H,/mob/living/carbon/human/))
					playsound(H.loc, 'sound/weapons/tablehit1.ogg', 50, 1)
					var/bodypart_name = pick(BP_CHEST , BP_L_ARM , BP_R_ARM , BP_R_LEG , BP_L_LEG , BP_HEAD , BP_GROIN)
					var/obj/item/organ/external/BP = H.bodyparts_by_name[bodypart_name]
					BP.take_damage(20, used_weapon = "Monster Fists")
					BP.fracture()
					H.Stun(5)
					H.Weaken(5)
				else
					playsound(M.loc, 'sound/weapons/tablehit1.ogg', 50, 1)
					M.Stun(5)
					M.Weaken(5)
					M.take_overall_damage(35, used_weapon = "Monster Fists")
		var/snd = 1
		for(var/direction in alldirs)
			var/turf/T = get_step(src,direction)
			for(var/mob/living/M in T.contents)
				if( (M != src) && !(M.stat))
					if(snd)
						snd = 0
						playsound(M.loc, 'sound/misc/slip.ogg', 50, 1)
					M.Weaken(2)
					for(var/i=0, i<6, i++)
						spawn(i)
							if(i < 3) M.pixel_y += 8
							else M.pixel_y -= 8

		density = 1
		canmove = 1
		layer = prevLayer
	else
		to_chat(src, "\red You need a ground to do this!")
		return

/mob/living/simple_animal/hostile/hellspawn/mancubus
	name = "mancubus"
	desc = "A disgusting fat giant"
	icon_state = "mancubus"
	icon_living = "mancubus"
	icon_dead = "mancubus_dead"
	bypass_icon = "bypass/mob/hellspawn-big.dmi"
	maxHealth = 350
	health = 350
	speed = 7
	move_to_delay = 7
	melee_damage_lower = 10
	melee_damage_upper = 20
	environment_smash = 1
	attack_message = list("smashes","crushes")
	attack_sound = 'sound/mob/mancubus/mancubus_attack1.ogg'
	sight_sound = list('sound/mob/mancubus/mancubus_sight1.ogg','sound/mob/mancubus/mancubus_sight2.ogg','sound/mob/mancubus/mancubus_sight3.ogg','sound/mob/mancubus/mancubus_sight4.ogg')
	pain_sound = list('sound/mob/mancubus/mancubus_pain1.ogg','sound/mob/mancubus/mancubus_pain2.ogg','sound/mob/mancubus/mancubus_pain3.ogg','sound/mob/mancubus/mancubus_pain4.ogg')
	death_sound = list('sound/mob/mancubus/mancubus_death1.ogg','sound/mob/mancubus/mancubus_death2.ogg','sound/mob/mancubus/mancubus_death3.ogg','sound/mob/mancubus/mancubus_death4.ogg')
	var/acid = 200
	var/acid_max = 200
/*
/mob/living/simple_animal/hostile/hellspawn/mancubus/DestroySurroundings()
	var/turf/T = get_step(src, dir)
	if(istype(T, /turf/simulated/wall) || istype(T, /turf/simulated/mineral))
		if(istype(T, /turf/simulated/wall/r_wall) || locate(/obj/effect/alien/acid) in T)
			return
		if(T.Adjacent(src) && acid >= 100)
			new /obj/effect/alien/acid(T,T)
			acid -= 100
			visible_message("\green <B>[name] vomits globs of vile stuff all over [T]. It begins to sizzle and melt under the bubbling mess of acid!</B>")
	..()

*/
/mob/living/simple_animal/hostile/hellspawn/mancubus/Life()
	..()
	if(acid < acid_max)
		acid++
/*
/obj/effect/acid
	name = "acid"
	desc = "Burbling corrossive stuff. You shouldn't touch it."
	icon = 'icons/mob/xenomorph.dmi'
	icon_state = "acid"

	density = FALSE
	opacity = FALSE
	anchored = TRUE

/obj/effect/acid/atom_init()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/acid/process()
/obj/effect/alien/acid/proc/tick()
	if(!target)
		qdel(src)

	ticks += 1

	if(ticks >= target_strength)

		for(var/mob/O in hearers(src, null))
			O.show_message("\green <B>[src.target] collapses under its own weight into a puddle of goop and undigested debris!</B>", 1)

		if(istype(target, /turf/simulated/wall)) // I hate turf code.
			var/turf/simulated/wall/W = target
			W.dismantle_wall(1)
		else if(istype(target, /obj/machinery/atmospherics/components/unary/vent_pump))
			var/obj/machinery/atmospherics/components/unary/vent_pump/VP = target
			VP.welded = 0
			VP.update_icon()
		else
			qdel(target)
		qdel(src)
		return

	switch(target_strength - ticks)
		if(6)
			visible_message("\green <B>[src.target] is holding up against the acid!</B>")
		if(4)
			visible_message("\green <B>[src.target]\s structure is being melted by the acid!</B>")
		if(2)
			visible_message("\green <B>[src.target] is struggling to withstand the acid!</B>")
		if(0 to 1)
			visible_message("\green <B>[src.target] begins to crumble under the acid!</B>")
	spawn(rand(150, 200)) tick()
*/
/mob/living/simple_animal/hostile/hellspawn/mancubus/cyber
	name = "cyber-mancubus"
	desc = "Some son of bitch decides to make tank from mancubus!"
	icon_state = "mancubus-cyber"
	icon_living = "mancubus-cyber"
	icon_dead = "mancubus-cyber_dead"
	speed = 7
	move_to_delay = 7
	maxHealth = 400
	health = 400
	ranged = 1
	minimum_distance = 5
	ranged_cooldown_cap = 3
	rapid = 0
	projectiletype = /obj/item/projectile/energy/mancubus_blast
	projectilesound = 'sound/mob/mancubus/mancubus_shot1.ogg'

/obj/item/projectile/energy/mancubus_blast
	name = "blast"
	icon_state = "pulse0"
	light_color = "orange"
	light_power = 2
	light_range = 2
	pass_flags = PASSTABLE
	damage = 35
	damage_type = BURN

#undef MOVING_TO_TARGET