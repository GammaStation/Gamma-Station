// Temporary visual effefcts that get qdeled after var/duration time.
/obj/effect/temp_visual
	icon_state = ""
	anchored = TRUE
	layer = MOB_LAYER + 0.2 // It seems we do not have layer defines. HMM. ~(
	unacidable = TRUE
	var/duration = 1 SECOND
	var/randomdir = TRUE

/obj/effect/temp_visual/atom_init()
	..()
	if(randomdir)
		dir = pick(cardinal)

	return INITIALIZE_HINT_LATELOAD

/obj/effect/temp_visual/atom_init_late()
	QDEL_IN(src, duration)

/obj/effect/temp_visual/singularity_act()
	return

/obj/effect/temp_visual/singularity_pull()
	return

/obj/effect/temp_visual/ex_act()
	return

/obj/effect/temp_visual/obj_pickup_ghost
	duration = 2 // In deciseconds.
	randomdir = FALSE

/obj/effect/temp_visual/obj_pickup_ghost/atom_init(mapload, atom/picked_up)
	. = ..()
	icon = picked_up.icon
	icon_state = picked_up.icon_state
	set_dir(picked_up.dir)
	pixel_x = picked_up.pixel_x
	pixel_y = picked_up.pixel_y
	color = picked_up.color

/obj/effect/temp_visual/obj_pickup_ghost/proc/animate_towards(atom/target, reverse = FALSE, no_size_change = FALSE)
	var/new_pixel_x = (target.x - x) * 32 + pixel_x
	var/new_pixel_y = (target.y - y) * 32 + pixel_y
	pixel_x = 0
	pixel_y = 0
	if(no_size_change)
		animate(src, pixel_x = new_pixel_x, pixel_y = new_pixel_y, time = duration)
		return
	if(reverse)
		transform = matrix() * 0
		animate(src, pixel_x = new_pixel_x, pixel_y = new_pixel_y, transform = initial(transform), time = duration)
	else
		animate(src, pixel_x = new_pixel_x, pixel_y = new_pixel_y, transform = matrix() * 0, time = duration)
