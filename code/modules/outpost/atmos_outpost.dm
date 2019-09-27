/obj/machinery/atmospherics/components/unary/vent_pump/alt
	icon = 'icons/atmos/alt_atmos/vent_pump.dmi'
	icon_state = "map_vent"

/obj/machinery/atmospherics/components/unary/vent_pump/alt/update_icon()
	if(!check_icon_cache())
		return

	overlays.Cut()

	var/vent_icon = ""

	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	var/obj/machinery/atmospherics/node = NODE1

	if(!T.is_plating() && node && node.level == PIPE_HIDDEN_LEVEL && istype(node, /obj/machinery/atmospherics/pipe))
		vent_icon += "h"

	if(welded)
		vent_icon += "weld"
	else if(!powered())
		vent_icon += "off"
	else
		vent_icon += "[use_power ? "[pump_direction ? "out" : "in"]" : "off"]"

	var/image/I = image(initial(icon), vent_icon)

	overlays +=  I

/obj/machinery/atmospherics/components/unary/vent_pump/alt/on
	use_power = 1
	icon_state = "map_vent_out"

/obj/machinery/atmospherics/components/unary/vent_scrubber/alt
	icon = 'icons/atmos/alt_atmos/vent_scrubber.dmi'
	icon_state = "map_scrubber_off"

/obj/machinery/atmospherics/components/unary/vent_scrubber/alt/update_icon()
	if(!check_icon_cache())
		return

	overlays.Cut()


	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	var/scrubber_icon = ""
	if(welded)
		scrubber_icon += "weld"
	else
		if(!powered())
			scrubber_icon += "off"
		else
			scrubber_icon += "[use_power ? "[scrubbing ? "on" : "in"]" : "off"]"

	var/image/I = image(initial(icon), scrubber_icon)

	overlays += I

/obj/machinery/atmospherics/components/unary/vent_scrubber/alt/on
	use_power = 1
	icon_state = "map_scrubber_on"

/obj/machinery/atmospherics/components/unary/thermomachine/heater/ship
	icon = 'icons/atmos/alt_atmos/thermomachines.dmi'


/obj/machinery/atmospherics/components/unary/thermomachine/freezer/ship
	icon = 'icons/atmos/alt_atmos/thermomachines.dmi'

/obj/machinery/atmospherics/components/unary/tank/air/ship
	icon = 'icons/atmos/alt_atmos/tanks.dmi'
	start_pressure = 8 * ONE_ATMOSPHERE

/obj/machinery/atmospherics/components/unary/tank/oxygen/ship
	icon = 'icons/atmos/alt_atmos/tanks.dmi'
	start_pressure = 8 * ONE_ATMOSPHERE

/obj/machinery/atmospherics/components/unary/tank/nitrogen/ship
	icon = 'icons/atmos/alt_atmos/tanks.dmi'
	start_pressure = 8 * ONE_ATMOSPHERE

/obj/machinery/atmospherics/components/unary/tank/carbon_dioxide/ship
	icon = 'icons/atmos/alt_atmos/tanks.dmi'
	start_pressure = 8 * ONE_ATMOSPHERE


/obj/machinery/portable_atmospherics/canister/outpost
	icon = 'icons/atmos/alt_atmos/canister.dmi'

/obj/machinery/portable_atmospherics/canister/outpost/nitrogen
	name = "Canister: \[N2\]"
	icon_state = "red"
	canister_color = "red"
	gas_type = "nitrogen"

/obj/machinery/portable_atmospherics/canister/outpost/oxygen
	name = "Canister: \[O2\]"
	icon_state = "blue"
	canister_color = "blue"
	gas_type = "oxygen"

/obj/machinery/portable_atmospherics/canister/outpost/phoron
	name = "Canister \[Phoron\]"
	icon_state = "orange"
	canister_color = "orange"
	gas_type = "phoron"

/obj/machinery/portable_atmospherics/canister/outpost/carbon_dioxide
	name = "Canister \[CO2\]"
	icon_state = "black"
	canister_color = "black"
	gas_type = "carbon_dioxide"

/obj/machinery/portable_atmospherics/canister/outpost/air // this one uses its own create_gas() proc.
	name = "Canister \[Air\]"
	icon_state = "grey"
	canister_color = "grey"