/obj/effect/proc_holder/magic/nondirect/pandemonium
	name = "Apocalypse"
	desc = ""
	mana_cost = 0
	ultimate = TRUE
	cooldown = 0
	delay = 50


/obj/effect/proc_holder/magic/nondirect/pandemonium/cast()
	playsound(owner.current.loc, 'sound/magic/monsters/monster1.ogg', 100, 0,channel = 1)
	playsound(owner.current.loc, 'sound/magic/monsters/monster2.ogg', 100, 0,channel = 2)
	playsound(owner.current.loc, 'sound/magic/monsters/monster3.ogg', 100, 0,channel = 3)
	playsound(owner.current.loc, 'sound/magic/monsters/monster4.ogg', 100, 0,channel = 4)
	for(var/mob/M in range(10,owner.current))
		if(M.client)
			shake_camera(M, 17, 2)
	for(var/turf/simulated/T in range(10,owner.current))
		if(istype(T,/turf/simulated/wall))
			if(prob(33))
				T.ChangeTurf(/turf/simulated/wall/cult)
			else if(prob(33))
				T.ChangeTurf(/turf/simulated/floor/plating/airless)
		else if(istype(T,/turf/simulated/floor))
			if(prob(10))		//around 1 monster per 10 tiles
				var/mob/living/simple_animal/hostile/spawn_type_monster
				spawn_type_monster = pick(/mob/living/simple_animal/hostile/cellular/meat/changeling, /mob/living/simple_animal/hostile/cellular/meat/maniac, 25;/mob/living/simple_animal/hostile/cellular/meat/creep_standing, 20;/mob/living/simple_animal/hostile/cellular/meat/flesh,/mob/living/simple_animal/hostile/cellular/necro, 10;/mob/living/simple_animal/hostile/cyber_horror)
				var/mob/living/simple_animal/hostile/spawned = new spawn_type_monster (T)
				spawned.faction = "meat"
			if(prob(50))
				var/spawn_type_blood = pick(subtypesof(/obj/effect/decal/cleanable/blood))
				new spawn_type_blood (T)
			if(prob(33))
				T.ChangeTurf(/turf/simulated/floor/engine/cult)
			else if(prob(33))
				var/turf/simulated/floor/tile = T
				if(istype(tile))
					tile.break_tile()