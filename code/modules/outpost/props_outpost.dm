/obj/item/device/plot_pda
	name = "Electronic tablet"
	icon = 'code/modules/outpost/outpost_items.dmi'
	icon_state = "tablet"

/obj/item/device/plot_pda/attack_self(mob/user)
	var/dat = "<html><head><title>Communications</title></head><body>"

	dat += "<span>Welcome, <b>Alan Simons</b></span><br>"
	dat += "<span><b>Current Time:</b> [round(world.time / 36000)]:[add_zero("[world.time / 600 % 60]", 2)]:[add_zero("[world.time / 10 % 60]", 2)]</span><br>"

	dat += "<center><b><a href='?src=\ref[src];show_logs=1'>����������� ������</a></center></b><br>"
	dat += "<table border=1><tr><td>��� ��������� ����� ������� ������-4 ���� �������, ����������� ����� [(text2num(time2text(world.realtime, "DD"))-1)].[time2text(world.timeofday, "MM")].[game_year], ����� 22:15."
	dat += "� ������� ���� ������ ������ � ����������� ������ ���������, ����� ������ ����������� ��� ��� ���-������, ��� ����� ����, ����� ����� ���� ������ ���������� � ������������. ����� � ���������� ��������� ������ �� ������� ������� �����.</td></tr>"
	dat += "<tr><td>����, �� �������� ��� ��� �����, ����� � ������ 10 ����� ���� �������� �������������� ������ �� ����������� ���������. ����� ����� ����� ���� ��� ���� ���������, �� ����� ����� � ����� � �� ������ �� ����."
	dat += "� ���������� �������� �������������, �� � ���� ����� ������������� ������ ������� �� ����� ������� � �������� � ������ �������, ����� ��� ��������������� ��������� �� ������-4. � ��� ������, � ����� �� �����, ��� ��������� ���-�� ���������."
	dat += "������, ������ � ���� �� ��� ����� ��� � �� ��������� � ��� �� �� ����� ���� �����������.</tr></td>"

	dat += "<tr><td>� ����� �� ��������� ��������: �, ��� ����, ������ ������, ������ ������,  "
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