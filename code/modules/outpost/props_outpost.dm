/obj/item/device/plot_pda
	name = "Electronic tablet"
	icon = 'code/modules/outpost/outpost_items.dmi'
	icon_state = "tablet"

/obj/item/device/plot_pda/attack_self(mob/user)
	var/dat = "<html><head><title>Communications</title></head><body>"

	dat += "<span>Welcome, <b>Alan Simons</b></span><br>"
	dat += "<span><b>Current Time:</b> [round(world.time / 36000)]:[add_zero("[world.time / 600 % 60]", 2)]:[add_zero("[world.time / 10 % 60]", 2)]</span><br>"

	dat += "<center><b><a href='?src=\ref[src];show_logs=1'>Оперативный журнал</a></center></b><br>"
	dat += "<table border=1><tr><td>Это начальник смены участка Дельта-4 Алан Саймонс, сегодняшнее число [(text2num(time2text(world.realtime, "DD"))-1)].[time2text(world.timeofday, "MM")].[game_year], время 22:15."
	dat += "Я копирую свои личные записи в оперативный журнал аванпоста, чтобы группа Таркнассуса или ещё кто-нибудь, кто придёт сюда, могли иметь чуть больше информации о происходящем. Также я скопировал отдельные записи из журнала сеансов связи.</td></tr>"
	dat += "<tr><td>Итак, всё началось два дня назад, когда в районе 10 часов утра поступил автоматический сигнал об немедленной эвакуации. Сразу после этого было ещё одно сообщение, но кроме помех и шумов в нём ничего не было."
	dat += "Я немедленно запросил подтверждение, но в тоже время продублировал сигнал тревоги по всему участку и связался с каждой группой, чтобы они незамедлительно вернулись на Дельту-4. В тот момент, я лично не думал, что случилось что-то серьёзное."
	dat += "Однако, ответа с базы за это время так и не поступило и это не на шутку меня встревожило.</tr></td>"

	dat += "<tr><td>В итоге на аванпосту остались: я, Роб Финч, Тереза Палмер, Гектор Маккри,  "
//	dat +=	"[round(world.time / 36000)]:[add_zero("[world.time / 600 % 60]", 2)]:[add_zero("[world.time / 10 % 60]", 2)]<BR>"
	var/datum/browser/popup = new(user, "out_com", "Communications", 600, 700)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(icon, icon_state))
	popup.open()

/obj/structure/cargo_container
	name = "Cargo Container"
	desc = "A huge industrial shipping container."
	icon = 'icons/obj/structures/contain.dmi'
	icon_state = "blue"
	bound_width = 32
	bound_height = 64
	density = TRUE
	opacity = TRUE
	anchored = TRUE

/obj/structure/cargo_container/red
	icon_state = "red"

/obj/structure/cargo_container/green
	icon_state = "green"

/obj/structure/cargo_container/nt
	icon_state = "NT"

/obj/structure/cargo_container/hd
	icon_state = "HD"

/obj/structure/cargo_container/ch_red
	icon_state = "ch_red"

/obj/structure/cargo_container/ch_green
	icon_state = "ch_green"

/obj/structure/cargo_container/hd_blue
	icon_state = "HD_blue"

/obj/structure/cargo_container/gorg
	icon_state = "gorg"

/obj/structure/cargo_container/horizontal
	name = "Cargo Container"
	desc = "A huge industrial shipping container,"
	icon = 'icons/obj/structures/containHorizont.dmi'
	icon_state = "blue"
	bound_width = 64
	bound_height = 32
	density = TRUE
	opacity = TRUE