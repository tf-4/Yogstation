/datum/action/cooldown/spell/pointed/projectile/lightningbolt
	name = "Lightning Bolt"
	desc = "Fire a lightning bolt at your foes! It will jump between targets, but can't knock them down."
	button_icon_state = "lightning"
	active_overlay_icon_state = "bg_spell_border_active_yellow"

	sound = 'sound/magic/lightningbolt.ogg'
	school = SCHOOL_EVOCATION
	cooldown_time = 10 SECONDS
	cooldown_reduction_per_rank = 2 SECONDS

	invocation = "P'WAH, UNLIM'TED P'WAH!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	base_icon_state = "lightning"
	active_msg = "You energize your hands with arcane lightning!"
	deactive_msg = "You let the energy flow out of your hands back into yourself..."
	projectile_type = /obj/projectile/magic/aoe/lightning

	/// The range the bolt itself (different to the range of the projectile)
	var/bolt_range = 15
	/// The power of the bolt itself
	var/bolt_power = 20000
	/// The flags the bolt itself takes when zapping someone
	var/bolt_flags = TESLA_MOB_DAMAGE

/datum/action/cooldown/spell/pointed/projectile/lightningbolt/Grant(mob/grant_to)
	. = ..()
	ADD_TRAIT(owner, TRAIT_SHOCKIMMUNE, type) //HELL YEAHHH, LIGHTNING BOLT!

/datum/action/cooldown/spell/pointed/projectile/lightningbolt/Remove(mob/living/remove_from)
	REMOVE_TRAIT(remove_from, TRAIT_SHOCKIMMUNE, type) //FUCK
	return ..()

/datum/action/cooldown/spell/pointed/projectile/lightningbolt/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	if(!istype(to_fire, /obj/projectile/magic/aoe/lightning))
		return

	var/obj/projectile/magic/aoe/lightning/bolt = to_fire
	bolt.tesla_range = bolt_range
	bolt.tesla_power = bolt_power
	bolt.tesla_flags = bolt_flags
