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

	dat += "����������� ���������� � �����, ���������� � ���������� ��������������"
//	dat += "<span>Welcome, <b>Alan Simons</b></span><br>"
//	dat += "<span><b>Current Time:</b> [round(world.time / 36000)]:[add_zero("[world.time / 600 % 60]", 2)]:[add_zero("[world.time / 10 % 60]", 2)]</span><br>"
//
//	dat += "<center><b><a href='?src=\ref[src];show_logs=1'>����������� ������</a></center></b><br>"
//	dat += "<table border=1><tr><td>��� ������� ������� ��������� ������ ������, ����������� ����� [(text2num(time2text(world.realtime, "DD"))-1)].[time2text(world.timeofday, "MM")].[game_year], ����� 22:15."
//	dat += "�� ���� ������ �����������, ���� ������ ������� ����� � �������� �������� ������. ������ � ������� ��������, �� ������� ���� ������ ������ � ����������� ������ ���������, ����� ������ ����������� ��� ��� ���-������, ��� ����� ����, ����� ����� ���� ������ ���������� � ������������. ����� � ���������� ��������� ������ �� ������� ������� �����.</td></tr>"
//	dat += "<tr><td>����, �� �������� ��� ��� �����, ����� � ������ 10 ����� ���� �������� �������������� ������ �� ����������� ���������. ����� ����� ����� ���� ��� ���� ���������, �� ����� ����� � ����� � �� ������ �� ����."
//	dat += "� ���������� �������� �������������, �� � ���� ����� ������������� ������ ������� �� ����� ������� � �������� � ������ �������, ����� ��� ��������������� ��������� �� ������-4. � ��� ������, � ����� �� �����, ��� ��������� ���-�� ���������."
//	dat += "������, ������ � ���� �� ��� ����� ��� � �� ��������� � ��� �� �� ����� ���� �����������.</tr></td>"

//	dat += "<tr><td>� ����� �� ��������� ��������: �, ��� ����, ������ ������, ������ ������,  "
//	dat +=	"[round(world.time / 36000)]:[add_zero("[world.time / 600 % 60]", 2)]:[add_zero("[world.time / 10 % 60]", 2)]<BR>"
	var/datum/browser/popup = new(user, "out_com", "Communications", 600, 700)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(icon, icon_state))
	popup.open()
/*
/obj/machinery/computer/outpost_comms/ui_interact(mob/user)
	var/dat = "<html><head><title>Communications</title></head><body>"

	dat += "<span>Welcome, <b>Alan Simons</b></span><br>"
	dat += "<span><b>Current Time:</b> [round(world.time / 36000)]:[add_zero("[world.time / 600 % 60]", 2)]:[add_zero("[world.time / 10 % 60]", 2)]</span><br>"

	if(mode == 0)
		dat += "<center><b><a href='?src=\ref[src];show_logs=1'>������ ������� �����</a></center></b><br>"

		dat += "<table border=1><tr><th>� �/�</th><th>����, �����</th><th>���</th><th>���������</th></tr>"
		dat += "<tr align='center'><td>1</td><td>[(text2num(time2text(world.realtime, "DD"))-3)].[time2text(world.timeofday, "MM")].[game_year]-16:42:32</td><td>����</td><td>RE:��������� ����� � ���������� � ����������� ����������� �� 24 ����</td></tr>"

		dat += "<tr align='center'><td>2</td><td>[(text2num(time2text(world.realtime, "DD"))-2)].[time2text(world.timeofday, "MM")].[game_year]-8:02:4</td><td>��������</td><td>RE:���������� �����</td></tr>"

		dat += "<tr align='center'><td>3</td><td>[(text2num(time2text(world.realtime, "DD"))-2)].[time2text(world.timeofday, "MM")].[game_year]-9:58:6</td><td>����</td><td>��������! ��� ��������� ������� ������������������ �������� ����������."
		dat += "� ���������� ������������ �������� ����� ��������� �������� �������������� ���������� � ����������� ���������! </td></tr>"

		dat += "<tr align='center'><td>4</td><td>[(text2num(time2text(world.realtime, "DD"))-2)].[time2text(world.timeofday, "MM")].[game_year]-9:58:48</td><td>����</td><td>#4nd%;f4y6,�%-BZZZZZZZT</td></tr>"

		dat += "<tr align='center'><td>5</td><td>[(text2num(time2text(world.realtime, "DD"))-2)].[time2text(world.timeofday, "MM")].[game_year]-9:59:52</td><td>��������</td><td>����������� ����</td></tr>"
		dat += "</table>"

	if(mode == 1)
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
*/
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

	dat += "<table border=1><tr><th>� �/�</th><th>���, �������</th><th>���������</th></tr>"

//	dat += "<tr align='center'><td>���� ������-4</td></tr>"

	dat += "<tr align='center'><td>1</td><td>���� �������</td><td>��������� �����</td></tr>"

	dat += "<tr align='center'><td>2</td><td>���� �����</td><td>��������� ��</td></tr>"
	dat += "<tr align='center'><td>3</td><td>����� �������</td><td>��������� ��</td></tr>"
	dat += "<tr align='center'><td>4</td><td>��� ����</td><td>��������� ��</td></tr>"

	dat += "<tr align='center'><td>5</td><td>����� ���</td><td>��������</td></tr>"
	dat += "<tr align='center'><td>6</td><td>������ ������</td><td>��������</td></tr>"

	dat += "<tr align='center'><td>7</td><td>���� ����</td><td>������</td></tr>"
	dat += "<tr align='center'><td>8</td><td>���� ������</td><td>����������� ������</td></tr>"

	dat += "<tr align='center'><td>9</td><td>����� ������</td><td>������������ ������</td></tr>"

	dat += "<tr align='center'><td>10</td><td>���� ����</td><td>������� ���������</td></tr>"
	dat += "<tr align='center'><td>8</td><td>������� ������</td><td>������� ���������</td></tr>"


	var/datum/browser/popup = new(user, "out_crew", "������ ��������� ������� ������-4", 600, 700)
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
	var/dat = "<html><head><title>�������� ����</title></head><body>"

	dat += "����������� ���������� � �����, ���������� � ���������� ��������������"


	var/datum/browser/popup = new(user, "out_crew", "Crew Manifest", 600, 700)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(icon, icon_state))
	popup.open()


/obj/machinery/camera/outpost
	network = list("Outpost")