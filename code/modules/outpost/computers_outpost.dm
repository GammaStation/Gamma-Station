/obj/machinery/computer/monitor/outpost
	icon = 'icons/obj/computer-new.dmi'

/obj/machinery/computer/station_alert/outpost
	name = "Outpost Alert Console"
	desc = "Used to access the outpost's automated alert system."
	icon = 'icons/obj/computer-new.dmi'

/obj/machinery/computer/security/outpost
	name = "security camera monitor"
	desc = "Used to access the various cameras on the outpost."
	icon = 'icons/obj/computer-new.dmi'
	icon_state = "cameras"
	light_color = "#a91515"
	network = list("Outpost")

/obj/machinery/computer/outpost_comms
	name = "Communications Console"
	desc = "This can be used for communications."
	icon = 'icons/obj/computer-new.dmi'
	icon_state = "comm_monitor"
	light_color = "#00b000"
	var/mode = 1

/obj/machinery/computer/outpost_comms/ui_interact(mob/user)
	var/dat = "<html><head><title>Communications</title></head><body>"
	dat += "<span><b>Текущее время:</b> [(text2num(time2text(world.realtime, "DD")))].[time2text(world.timeofday, "MM")].[game_year]-[round(world.time / 36000)]:[add_zero("[world.time / 600 % 60]", 2)]:[add_zero("[world.time / 10 % 60]", 2)]</span><br>"
	if(ticker && istype(ticker.mode,/datum/game_mode/survival))
		var/datum/game_mode/survival/gamemode = ticker.mode
		dat += "Экстремальные погодные условия - примерное время окончания: [gamemode.get_timer()]"


	var/datum/browser/popup = new(user, "out_com", "Communications", 600, 700)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(icon, icon_state))
	popup.open()

/obj/machinery/computer/outpost_comms/process()
	if(..())
		updateUsrDialog()

/obj/machinery/computer/outpost_comms/Topic(href, href_list)
	. = ..()
	if(!.)
		return

	if (href_list["show_logs"])
		mode = !mode

	updateUsrDialog()

/obj/machinery/computer/outpost_crew
	name = "Security Laptop"
	desc = "Used to view personnel's employment records."
	icon_state = "laptop"
	icon = 'icons/obj/computer-new.dmi'
	light_color = "#a91515"

/obj/machinery/computer/outpost_crew/ui_interact(mob/user)
	var/dat = "<html><head><title>Crew Manifest</title></head><body>"

	dat += "<table border=1><tr><th>№ п/п</th><th>Имя, фамилия</th><th>Должность</th></tr>"

//	dat += "<tr align='center'><td>Пост Дельта-4</td></tr>"

	dat += "<tr align='center'><td>1</td><td>Алан Саймонс</td><td>Начальник смены</td></tr>"

	dat += "<tr align='center'><td>2</td><td>Марк Райан</td><td>Сотрудник СБ</td></tr>"
	dat += "<tr align='center'><td>3</td><td>Генри Нельсон</td><td>Сотрудник СБ</td></tr>"
	dat += "<tr align='center'><td>4</td><td>Роб Финч</td><td>Сотрудник СБ</td></tr>"

	dat += "<tr align='center'><td>5</td><td>Эндрю Чин</td><td>Фельдшер</td></tr>"
	dat += "<tr align='center'><td>6</td><td>Тереза Палмер</td><td>Фельдшер</td></tr>"

	dat += "<tr align='center'><td>7</td><td>Джон Кинг</td><td>Техник</td></tr>"
	dat += "<tr align='center'><td>8</td><td>Леон Невилл</td><td>Атмосферный Техник</td></tr>"

	dat += "<tr align='center'><td>9</td><td>Генри Маккри</td><td>Руководитель группы</td></tr>"

	dat += "<tr align='center'><td>10</td><td>Джон Кинг</td><td>Научный сотрудник</td></tr>"
	dat += "<tr align='center'><td>8</td><td>Джулиан Бейкер</td><td>Научный ассистент</td></tr>"


	var/datum/browser/popup = new(user, "out_crew", "Список персонала участка Дельта-4", 600, 700)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(icon, icon_state))
	popup.open()

/obj/machinery/computer/outpost_brig
	name = "Security console"
	desc = ""
	icon_state = "security"
	icon = 'icons/obj/computer-new.dmi'
	light_color = "#00b000"

/obj/machinery/computer/outpost_brig/ui_interact(mob/user)
	var/dat = "<html><head><title>Охранная сеть</title></head><body>"

	dat += "Отсутствует соединение с сетью, обратитесь к системному администратору"


	var/datum/browser/popup = new(user, "out_crew", "Crew Manifest", 600, 700)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(icon, icon_state))
	popup.open()


/obj/machinery/camera/outpost
	network = list("Outpost")