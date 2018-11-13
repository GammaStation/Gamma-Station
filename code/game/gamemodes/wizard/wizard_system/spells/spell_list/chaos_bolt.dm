/obj/effect/proc_holder/magic/click_on/shoot/chaos_bolt
	name = "Bolt of chaos"
	desc = ""
	mana_cost = CHAOS_BOLT_MANACOST
	projectile = /obj/item/projectile/magic/chaos_bolt

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
	Mx.Scale(1.3)
	transform = Mx
	color = "#000000"


/obj/item/projectile/magic/chaos_bolt/on_hit(atom/target)
	if(!isliving(target))
		return

	if(istype(target, /mob/living/silicon))
		return  //No robots should be affected by this.

	var/mob/living/carbon/human/victim = target

	if(victim.dna)
		if(prob(CHAOS_BOLT_IDENTITY_MUTATION_CHANCE))
			randmuti(victim)
		if(prob(CHAOS_BOLT_BAD_MUTATION_CHANCE))
			randmutb(victim)
		if(prob(CHAOS_BOLT_GOOD_MUTATION_CHANCE))
			randmutg(victim)
		domutcheck(victim, null)
		victim.UpdateAppearance()

	return ..()

#undef CHAOS_BOLT_MANACOST
#undef CHAOS_BOLT_DAMAGE
#undef CHAOS_BOLT_IDENTITY_MUTATION_CHANCE
#undef CHAOS_BOLT_BAD_MUTATION_CHANCE
#undef CHAOS_BOLT_GOOD_MUTATION_CHANCE
