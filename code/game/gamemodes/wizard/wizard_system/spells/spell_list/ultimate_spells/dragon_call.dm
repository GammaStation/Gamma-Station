/obj/effect/proc_holder/magic/click_on/dragon_call
	name = "Dragon's call"
	desc = ""
	mana_cost = 0
	ultimate = TRUE
	delay = 50
	types_to_click = list("turfs")



/obj/effect/proc_holder/magic/click_on/dragon_call/check_turf_cast(turf/target)
	if(is_blocked_turf(target))
		to_chat(owner.current, "<span class='wizard'>This place is occupied! I can't summon a dragon here!</span>")
		return TRUE


/obj/effect/proc_holder/magic/click_on/dragon_call/cast_on_turf(turf/target)
	new /obj/effect/explosion(target)
	var/mob/living/simple_animal/hostile/rawr = new /mob/living/simple_animal/hostile/dragon(target,owner.current)
	rawr.friends += owner.current
	playsound(target, 'sound/effects/drop_land.ogg', 100, 2)
	for(var/turf/simulated/floor/tile in range(target, 3))
		if(prob(50))
			tile.break_tile()



/mob/living/simple_animal/hostile/dragon
	name = "red dragon"
	desc = "Came to kidnap princesses and eat knights. Watch out for fiery breath!"
	health = 2500
	maxHealth = 2500
	attacktext = "chomps"
	attack_sound = 'sound/magic/demon_attack1.ogg'
	icon = 'icons/mob/wizard_drake.dmi'
	icon_state = "dragon"
	icon_living = "dragon"
	icon_dead = "dragon_dead"
	friendly = "stares down"
	speak_emote = list("roars")
	melee_damage_lower = 40
	melee_damage_upper = 40
	speed = 1
	move_to_delay = 5
	ranged = 1
	ranged_cooldown = 5
	ranged_cooldown_cap = 5
	pixel_x = -16
	appearance_flags = PIXEL_SCALE
	environment_smash = 3

/mob/living/simple_animal/hostile/dragon/atom_init()
	. = ..()
	var/matrix/Mx = matrix()
	Mx.Scale(1.5)
	Mx.Translate(0, 16)
	transform = Mx

/mob/living/simple_animal/hostile/dragon/death()
	..()
	playsound(get_turf(src),'sound/magic/demon_dies.ogg',200,1)
	visible_message("<span class = 'danger'>[src] roars loudly, before burning away!</span>")
	qdel(src)

/mob/living/simple_animal/hostile/dragon/OpenFire()
	visible_message("<span class = 'danger'>[src] inhales deeply, preparing a fiery breath!</span>")
	addtimer(CALLBACK(src, .proc/do_destruction), 10)
	walk(src,0)
	anchored = TRUE
	ranged_cooldown = ranged_cooldown_cap
	return


/mob/living/simple_animal/hostile/dragon/proc/do_destruction()
	anchored = initial(anchored)
	var/turf/tturf = get_turf(target)
	fire_cone(tturf)

/mob/living/simple_animal/hostile/dragon/proc/fire_cone(var/atom/at = target)
	playsound(get_turf(src),'sound/magic/fireball.ogg', 200, 1)
	if(QDELETED(src) || stat == DEAD) // we dead no fire
		return
	var/range = 15
	var/list/turfs = list()
	turfs = line_target(-15, range, at)
	INVOKE_ASYNC(src, .proc/fire_line, turfs)
	turfs = line_target(0, range, at)
	INVOKE_ASYNC(src, .proc/fire_line, turfs)
	turfs = line_target(15, range, at)
	INVOKE_ASYNC(src, .proc/fire_line, turfs)


/mob/living/simple_animal/hostile/dragon/proc/line_target(var/offset, var/range, var/atom/at = target)
	if(!at)
		return
	var/angle = Atan2(at.x - src.x, at.y - src.y) + offset
	var/turf/T = get_turf(src)
	for(var/i in 1 to range)
		var/turf/check = locate(src.x + cos(angle) * i, src.y + sin(angle) * i, src.z)
		if(!check)
			break
		T = check
	return (getline(src, T) - get_turf(src))

/mob/living/simple_animal/hostile/dragon/proc/fire_line(var/list/turfs)
	fire_breath:
		for(var/turf/T in turfs)
			if(!istype(T,/turf/simulated) || T.density)
				break
			T.create_fire(10)
			for(var/atom/A in T.contents)
				if(A.density)
					if(istype(A, /mob/living))
						var/mob/living/L = A
						L.adjustFireLoss(30)
						L.adjust_fire_stacks(20)
						L.IgniteMob()
						to_chat(L, "<span class='userdanger'>You're hit by [src]'s fire breath!</span>")
					else if(istype(A, /obj/mecha))
						var/obj/mecha/M = A
						M.take_damage(45, BRUTE, "melee", 1)
					else
						break fire_breath



