/datum/game_mode/survival
	name = "survival"
	config_tag = "survival"
	var/wave_delay = 10 MINUTES
	var/stop_waves = TRUE
	var/spawn_time = 0
	var/wave_coeff = 1
	var/current_wave = 1
	var/tier = 1
	required_players = 0
	votable = 0

/datum/game_mode/survival/announce()
	to_chat(world, "<B>The current game mode is - Survival!</B>")
	to_chat(world, "<B>[sanitize("������� ������������ �������� ����� ������ �� ���, ��� ��������� � ������, ������ ����� ��� �����.")]</B>")


/datum/game_mode/survival/post_setup()
	var/output_text = {"<font color='red'>============��� ����� ����������============</font><BR>
	[sanitize("1. �� ���� ������� '�����' - ����������� ������� ���������� ����������� ������ ��� � ������� ������ HR 4979 (�������� 67 �������� ���� �� ������), ��������� ����������������� �������� � ������ �� ������� �������� �������.")]<BR>
	[sanitize("2. ��������� ������� ��� ����� ����������� �� ������������ ��������� ������� �������, ���������� ������ ���� ������������ ������ �������� �����������, ������ ����� �������� �����.")]<BR>
	[sanitize("3. ��� ������ � ����, �� ����������� �������� '����' �������� �����������, ������������� � ���������� ����������������� � �� ��������� ������ �������������� �� ��������� ���� - HR 4979 Vf - ������������� �������, ���� �� ��������� ��� ����� �����.")]<BR>
	[sanitize("4. �� ������� �� ������, ��� ����� ��������� � ��, � ��� �� ����� ����������, ����� ������ �������������� ��� ���.")]<BR>
	[sanitize("5. ����� ��������� ��� ������ ������ �������� � ��� ����� ���� ��������� �������� ������.")]
	"}

	for(var/mob/living/M in player_list)
		M << browse(entity_ja(output_text), "window=doom;size=600x300")
	SSweather.eligible_zlevels.Add(1)
	addtimer(CALLBACK(src, .proc/call_shuttle), 3000)

/datum/game_mode/survival/process()
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
//		var/D = text2path("/tier_[tier]")
//		to_chat(world,"[D]")
//		to_chat(world,"[S] - [i] - [tier] -[S.mobs_list.len]")
	current_wave++

	if(tier < 3)
		wave_coeff += 1
	if((current_wave/2 > tier) && (tier < 3))
		tier++

datum/game_mode/survival/proc/get_tier(tier = 1)
	if(tier == 1)
		return tier_1.Copy()
	else if(tier == 2)
		return tier_2.Copy()
	else if(tier == 3)
		return tier_3.Copy()

/*
/datum/game_mode/check_finished()
	if(SSshuttle.location==2 || station_was_nuked)
		return 1
	return 0
	*/
/datum/game_mode/survival/proc/call_shuttle()
	if ((!( ticker ) || SSshuttle.location))
		return

	SSshuttle.incall()
	stop_waves = FALSE
	message_admins("Gamemode has called the shuttle.")
	log_game("Gamemode has called the shuttle.")