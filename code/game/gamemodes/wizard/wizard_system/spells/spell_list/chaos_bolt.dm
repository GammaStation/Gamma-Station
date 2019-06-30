/obj/effect/proc_holder/magic/click_on/shoot/chaos_bolt
	name = "Arrow of darkness"
	desc = ""
	mana_cost = 0
	projectile = /obj/item/projectile/magic/chaos_bolt
	shootsound = 'sound/effects/dark_blast.ogg'

// Negative Energy

/obj/item/projectile/magic/chaos_bolt
	name = "bolt of chaos"
	icon_state = "ice_2"
	nodamage = FALSE
	damage = CHAOS_BOLT_DAMAGE

	damage_type = CLONE


/obj/item/projectile/magic/chaos_bolt/atom_init()
	. = ..()
	var/matrix/Mx = matrix()
	Mx.Scale(1.4)
	transform = Mx
	color = "#000000"


/obj/item/projectile/magic/chaos_bolt/on_hit(atom/target)
	if(!isliving(target))
		return

	if(istype(target, /mob/living/silicon))
		return  //No robots should be affected by this.

	var/mob/living/carbon/human/victim = target

	if(victim.dna)
		randmuti(victim)
		if(prob(95))
			randmutb(victim)
		else
			randmutg(victim)
		domutcheck(victim, null)
		victim.UpdateAppearance()

	return ..()

#undef CHAOS_BOLT_MANACOST
#undef CHAOS_BOLT_DAMAGE

