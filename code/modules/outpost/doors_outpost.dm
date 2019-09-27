/obj/machinery/door/airlock/outpost
	icon = 'icons/obj/doors/airlocks/outpost/common.dmi'
	overlays_file = 'icons/obj/doors/airlocks/outpost/overlays.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_common_outpost
	door_open_sound          = 'sound/machines/airlock/DoorOpen.ogg'
	door_close_sound         = 'sound/machines/airlock/DoorClose.ogg'

/obj/machinery/door/airlock/outpost/glass
	opacity = FALSE
	glass   = TRUE

/obj/structure/door_assembly/door_assembly_common_outpost
	name         = "generic airlock assembly"
	icon         = 'icons/obj/doors/airlocks/outpost/common.dmi'
	glass_type   = /obj/machinery/door/airlock/outpost/glass
	airlock_type = /obj/machinery/door/airlock/outpost
	overlays_file = 'icons/obj/doors/airlocks/outpost/overlays.dmi'

/obj/machinery/door/airlock/outpost/external
	name = "external access"
	icon = 'icons/obj/doors/airlocks/outpost/external/external.dmi'
	overlays_file = 'icons/obj/doors/airlocks/outpost/external/overlays.dmi'
	opacity = FALSE
	assembly_type = /obj/structure/door_assembly/door_assembly_ext_outpost

/obj/structure/door_assembly/door_assembly_ext_outpost
	name             = "external airlock assembly"
	icon             = 'icons/obj/doors/airlocks/outpost/external/external.dmi'
	overlays_file    = 'icons/obj/doors/airlocks/outpost/external/overlays.dmi'
	airlock_type     = /obj/machinery/door/airlock/outpost/external
	can_insert_glass = FALSE


/obj/machinery/door/airlock/outpost/engineering
	icon = 'icons/obj/doors/airlocks/outpost/engineering.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_eng_outpost

/obj/machinery/door/airlock/outpost/engineering/glass
	opacity = FALSE
	glass   = TRUE

/obj/structure/door_assembly/door_assembly_eng_outpost
	name         = "engineering airlock assembly"
	icon         = 'icons/obj/doors/airlocks/outpost/engineering.dmi'
	glass_type   = /obj/machinery/door/airlock/outpost/engineering/glass
	airlock_type = /obj/machinery/door/airlock/outpost/engineering
	overlays_file = 'icons/obj/doors/airlocks/outpost/overlays.dmi'

/obj/machinery/door/airlock/outpost/atmos
	icon = 'icons/obj/doors/airlocks/outpost/atmos.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_atmos_outpost

/obj/machinery/door/airlock/outpost/atmos/glass
	opacity = FALSE
	glass   = TRUE

/obj/structure/door_assembly/door_assembly_atmos_outpost
	name         = "atmospherics airlock assembly"
	icon         = 'icons/obj/doors/airlocks/outpost/atmos.dmi'
	glass_type   = /obj/machinery/door/airlock/outpost/atmos/glass
	airlock_type = /obj/machinery/door/airlock/outpost/atmos
	overlays_file = 'icons/obj/doors/airlocks/outpost/overlays.dmi'

/obj/machinery/door/airlock/outpost/security
	icon = 'icons/obj/doors/airlocks/outpost/security.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_sec_outpost

/obj/machinery/door/airlock/outpost/security/glass
	opacity = FALSE
	glass   = TRUE

/obj/structure/door_assembly/door_assembly_sec_outpost
	name         = "security airlock assembly"
	icon         = 'icons/obj/doors/airlocks/outpost/security.dmi'
	glass_type   = /obj/machinery/door/airlock/outpost/security/glass
	airlock_type = /obj/machinery/door/airlock/outpost/security
	overlays_file = 'icons/obj/doors/airlocks/outpost/overlays.dmi'

/obj/machinery/door/airlock/outpost/command
	icon = 'icons/obj/doors/airlocks/outpost/command.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_com_outpost

/obj/machinery/door/airlock/outpost/command/glass
	opacity = FALSE
	glass   = TRUE

/obj/structure/door_assembly/door_assembly_com_outpost
	name         = "command airlock assembly"
	icon         = 'icons/obj/doors/airlocks/outpost/command.dmi'
	glass_type   = /obj/machinery/door/airlock/outpost/command/glass
	airlock_type = /obj/machinery/door/airlock/outpost/command
	overlays_file = 'icons/obj/doors/airlocks/outpost/overlays.dmi'

/obj/machinery/door/airlock/outpost/medical
	icon = 'icons/obj/doors/airlocks/outpost/medical.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_med_outpost

/obj/machinery/door/airlock/outpost/medical/glass
	opacity = FALSE
	glass   = TRUE

/obj/structure/door_assembly/door_assembly_med_outpost
	name         = "medical airlock assembly"
	icon         = 'icons/obj/doors/airlocks/outpost/medical.dmi'
	glass_type   = /obj/machinery/door/airlock/outpost/medical/glass
	airlock_type = /obj/machinery/door/airlock/outpost/medical
	overlays_file = 'icons/obj/doors/airlocks/outpost/overlays.dmi'