/datum/game_mode/survival
	name = "survival"
	config_tag = "survival"
	required_players = 0
	votable = 0
	var/wave_delay = 10 MINUTES
	var/stop_waves = TRUE
	var/spawn_time = 0
	var/wave_coeff = 1
	var/current_wave = 1
	var/tier = 1

	var/supply_points = 2

	var/evac_delay = 65 MINUTES	//time to shuttle activation
	var/end_time			// timeofday when evac is ready
	var/shuttle_location = 0     // 0 - on planet, 1 - out of game

/datum/game_mode/survival/announce()
	to_chat(world, "<B>The current game mode is - Survival!</B>")
//	to_chat(world, "<B>[sanitize("Рядовая спасательная операция пошла совсем не так, как ожидалось и теперь, помощь нужна вам самим.")]</B>")


/datum/game_mode/survival/post_setup()
/*
	var/output_text = {"<font color='red'>============Что здесь происходит============</font><BR>
	[sanitize("1. Вы член экипажа 'Аякса' - патрульного корвета посланного исследовать сигнал СОС в систему звезды HR 4979 (примерно 67 световых года от Солнца), посланный исследовательской станцией с одного из газовых гигантов системы.")]<BR>
	[sanitize("2. Небольшая колония Тей Тенга расположена на единственной обитаемой планеты системы, основанная только ради исследования следов вымершей цивилизации, жившей здесь столетия назад.")]<BR>
	[sanitize("3. При подлёте к цели, по неивзестным причинам 'Аякс' получает повреждения, несовместимые с дальнейшим функционированием и вы вынуждены спешно эвакуироваться на ближайшую луну - HR 4979 Vf - вулканическую планету, едва ли пригодную для жизни людей.")]<BR>
	[sanitize("4. Вы понятия не имеете, что здесь произошло и всё, с чем вы здесь столкнётесь, будет полной неожиданностью для вас.")]<BR>
	[sanitize("5. Перед крушением был послан сигнал бедствия и вам нужно лишь дождаться прибытия помощи.")]
	"}

	for(var/mob/living/M in player_list)
		M << browse(entity_ja(output_text), "window=doom;size=600x300")
	SSweather.eligible_zlevels.Add(1)
*/
	end_time = world.timeofday + evac_delay
	addtimer(CALLBACK(src, .proc/call_shuttle), 3000)

/datum/game_mode/survival/process()
	var/live_players = 0
	for(var/mob/living/M in player_list)
		if (M.client && M.stat != DEAD)
			live_players++
	if(!live_players)
		return

	if(stop_waves)
		return
	if(spawn_time > world.time)
		return

	spawn_time = world.time + wave_delay

	for (var/i in 1 to tier)
		var/obj/effect/landmark/invasion_start/start = pick(invasion_starts)
	//	if(locate(/obj/effect/mob_spawner) in start.loc)	continue
		var/obj/effect/mob_spawner/S = new /obj/effect/mob_spawner(start.loc)

		S.id = start.id
		S.coeff = wave_coeff
		S.mobs_list = get_tier(i)

	current_wave++
	supply_points++

	if(tier < 3 && live_players > 3)
		wave_coeff += 1
	if((current_wave/2 > tier) && (tier < 3))
		tier++

/datum/game_mode/survival/proc/get_tier(tier = 1)
	if(tier == 1)
		return tier_1.Copy()
	else if(tier == 2)
		return tier_2.Copy()
	else if(tier == 3)
		return tier_3.Copy()

/datum/game_mode/survival/check_finished()
	if(SSshuttle.location==2 || shuttle_location == 1)
		return TRUE
	return FALSE

/datum/game_mode/survival/proc/call_shuttle()
	if (!ticker)
		return

	stop_waves = FALSE
//	message_admins("Gamemode has called the shuttle.")
//	log_game("Gamemode has called the shuttle.")


/datum/game_mode/survival/proc/time_left()
	var/timeleft = round((end_time - world.timeofday)/10 ,1)
	if(timeleft < 0)
		timeleft = 0
	return timeleft

/datum/game_mode/survival/proc/get_timer()
	var/timeleft = time_left()
	if(timeleft)
		return "[add_zero(num2text((timeleft / 60) % 60),2)]:[add_zero(num2text(timeleft % 60), 2)]"
	return ""