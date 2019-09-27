var/list/tier_1 = list(/mob/living/simple_animal/hostile/hellspawn/zombie/civilian = 3,\
						/mob/living/simple_animal/hostile/hellspawn/hellrunner = 3,\
						/mob/living/simple_animal/hostile/hellspawn/imp = 4)

var/list/tier_2 = list(/mob/living/simple_animal/hostile/hellspawn/imp = 5,\
						/mob/living/simple_animal/hostile/hellspawn/imp/fire = 3,\
						/mob/living/simple_animal/hostile/hellspawn/imp/fast = 3,)

var/list/tier_3 = list(/mob/living/simple_animal/hostile/hellspawn/imp/fire/dark = 4,\
						/mob/living/simple_animal/hostile/hellspawn/hellknight = 2,\
						/mob/living/simple_animal/hostile/hellspawn/mancubus/cyber = 1)

/obj/effect/mob_spawner
	name = "portal"
	desc = "A direct link to another dimension full of creatures not very happy to see you"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "portal"
	anchored = TRUE
	density = TRUE
	color = "red"
	var/id = ""
	var/list/mobs_list = list(/mob/living/simple_animal/hostile/hellspawn, /mob/living/simple_animal/hostile/hellspawn/zombie)
	var/spawn_text = "emerges from"
	var/spawn_time = 50 //5 seconds default
	var/spawn_delay = 0
	var/tier = 1
	var/coeff = 1


/obj/effect/mob_spawner/atom_init()
	. = ..()
	if(mobs_list.len)
		START_PROCESSING(SSobj, src)
	else
		return INITIALIZE_HINT_QDEL

/obj/effect/mob_spawner/process()
	if(mobs_list.len)
		try_spawn_mob()
	else
		STOP_PROCESSING(SSobj, src)
		qdel(src)

/obj/effect/mob_spawner/proc/try_spawn_mob()
	if(spawn_delay > world.time)
		return
	spawn_delay = world.time + spawn_time
	var/mob/living/simple_animal/hostile/hellspawn/chosen_mob = pick(mobs_list)  //pick_n_take doesn't work here
	var/list/surrounding_turfs = block(locate(x - 1, y - 1, z), locate(x + 1, y + 1, z))
	var/squad_size = round(tier_1[chosen_mob] + coeff)
	for(var/i in 1 to squad_size)
		var/mob/living/simple_animal/hostile/hellspawn/L = new chosen_mob(pick(surrounding_turfs))
		L.spawn_point = loc
		if(waypoints.len)
			L.rally_point = L.give_waypoint(1,id)
			L.stance = HOSTILE_STANCE_RUSHING
	mobs_list -= chosen_mob
	playsound(src, 'sound/effects/portal_spawn.ogg', 100, 1)
	visible_message("<span class='danger'>Someone [spawn_text] [src].</span>")

/obj/effect/mob_spawner/tier_1
	mobs_list = list(/mob/living/simple_animal/hostile/hellspawn/zombie/civilian = 6,\
						/mob/living/simple_animal/hostile/hellspawn/zombie/service = 6,\
						/mob/living/simple_animal/hostile/hellspawn/hellrunner = 4,\
						/mob/living/simple_animal/hostile/hellspawn/imp = 6,\
						/mob/living/simple_animal/hostile/hellspawn/imp/fire = 4,\
						/mob/living/simple_animal/hostile/hellspawn/imp/fire/dark = 3,\
						/mob/living/simple_animal/hostile/hellspawn/hellknight = 2,\
						/mob/living/simple_animal/hostile/hellspawn/mancubus = 2,\
						/mob/living/simple_animal/hostile/hellspawn/mancubus/cyber = 1)

/obj/effect/mob_spawner/tier_2
	mobs_list = list(/mob/living/simple_animal/hostile/hellspawn/zombie/civilian = 6,/mob/living/simple_animal/hostile/hellspawn/zombie/service = 6,/mob/living/simple_animal/hostile/hellspawn/hellrunner = 4,/mob/living/simple_animal/hostile/hellspawn/imp = 5)

