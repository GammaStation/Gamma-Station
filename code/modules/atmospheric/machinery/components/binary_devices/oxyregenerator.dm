/obj/machinery/atmospherics/components/binary/oxyregenerator
	name ="oxygen regenerator"
	desc = "A machine for regeneration oxygen from carbon dioxide."
	icon = 'icons/atmos/oxyregenerator.dmi'
	icon_state = "off"
	level = 1
	density = TRUE
	use_power = 0
	idle_power_usage = 200		//internal circuitry, friction losses and stuff
	power_rating = 10000
	var/target_pressure = 10*ONE_ATMOSPHERE
	var/id = null
	var/power_setting = 1 //power consumption setting, 1 through five
	var/carbon_stored = 0
	var/carbon_efficiency = 0.5
	var/intake_power_efficiency = 1
	var/const/carbon_moles_per_piece = 50 //One 12g per mole * 50 = 600 g chunk of coal
	var/phase = "filling"//"filling", "processing", "releasing"
	var/datum/gas_mixture/inner_tank = new
	var/tank_volume = 400//Litres

/obj/machinery/atmospherics/components/binary/oxyregenerator/atom_init()
	. = ..()
	inner_tank.volume = tank_volume
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/oxyregenerator(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)//Takes CO2
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(src)//Breaks bond
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)//Stores carbon
	RefreshParts()

/obj/machinery/atmospherics/components/binary/oxyregenerator/RefreshParts()
	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(istype(P, /obj/item/weapon/stock_parts/matter_bin))
			carbon_efficiency += 0.25 * (P.rating-1) //plus 25% per stock item rank
		if(istype(P, /obj/item/weapon/stock_parts/manipulator))
			intake_power_efficiency -= 0.1 * (P.rating-1) //10% better intake power efficiency per stock item rank
		if(istype(P, /obj/item/weapon/stock_parts/micro_laser))
			power_rating -= power_rating * 0.05 * (P.rating-1) //5% better power efficiency per stock item rank

/obj/machinery/atmospherics/components/binary/oxyregenerator/examine(user)
	..()
	to_chat(user,"Its outlet port is to the [dir2text(dir)]")

/obj/machinery/atmospherics/components/binary/oxyregenerator/attackby(obj/item/O, mob/user)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(istype(O, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		anchored = !anchored
		user.visible_message("[user.name] [anchored ? "secures" : "unsecures"] the bolts holding [src.name] to the floor.", \
					"You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor.", \
					"You hear a ratchet")

		var/obj/machinery/atmospherics/node1 = NODE1
		var/obj/machinery/atmospherics/node2 = NODE2

		if(node1)
			node1.disconnect(src)
			NODE1 = null
			nullifyPipenet(PARENT1)
		if(node2)
			node2.disconnect(src)
			NODE2 = null
			nullifyPipenet(PARENT2)

		if(anchored)
			SetInitDirections()
			atmos_init()
			node1 = NODE1
			if(node1)
				node1.atmos_init()
				node1.addMember(src)
			node2 = NODE2
			if(node2)
				node2.atmos_init()
				node2.addMember(src)
			build_network()

/obj/machinery/atmospherics/components/binary/oxyregenerator/verb/rotate_clockwise()
	set category = "Object"
	set name = "Rotate  (Clockwise)"
	set src in view(1)

	if (usr.incapacitated() || anchored)
		return

	set_dir(turn(src.dir, -90))

/obj/machinery/atmospherics/components/binary/oxyregenerator/verb/rotate_anticlockwise()
	set category = "Object"
	set name = "Rotate (Counterclockwise)"
	set src in view(1)

	if (usr.incapacitated() || anchored)
		return

	set_dir(turn(src.dir, 90))

/obj/machinery/atmospherics/components/binary/oxyregenerator/process_atmos(delay)
	var/datum/pipeline/parent1 = PARENT1
	var/datum/pipeline/parent2 = PARENT2
	var/datum/gas_mixture/air1 = AIR1
	var/datum/gas_mixture/air2 = AIR2

	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return

	var/power_draw = -1
	last_power_draw = 0
	//TODO Add overlay with F-P-R letter to display current state
	if (phase == "filling")//filling tank
		var/pressure_delta = target_pressure - inner_tank.return_pressure()
		if (pressure_delta > 0.01 && air1.temperature > 0)
			var/transfer_moles = calculate_transfer_moles(air1, inner_tank, pressure_delta)
			power_draw = pump_gas(src, air1, inner_tank, transfer_moles, power_rating*power_setting) * intake_power_efficiency
			if (power_draw >= 0)
				last_power_draw = power_draw
				use_power(power_draw)
				if(parent1)
					update_parents()
		if (air1.return_pressure() < 0.1 * ONE_ATMOSPHERE || inner_tank.return_pressure() >= target_pressure * 0.95)//if pipe is good as empty or tank is full
			phase = "processing"

	if (phase == "processing")//processing CO2 in tank
		if (inner_tank.gas["carbon_dioxide"])
			var/co2_intake = between(0, inner_tank.gas["carbon_dioxide"], power_setting*delay/10)
			last_flow_rate = co2_intake
			inner_tank.adjust_gas("carbon_dioxide", -co2_intake, 1)
			var/datum/gas_mixture/new_oxygen = new
			new_oxygen.adjust_gas("oxygen",  co2_intake)
			new_oxygen.temperature = T20C+30 //it's sort of hot after molecular bond breaking
			inner_tank.merge(new_oxygen)
			carbon_stored += co2_intake * carbon_efficiency
			while (carbon_stored >= carbon_moles_per_piece)
				carbon_stored -= carbon_moles_per_piece
				new /obj/item/weapon/ore/coal(get_turf(src))
			power_draw = power_rating * co2_intake
			last_power_draw = power_draw
			use_power(power_draw)
		else
			phase = "releasing"

	if (phase == "releasing")//releasing processed gas mix
		power_draw = -1
		var/pressure_delta = target_pressure - air2.return_pressure()
		if (pressure_delta > 0.01 && inner_tank.temperature > 0)
			var/transfer_moles = calculate_transfer_moles(inner_tank, air2, pressure_delta, (parent2)? parent2.air.volume : 0)
			power_draw = pump_gas(src, inner_tank, air2, transfer_moles, power_rating*power_setting)
			if (power_draw >= 0)
				last_power_draw = power_draw
				use_power(power_draw)
				if(parent2)
					update_parents()
		else//can't push outside harder than target pressure. Device is not intended to be used as a pump after all
			phase = "filling"
		if (inner_tank.return_pressure() <= 0.1)
			phase = "filling"

/obj/machinery/atmospherics/components/binary/oxyregenerator/update_icon()
	if(!powered())
		icon_state = "off"
	else
		icon_state = "[use_power ? "on" : "off"]"
/*
/obj/machinery/atmospherics/components/binary/oxyregenerator/attack_ai(mob/user as mob)
	ui_interact(user)

/obj/machinery/atmospherics/components/binary/oxyregenerator/attack_hand(mob/user as mob)
	ui_interact(user)
*/
/obj/machinery/atmospherics/components/binary/oxyregenerator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)
	var/datum/gas_mixture/air1 = AIR1
	var/datum/gas_mixture/air2 = AIR2
	var/data[0]
	data["on"] = use_power ? 1 : 0
	data["powerSetting"] = power_setting
	data["gasProcessed"] = last_flow_rate
	data["air1Pressure"] = round(air1.return_pressure())
	data["air2Pressure"] = round(air2.return_pressure())
	data["tankPressure"] = round(inner_tank.return_pressure())
	data["targetPressure"] = round(target_pressure)
	data["phase"] = phase
	if (inner_tank.total_moles > 0)
		data["co2"] = round(100 * inner_tank.gas["carbon_dioxide"]/inner_tank.total_moles)
		data["o2"] = round(100 * inner_tank.gas["oxygen"]/inner_tank.total_moles)
	else
		data["co2"] = 0
		data["o2"] = 0
		// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "oxyregenerator.tmpl", "Oxygen Regeneration System", 440, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/atmospherics/components/binary/oxyregenerator/Topic(href, href_list)
	if(!..())
		return FALSE
	if(href_list["toggleStatus"])
		use_power = !use_power
		update_icon()
		return TRUE
	if(href_list["setPower"]) //setting power to 0 is redundant anyways
		power_setting = between(1, text2num(href_list["setPower"]), 5)
		return TRUE