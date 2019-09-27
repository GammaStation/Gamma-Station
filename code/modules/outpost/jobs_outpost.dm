/var/const/access_outpost_general = 701
/var/const/access_outpost_security = 702
/var/const/access_outpost_engineer = 703
/var/const/access_outpost_command = 704
/var/const/access_outpost_medical = 705


/obj/item/weapon/card/id/outpost
	name = "identification card"
	desc = "An identification card issued to Callinex Mining Corporation's personnel."
	icon = 'code/modules/outpost/outpost_clothing.dmi'
	icon_state = "outpost_id"

/obj/item/weapon/card/id/outpost/eng
	icon_state = "id-eng"
	access = list(access_outpost_general,access_outpost_engineer)

/obj/item/weapon/card/id/outpost/sec
	icon_state = "id-sec"
	access = list(access_outpost_general,access_outpost_engineer, access_outpost_security, access_outpost_medical, access_outpost_command)
