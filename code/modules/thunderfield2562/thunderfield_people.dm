#define SPAWN_PROTECTION_TIME 20 //Here we have some ugly sheet, which should be rewrited once
#define DEAD_DELETE_COUNTDOWN 20 //Pause before dead body gets qdeld
#define BRAINLOSS_PER_DEATH 20
#define POINTS_FOR_CHEATER 30
#define CLEANUP_COOLDOWN 800
#define POINTS_PER_SPAWN 3
/mob/living/carbon/human/vrhuman
	var/obj/screen/vrhuman_shop
	var/obj/screen/vrhuman_exit
	var/obj/screen/vrhuman_main
	var/obj/screen/vrhuman_cleanup
	var/obj/screen/vrhuman_dienow
	var/datum/mind/vr_mind
	var/died = FALSE                                    //Look death() proc here, for comments
	var/obj/item/device/uplink/hidden/vr_uplink/vr_shop //To buy stuff
	var/global/last_cleanup_time
	alpha = 127

/mob/living/carbon/human/vrhuman/atom_init()
	..()
	return INITIALIZE_HINT_LATELOAD

/mob/living/carbon/human/vrhuman/atom_init_late()
	..()
	generate_random_body()
	give_spawn_protection()
	vr_shop = new(src)

/mob/living/carbon/human/vrhuman/proc/generate_random_body()

	var/obj/randomcatcher/catcher = new /obj/randomcatcher(src)
	equip_to_slot_or_del(catcher.get_item(/obj/random/cloth/under), slot_w_uniform)
	equip_to_slot_or_del(catcher.get_item(/obj/random/cloth/shoes), slot_shoes)
	equip_to_slot_or_del(new /obj/item/weapon/extinguisher(src), slot_l_hand)
	qdel(catcher)

	gender = pick(MALE, FEMALE)
	if(gender == MALE)
		name = pick(first_names_male)
	else
		name = pick(first_names_female)
	name += " [pick(last_names)]"
	real_name = name

	var/datum/preferences/A = new()
	A.randomize_appearance_for(src)

	update_inv_shoes()
	update_inv_w_uniform()
	update_inv_l_hand()

/mob/living/carbon/human/vrhuman/proc/give_spawn_protection()
	status_flags ^= GODMODE
	animate(src, alpha = 255, time = SPAWN_PROTECTION_TIME)
	addtimer(CALLBACK(src, .proc/lift_spawn_protection), SPAWN_PROTECTION_TIME)

/mob/living/carbon/human/vrhuman/proc/lift_spawn_protection()
	status_flags ^= GODMODE
	revive()
	if(!vr_mind)//In case somebody spawned an empty mob
		return
	if(vr_mind.thunderfield_cheater)
		vr_mind.thunder_points += POINTS_FOR_CHEATER
	vr_mind.thunder_points += POINTS_PER_SPAWN
	to_chat(src, "<span class='danger'>You are respawned! Respawns left: [vr_mind.thunder_respawns]</span>")

/mob/living/carbon/human/vrhuman/death()
	if(died)                            //Dont know why this happen, but, in some cases (aka head torn off) death() is called multiple times, which causes ugly mess
		return
	died = TRUE
	var/obj/item/thunder_dog_tag/dog_tag = new /obj/item/thunder_dog_tag/(loc) //Spawning dog tag for players to get points
	if(!vr_mind)                        //Dont know, if we should keep it, but i prefer to leave it in case some dumbass with VV breaks smthng
		hide_body()
		return ..()
	if(vr_mind.thunder_points == 0)//We should reward killer even in case there is no points
		dog_tag.points = 1
	else
		dog_tag.points = vr_mind.thunder_points
	dog_tag = null
	vr_mind.thunder_points = 0
	if(vr_mind.thunder_respawns <= 0)
		vr_mind.transfer_to(vr_mind.thunderfield_owner)
		death_actions()
		return ..()
	var/obj/effect/landmark/spawnpoint = pick(thunderfield_spawns_list)
	var/mob/living/carbon/human/vrhuman/vrbody = new /mob/living/carbon/human/vrhuman(spawnpoint.loc)
	vrbody.vr_mind = vr_mind
	vr_mind.transfer_to(vrbody)
	death_actions()
	return ..()

/mob/living/carbon/human/vrhuman/proc/death_actions()
	vr_mind.thunder_respawns--
	if(vr_mind.thunderfield_cheater)
		vr_mind.thunderfield_owner.adjustBrainLoss(BRAINLOSS_PER_DEATH)
	hide_body()

/mob/living/carbon/human/vrhuman/proc/hide_body()
	animate(src, alpha = 0, time = DEAD_DELETE_COUNTDOWN)
	QDEL_IN(src, DEAD_DELETE_COUNTDOWN)

/mob/living/carbon/human/vrhuman/Destroy()
	vr_mind = null
	return ..()

/mob/living/carbon/human/vrhuman/proc/exit_body()
	var/answer = alert(src, "Would you like to exit VR?", "Alert", "Yes", "No")
	if(answer == "Yes")
		vr_mind.thunder_respawns = 0
		death()
	else
		return

/mob/living/carbon/human/vrhuman/proc/force_return()
	vr_mind.thunder_respawns = 0
	death()

/mob/living/carbon/human/vrhuman/proc/dienow()
	var/answer = alert(src, "Would you like to respawn?", "Alert", "Yes", "No")
	if(answer == "Yes")
		death()
	else
		return

/mob/living/carbon/human/vrhuman/ghost()
	return

/mob/living/carbon/human/vrhuman/verb/OpenShopMenu()
	set name = "Open Shop"
	set category = "IC"

	vr_shop.trigger(src)

/mob/living/carbon/human/vrhuman/verb/try_cleanup()
	if(world.time < (last_cleanup_time + CLEANUP_COOLDOWN))
		to_chat(src, "<span class='danger'>Please wait!</span>")
		return
	last_cleanup_time = world.time
	for(var/turf/unsimulated/floor/self_cleaning/sc in self_cleaning_list)
		sc.cleaner()

#undef SPAWN_PROTECTION_TIME
#undef DEAD_DELETE_COUNTDOWN
#undef BRAINLOSS_PER_DEATH
#undef POINTS_FOR_CHEATER
#undef CLEANUP_COOLDOWN
#undef POINTS_PER_SPAWN