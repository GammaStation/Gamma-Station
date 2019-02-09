#define OVERMAP_SIZE 21			// Size of the overmap itself

#define BLUESPACE_RIFT_SIZE 15	// Size of the bluespace rift

#define OVERMAP_EDGE 2			// How far from the edge of overmap could randomly placed objects spawn

#define BLUESPACIFY_RANGE 3 	// How far turfs are bluespacified around the spacepod

#define BLUESPACE_OFFSET 30  	// How far bluespace rift is created from overmap

#define OVERMAP_JUMP_TIME 50 	// How long it takes to jump from one sector to another

var/global/list/overmap_turfs = list()

var/global/list/possible_events = list("meteor" = 15, "dust" = 15, "electrical" = 15, "carp" = 15, "ion" =15, "null" = 25)

var/global/list/bluespace_rift_navpoints = list()

var/global/list/empty_rift_navpoints = list()

var/global/obj/effect/overmap/object/gamma/gamma_overmap = null

var/global/default_overmap_mappath = "maps/templates/spacesector.dmm"

var/global/list/map_zlevels = list()

var/global/list/empty_zlevels = list()

var/static/rift_template_id = "bluespace_rift"

var/static/datum/map_template/overmap/bluespace_rift/rift_template