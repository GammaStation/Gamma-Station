









//HEADGEAR


/obj/item/clothing/head/helmet/pilot
	name = "fleet pilot's helmet"
	desc = "A pilot's helmet for operating the cockpit in style. This one is worn by members of the UN Fleet."
	icon = 'code/modules/warfare/clothing/clothing.dmi'
	icon_custom = 'code/modules/warfare/clothing/clothing.dmi'
	icon_state = "pilot"
	item_state = "pilot"





/obj/item/clothing/suit/armor/kevlar_vest
	name = "armored vest"
	desc = "An armor vest made of synthetic fibers."
	icon = 'code/modules/warfare/clothing/clothing.dmi'
	icon_custom = 'code/modules/warfare/clothing/clothing.dmi'
	icon_state = "kvest"
	item_state = "kvest"
	armor = list(melee = 25, bullet = 30, laser = 30, energy = 10, bomb = 25, bio = 0, rad = 0, telepathy = 0)





/obj/item/device/radio/headset/trooper
	name = "marine headset"
	icon_state = "marinad"
	item_state = "headset"
	desc = "A military headset"

//MASKS
/obj/item/clothing/mask/gas/half
	name = "face mask"
	desc = "A compact, durable gas mask that can be connected to an air supply."
	icon = 'code/modules/warfare/clothing/clothing.dmi'
	icon_custom = 'code/modules/warfare/clothing/clothing.dmi'
	icon_state = "halfgas"
	item_state = "halfgas"
	siemens_coefficient = 0.7
	body_parts_covered = FACE
	w_class = ITEM_SIZE_SMALL
	armor = list(melee = 10, bullet = 10, laser = 10, energy = 0, bomb = 0, bio = 55, rad = 0)

