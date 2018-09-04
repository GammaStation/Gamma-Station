var/static/list/scarySounds = list(
	'sound/weapons/thudswoosh.ogg',
    'sound/weapons/Taser.ogg', 'sound/weapons/armbomb.ogg',
    'sound/voice/hiss1.ogg', 'sound/voice/hiss2.ogg',
    'sound/voice/hiss3.ogg', 'sound/voice/hiss4.ogg',
    'sound/voice/hiss5.ogg', 'sound/voice/hiss6.ogg',
    'sound/effects/Glassbr1.ogg', 'sound/effects/Glassbr2.ogg',
    'sound/effects/Glassbr3.ogg', 'sound/items/Welder.ogg',
    'sound/items/Welder2.ogg','sound/machines/airlock/airlockToggle.ogg',
    'sound/effects/clownstep1.ogg', 'sound/effects/clownstep2.ogg'
	)

//added for Xenoarchaeology, might be useful for other stuff
var/global/list/alphabet_uppercase = list("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")

var/list/RESTRICTED_CAMERA_NETWORKS = list( //Those networks can only be accessed by preexisting terminals. AIs and new terminals can't use them.
	"thunder",
	"ERT",
	"NUKE",
	"AURORA"
	)

// Posters
//var/global/list/datum/poster/poster_designs = typesof(/datum/poster) - /datum/poster

var/list/roles_ingame_minute_unlock = list(
	ROLE_PAI = 0,
	ROLE_PLANT = 0,
	ROLE_TRAITOR = 720,
	ROLE_OPERATIVE = 2160,
	ROLE_CHANGELING = 720,
	ROLE_RAIDER = 2880,
	ROLE_ALIEN = 1440,
	ROLE_WIZARD = 2880,
	ROLE_ERT = 2880,
	ROLE_REV = 720,
	ROLE_MEME = 2880,
	ROLE_DRONE = 1440,
	ROLE_CULTIST = 1440,
	ROLE_BLOB = 2160,
	ROLE_NINJA = 2880,
	ROLE_MALF = 2880,
	ROLE_MUTINEER = 2880,
	ROLE_SHADOWLING = 2160,
	ROLE_ABDUCTOR = 2160
)
