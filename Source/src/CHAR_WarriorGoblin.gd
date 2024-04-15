extends AI_Character

var EnemyTarget:Node3D

@export var DetectionArea:Area3D

func _ready():
	HealthComponent.Death.connect(Die)
	HealthComponent.Damaged.connect(ActivateDamageFX)

func _process(delta):
	var CurrentLocation = global_transform.origin
	var NextLocation = NavAgent.get_next_path_position()
	var CalculatedVector = (NextLocation - CurrentLocation).normalized() * Moveespeed

	NavAgent.velocity = CalculatedVector

	pass
	
func Update_Target_Location(NewLocation):
	NavAgent.target_position = NewLocation
	pass


func _on_ai_timer_timeout():
	CheckEnvironment()
	SpriteUpdater()
	pass # Replace with function body.
	
func CheckEnvironment():
	CheckForEnemies()
	if EnemyTarget:
		SwitchTarget(EnemyTarget)
		AttemptAttack()
	else:
		Update_Target_Location(Globals.CurrentMap.RallyPoint.global_position)
	
func SwitchTarget(NewTarget):
	if is_instance_valid(NewTarget):
		Update_Target_Location(NewTarget.global_position)
	pass

func CheckForEnemies():
	var Enemies = DetectionArea.get_overlapping_bodies()
	var EnemyAreas = DetectionArea.get_overlapping_areas()
	
	for i in EnemyAreas.size():
		if EnemyAreas[i].is_in_group("enemy"):
			EnemyTarget = EnemyAreas[i].get_parent()
	
	for i in Enemies.size():
		if Enemies[i].is_in_group("enemy"):
			EnemyTarget = Enemies[i]
	
func SpriteUpdater():
	pass
	
func _on_navigation_agent_3d_target_reached():
	
	pass # Replace with function body.
	
func AttemptAttack():
	if CheckEnemyStillExists() and (NavAgent.is_target_reached() or global_position.distance_to(EnemyTarget.global_position) < AttackRange):
		EnemyTarget.HealthComponent.Damage(AttackDamage)
		print("Attacking")
	pass
	
func TargetDied():
	print("Ouchie Wowchie")
	EnemyTarget = null

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
	pass # Replace with function body.

func CheckEnemyStillExists():
	if is_instance_valid(EnemyTarget):
		print("STILL EXISTS")
		return true
	else:
		print("NO LONGER EXISTS")
		EnemyTarget = null
		return false
	pass

func _on_detection_area_body_entered(body):
	if body.is_in_group("enemy"):
		EnemyTarget = body as EnemyAI
		Update_Target_Location(EnemyTarget.global_position)
		pass
	else:
		pass
	pass # Replace with function body.
	
	
func Die():
	queue_free()
	pass
