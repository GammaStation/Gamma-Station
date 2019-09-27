/turf/simulated/floor/outpost
	icon = 'icons/turf/outpost/floors.dmi'
	icon_state = "floor"
	basetype = /turf/simulated/floor/plating/basalt

/turf/simulated/floor/outpost/break_tile()
	var/image/damage_overlay = image('icons/turf/overlays.dmi', "broken[pick(0,1,2,3,4)]")
	overlays += damage_overlay
	broken = 1
/*
/turf/simulated/floor/outpost/burn_tile()
	if(istype(src,/turf/simulated/floor/engine))
		return
	if(istype(src,/turf/simulated/floor/plating/airless/asteroid))
		return//Asteroid tiles don't burn
	if(broken || burnt)
		return
	if(is_plasteel_floor())
		src.icon_state = "damaged[pick(1,2,3,4,5)]"
		burnt = 1
	else if(is_plasteel_floor())
		src.icon_state = "floorscorched[pick(1,2)]"
		burnt = 1
	else if(is_plating())
		src.icon_state = "panelscorched"
		burnt = 1
	else if(is_wood_floor())
		src.icon_state = "wood-broken"
		burnt = 1
	else if(is_carpet_floor())
		src.icon_state = "carpet-broken"
		burnt = 1
	else if(is_grass_floor())
		src.icon_state = "sand[pick("1","2","3")]"
		burnt = 1
*/


/turf/simulated/floor/plating/outpost
	name = "plating"
	icon = 'icons/turf/outpost/floors.dmi'
	icon_state = "plating"
	basetype = /turf/simulated/floor/plating/basalt

/turf/simulated/floor/plating/basalt_plating
	icon = 'icons/turf/outpost/floors.dmi'
	icon_state = "basalt_plating"
	name = "basalt plating"
	oxygen = LAVA_TURF_O2
	nitrogen = LAVA_TURF_N
	carbon_dioxide = LAVA_TURF_CO2
	temperature = LAVA_TURF_TEMP
	basetype = /turf/simulated/floor/plating/basalt

/turf/simulated/floor/plating/outpost/caution
	icon_state = "warnplate"

/turf/simulated/floor/plating/outpost/caution/corner
	icon_state = "warnplatecorner"

/turf/simulated/floor/concrete
	icon = 'icons/turf/outpost/floors.dmi'
	icon_state = "concrete"
	basetype = /turf/simulated/floor/plating/basalt

/turf/simulated/floor/outpost/bar
	icon_state = "bar_floor"

/turf/simulated/floor/outpost/bar/alt
	icon_state = "bar_floor2"

/turf/simulated/floor/outpost/border
	icon_state = "floor-border"

/turf/simulated/floor/outpost/freezer
	icon_state = "freezerfloor"

/turf/simulated/floor/outpost/dark
	icon_state = "dark"

/turf/simulated/floor/outpost/dark/caution
	icon_state = "dark-caution"

/turf/simulated/floor/outpost/greenblue
	icon_state = "greenbluefull"

/turf/simulated/floor/outpost/barber
	icon_state = "barber"

/turf/simulated/floor/outpost/white
	icon_state = "white"

/turf/simulated/floor/outpost/white/green
	icon_state = "whitegreen"

/turf/simulated/floor/outpost/white/green/corner
	icon_state = "whitegreencorner"

/turf/simulated/floor/outpost/white/blue
	icon_state = "whiteblue"

/turf/simulated/floor/outpost/white/blue/corner
	icon_state = "whitebluecorner"

/turf/simulated/floor/outpost/white/red
	icon_state = "whitered"

/turf/simulated/floor/outpost/white/red/corner
	icon_state = "whiteredcorner"

/turf/simulated/floor/outpost/bath
	icon_state = "bath"

/turf/simulated/floor/outpost/orange
	icon_state = "orangefull"

/turf/simulated/floor/outpost/orange/edge
	icon_state = "orange"

/turf/simulated/floor/outpost/orange/corner
	icon_state = "orangecorner"

/turf/simulated/floor/outpost/green
	icon_state = "greenfull"

/turf/simulated/floor/outpost/green/edge
	icon_state = "green"

/turf/simulated/floor/outpost/green/corner
	icon_state = "greencorner"


/turf/simulated/floor/outpost/darkblue
	icon_state = "darkbluefull"

/turf/simulated/floor/outpost/darkblue/edge
	icon_state = "darkblue"

/turf/simulated/floor/outpost/darkblue/corner
	icon_state = "darkbluecorner"

/turf/simulated/floor/outpost/darkblue/border
	icon_state = "darkblue-border"


/turf/simulated/floor/outpost/red
	icon_state = "redfull"

/turf/simulated/floor/outpost/red/border
	icon_state = "red-border"

/turf/simulated/floor/outpost/red/edge
	icon_state = "red"

/turf/simulated/floor/outpost/red/corner
	icon_state = "redcorner"

/turf/simulated/floor/outpost/techfloor
	icon_state = "techfloor_gray"

/turf/simulated/floor/outpost/techfloor/edge
	icon_state = "techfloor_endfulltwogray"

/turf/simulated/floor/outpost/techfloor/edge/red
	icon_state = "techfloor_red_edge"

/turf/simulated/floor/outpost/techfloor/edge/corner
	icon_state = "techfloor_graycorner"

/turf/simulated/floor/outpost/techgrid
	icon_state = "techfloor_grid"

/turf/simulated/floor/outpost/techgrid/bot
	icon_state = "techfloor_grid-bot"

/turf/simulated/floor/outpost/techgrid/edge
	icon_state = "techfloor_grid-edge"