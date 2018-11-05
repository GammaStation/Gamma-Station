/obj/effect/proc_holder/magic/click_on/illusion
	name = "Decoy"
	desc = ""
	mana_cost = ILLUSION_MANACOST
	types_to_click = list("objects","mobs", "turfs")
	var/obj/effect/dummy/chameleon/illusion/scanned = null


/obj/effect/dummy/chameleon/illusion/proc/copy(atom/target)		//Atom because either mob or obj/item
	name = target.name
	desc = target.desc
	density = target.density
	anchored = FALSE
	appearance = target.appearance
	current_type = target.type
	layer = initial(target.layer)
	plane = initial(target.plane)



/obj/effect/proc_holder/magic/click_on/illusion/atom_init()
	. = ..()
	scanned = new

// Fix tables and other questionable objects

/obj/effect/proc_holder/magic/click_on/illusion/cast_on_mob(mob/living/target)
	to_chat(owner.current, "<font color='purple'><i>I scanned the [target]! Now I can create decoys of it!</i></font>")
	scanned.copy(target)


/obj/effect/proc_holder/magic/click_on/illusion/cast_on_object(obj/target)			//It can also scan stuff like tables and copy them. Should I leave it so? Creating illusions of tables and pulling them around sounds fun, but...
	to_chat(owner.current, "<font color='purple'><i>I scanned the [target]! Now I can create decoys of it!</i></font>")
	scanned.copy(target)

//obj item
//get turf
/obj/effect/proc_holder/magic/click_on/illusion/cast_on_turf(turf/target)
	if(!scanned.current_type)
		to_chat(owner.current, "<font color='purple'><i>What do you want me to create?!</i></font>")		//Still spends mana here. Spell specific checks + istype
		return

	if(istype(target, /turf/simulated/wall))
		to_chat(owner.current, "<font color='purple'><i>How can I forge an illusion inside a wall?! You fool!</i></font>")
		return

	var/obj/effect/dummy/chameleon/illusion/decoy = new (target)
	decoy.copy(scanned)
	decoy.dir = owner.current.dir

	QDEL_IN(decoy, ILLUSION_LIFESPAN)

	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, decoy)
	spark_system.start()


/obj/effect/dummy/chameleon/illusion


/obj/effect/dummy/chameleon/illusion/Destroy()
	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.start()
	return ..()

/obj/effect/dummy/chameleon/illusion/attackby()
	Destroy()

/obj/effect/dummy/chameleon/illusion/attack_hand()
	Destroy()

/obj/effect/dummy/chameleon/illusion/ex_act()
	Destroy()

/obj/effect/dummy/chameleon/illusion/emp_act()
	Destroy()

/obj/effect/dummy/chameleon/illusion/bullet_act()
	Destroy()


#undef ILLUSION_MANACOST
#undef ILLUSION_LIFESPAN