/obj/structure/cult/tome/wizard
	name = "Magical desk"
	desc = "A desk covered in arcane manuscripts and tomes in unknown languages. Wizards store here their memories"
	icon_state = "tomealtar"

/obj/structure/cult/tome/wizard/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!iswizard(user))
		to_chat(user, "<span class='warning'>You're pretty sure you know exactly what this is used for and you can't seem to touch it.</span>")
		return

	var/list/magicschools = list("Conjuration", "Ergokinesis", "Dimensional Manipulation", "Biokinesis", "Maleficium", "Mysticism", "Elemental Arts")
	var/magicschool = input(user, "Magic Schools") in magicschools


	if(src && !QDELETED(src) && Adjacent(user) && !user.stat && iswizard(user))
		if(user.mind.wizard_power_system.learned_schools.len >= 3)
			to_chat(user, "<span class='cultitalic'>You can't learn any more schools!</span>")
			return
		if(magicschool in user.mind.wizard_power_system.learned_schools)
			to_chat(user, "<span class='cultitalic'>You already know about [magicschool]!</span>")
			return
		user.mind.wizard_power_system.learned_schools += magicschool
		to_chat(user, "<span class='cultitalic'>You whisper a spell, making knowledge about [magicschool] flooding into your head!</span>")