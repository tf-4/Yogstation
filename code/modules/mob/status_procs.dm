
//Here are the procs used to modify status effects of a mob.
//The effects include: stun, knockdown, unconscious, sleeping, resting, jitteriness, dizziness, ear damage,
// eye damage, eye_blind, eye_blurry, druggy, TRAIT_BLIND trait, and TRAIT_NEARSIGHT trait.

///Blind a mobs eyes by amount
/mob/proc/blind_eyes(amount)
	if(amount>0)
		var/old_eye_blind = eye_blind
		eye_blind = max(eye_blind, amount)
		if(!old_eye_blind)
			if(stat == CONSCIOUS || stat == SOFT_CRIT)
				throw_alert("blind", /atom/movable/screen/alert/blind)
			if(stat != CONSCIOUS && HAS_TRAIT(src, TRAIT_HEAVY_SLEEPER))
				overlay_fullscreen("blind", /atom/movable/screen/fullscreen/black)
			else
				overlay_fullscreen("blind", /atom/movable/screen/fullscreen/blind)

/**
  * Adjust a mobs blindness by an amount
  *
  * Will apply the blind alerts if needed
  */
/mob/proc/adjust_blindness(amount)
	if(amount>0)
		var/old_eye_blind = eye_blind
		eye_blind += amount
		if(!old_eye_blind)
			if(stat == CONSCIOUS || stat == SOFT_CRIT)
				throw_alert("blind", /atom/movable/screen/alert/blind)
			if(stat != CONSCIOUS && HAS_TRAIT(src, TRAIT_HEAVY_SLEEPER))
				overlay_fullscreen("blind", /atom/movable/screen/fullscreen/black)
			else
				overlay_fullscreen("blind", /atom/movable/screen/fullscreen/blind)
	else if(eye_blind)
		var/blind_minimum = 0
		if((stat != CONSCIOUS && stat != SOFT_CRIT))
			blind_minimum = 1
		if(isliving(src))
			var/mob/living/L = src
			if(HAS_TRAIT(L, TRAIT_BLIND))
				blind_minimum = 1
		eye_blind = max(eye_blind+amount, blind_minimum)
		if(!eye_blind)
			clear_alert("blind")
			clear_fullscreen("blind")
/**
  * Force set the blindness of a mob to some level
  */
/mob/proc/set_blindness(amount)
	if(amount>0)
		var/old_eye_blind = eye_blind
		eye_blind = amount
		if(client && !old_eye_blind)
			if(stat == CONSCIOUS || stat == SOFT_CRIT)
				throw_alert("blind", /atom/movable/screen/alert/blind)
			if(stat != CONSCIOUS && HAS_TRAIT(src, TRAIT_HEAVY_SLEEPER))
				overlay_fullscreen("blind", /atom/movable/screen/fullscreen/black)
			else
				overlay_fullscreen("blind", /atom/movable/screen/fullscreen/blind)
	else if(eye_blind)
		var/blind_minimum = 0
		if(stat != CONSCIOUS && stat != SOFT_CRIT)
			blind_minimum = 1
		if(isliving(src))
			var/mob/living/L = src
			if(HAS_TRAIT(L, TRAIT_BLIND))
				blind_minimum = 1
		eye_blind = blind_minimum
		if(!eye_blind)
			clear_alert("blind")
			clear_fullscreen("blind")

/**
  * Make the mobs vision blurry
  */
/mob/proc/blur_eyes(amount)
	if(amount>0)
		eye_blurry = max(amount, eye_blurry)
	update_eye_blur()

/**
  * Adjust the current blurriness of the mobs vision by amount
  */
/mob/proc/adjust_blurriness(amount)
	eye_blurry = max(eye_blurry+amount, 0)
	update_eye_blur()

///Set the mobs blurriness of vision to an amount
/mob/proc/set_blurriness(amount)
	eye_blurry = max(amount, 0)
	update_eye_blur()

///Apply the blurry overlays to a mobs clients screen
/mob/proc/update_eye_blur()
	if(!client)
		return
	var/atom/movable/screen/plane_master/floor/OT = locate(/atom/movable/screen/plane_master/floor) in client.screen
	var/atom/movable/screen/plane_master/game_world/GW = locate(/atom/movable/screen/plane_master/game_world) in client.screen
	GW.backdrop(src)
	OT.backdrop(src)

///Adjust the disgust level of a mob
/mob/proc/adjust_disgust(amount)
	return

///Set the disgust level of a mob
/mob/proc/set_disgust(amount)
	return

///Adjust the body temperature of a mob, with min/max settings
/mob/proc/adjust_bodytemperature(amount,min_temp=0,max_temp=INFINITY)
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		amount *= H.dna.species.tempmod
		amount *= H.physiology.temp_mod
	if(bodytemperature >= min_temp && bodytemperature <= max_temp)
		bodytemperature = clamp(bodytemperature + amount,min_temp,max_temp)
	// Infrared luminosity, how far away can you pick up someone's heat with infrared (NOT THERMAL) vision
	// 37C has 12 range (11 tiles)
	// 20C has 7 range (6 tiles)
	// 10C has 3 range (2 tiles)
	// 0C has 0 range (0 tiles)
	infra_luminosity = round(max((bodytemperature - T0C)/3, 0))
