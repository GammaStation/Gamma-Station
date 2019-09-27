/obj/machinery/door/airlock/ship
	name = "maintenance access"
	icon = 'icons/obj/doors/airlocks/ship/command.dmi'
	overlays_file = 'icons/obj/doors/airlocks/ship/overlays.dmi'

	assembly_type = /obj/structure/door_assembly/door_assembly_mai

/obj/machinery/door/airlock/ship/command
	name = "command access"
	icon = 'icons/obj/doors/airlocks/ship/command.dmi'
	overlays_file = 'icons/obj/doors/airlocks/ship/overlays.dmi'

	assembly_type = /obj/structure/door_assembly/door_assembly_mai

/obj/machinery/door/airlock/multi_tile/ship
	name          = "metal mutitile airlock"
	icon          = 'icons/obj/doors/airlocks/ship/multitile/white.dmi'
	overlays_file = 'icons/obj/doors/airlocks/ship/multitile/overlays.dmi'
	assembly_type = /obj/structure/door_assembly/multi_tile

/obj/machinery/door/airlock/multi_tile/ship/command
	icon          = 'icons/obj/doors/airlocks/ship/multitile/command.dmi'

/obj/machinery/door/airlock/multi_tile/ship/command/glass
	opacity = FALSE
	glass   = TRUE

/obj/machinery/door/poddoor/ship/left
	icon = 'icons/obj/doors/airlocks/ship/pod_blastdoor_left.dmi'

/obj/machinery/door/poddoor/ship/right
	icon = 'icons/obj/doors/airlocks/ship/pod_blastdoor_right.dmi'