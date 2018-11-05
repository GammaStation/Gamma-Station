/obj/structure/trap
	name = "IT'S A TARP"
	desc = "stepping on me is a guaranteed bad day"
	icon = 'icons/obj/flora/traps.dmi'
	icon_state = "trap"
	density = 0
	anchored = TRUE
	alpha = 30
	var/static/list/ignore_typecache
	var/mob/living/caster

/obj/structure/trap/atom_init(mapload, mob/living/creator)
	. = ..()
	if(!ignore_typecache)
		ignore_typecache = typecacheof(list(/obj/effect, /mob/dead))
	caster = creator

/obj/structure/trap/examine(mob/user)
	..()
	if(!isliving(user))
		return
	if(get_dist(user, src) <= 1)
		to_chat(user, "<span class='notice'>You reveal [src]!</span>")
		flare()

/obj/structure/trap/proc/flare()
	// Makes the trap visible, and starts the cooldown until it's
	// able to be triggered again.
	new /obj/effect/effect/sparks(get_turf(src))
	visible_message("<span class='warning'>[src] flares brightly!</span>")
	qdel(src)

/obj/structure/trap/Crossed(atom/movable/AM)
	// Don't want the traps triggered by sparks, ghosts or projectiles.
	if(is_type_in_typecache(AM, ignore_typecache))
		return
	if(caster == AM)
		return
	flare()
	if(isliving(AM))
		trap_effect(AM)

/obj/structure/trap/proc/trap_effect(mob/living/L)
	return

/obj/structure/trap/stun
	name = "shock trap"
	desc = "A trap that will shock and render you immobile. You'd better avoid it."
	icon_state = "trap-shock"

/obj/structure/trap/stun/trap_effect(mob/living/L)
	L.electrocute_act(25, src) // electrocute act does a message.

/obj/structure/trap/fire
	name = "flame trap"
	desc = "A trap that will set you ablaze. You'd better avoid it."
	icon_state = "trap-fire"

/obj/structure/trap/fire/trap_effect(mob/living/L)
	to_chat(L, "<span class='danger'>Spontaneous combustion!</span>")
	L.fire_act()
	L.adjust_fire_stacks(10)

/obj/structure/trap/chill
	name = "frost trap"
	desc = "A trap that will chill you to the bone. You'd better avoid it."
	icon_state = "trap-frost"

/obj/structure/trap/chill/trap_effect(mob/living/L)
	to_chat(L, "<span class='danger'>You're frozen solid!</span>")
	L.bodytemperature -= 300
	L.reagents.add_reagent("frostoil", 15)

/obj/structure/trap/damage
	name = "earth trap"
	desc = "A trap that will summon a small earthquake, just for you. You'd better avoid it."
	icon_state = "trap-earth"

/obj/structure/trap/damage/trap_effect(mob/living/L)
	to_chat(L, "<span class='danger'>The ground quakes beneath your feet!</span>")
	L.adjustBruteLoss(40)

/obj/structure/trap/damage/flare()
	. = ..()
	var/obj/structure/rock/giant_rock = new (get_turf(src))
	QDEL_IN(giant_rock, 200)

/obj/structure/rock
	icon_state = "basalt"
	desc = "A volcanic rock"
	icon = 'icons/obj/flora/rocks.dmi'
	density = 1
	anchored = 1

/obj/structure/rock/atom_init()
	. = ..()
	icon_state += pick("1", "2", "3")

/obj/structure/trap/ward
	name = "divine ward"
	desc = "A divine barrier, It looks like you could destroy it with enough effort, or wait for it to dissipate..."
	icon_state = "ward"
	density = 1


/obj/structure/trap/ward/atom_init()
	. = ..()
	QDEL_IN(src, 1200)

