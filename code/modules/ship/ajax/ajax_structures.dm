
/obj/structure/stool/bed/chair/comfy/ajax
	name = "comfy chair"
	desc = "It looks comfy."
	icon = 'icons/obj/structures/ajax/chairs.dmi'
	icon_state = "command"
	color = "#bbbbbb"
	armrest = null
	var/image/padding = null

/obj/structure/stool/bed/chair/comfy/ajax/atom_init()
	padding = image(icon, "[icon_state]_padding", layer = FLY_LAYER)
	padding.color = "#0000ff"
	. = ..()