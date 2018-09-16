/obj/effect/ectospawner
	name = "ectoplasm spawner"
	desc = "Set ec_amount variable to choose how much ectoplasm to spawn"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "ectoplasm"
	var/ec_amount = 4 // 4 pieces of ectoplasm spawned somewhere in maintenance.

/obj/effect/ectospawner/atom_init()
	..()
	var/list/possible_spawns = list()
	for(var/turf/T in get_area_turfs(/area/maintenance))
		if(!T.density)
			possible_spawns += T

	if(possible_spawns.len)
		for(var/i in 1 to ec_amount)
			var/turf/T = pick(possible_spawns)
			if(!T) // it seems such turfs don't exist. to prevent infinite looping, let's just... screw off
				break
			var/obj/item/I = new /obj/item/weapon/reagent_containers/food/snacks/ectoplasm(T)
	return INITIALIZE_HINT_QDEL