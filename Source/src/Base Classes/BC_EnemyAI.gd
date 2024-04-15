extends AI_Character
class_name EnemyAI

var EnemyTarget:Node3D

var OverlappingEnemies:Array[AI_Character]

@export var DetectionArea:Area3D

@onready var MineralBin:BC_MineralBin = Globals.CurrentMap.MineralBin

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
		SwitchTarget(MineralBin)

func CheckForEnemies():
	var Enemies = DetectionArea.get_overlapping_bodies()
	
	for i in Enemies.size():
		if Enemies[i].is_in_group("ally"):
			EnemyTarget = Enemies[i]

func SwitchTarget(NewTarget):
	if is_instance_valid(NewTarget):
		EnemyTarget = NewTarget
		Update_Target_Location(EnemyTarget.global_position)
	pass
	
func SpriteUpdater():
	pass
	
func _on_navigation_agent_3d_target_reached():
	
	pass # Replace with function body.
	
func AttemptAttack():
	if CheckEnemyStillExists() and (global_position.distance_to(EnemyTarget.global_position) < AttackRange):
		EnemyTarget.HealthComponent.Damage(AttackDamage)
		print("Attacking with a range of " + str(global_position.distance_to(EnemyTarget.global_position)))
	pass
	
func TargetDied():
	print("Ouchie Wowchie")
	EnemyTarget = null

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
		EnemyTarget = body as AI_Character
		EnemyTarget.connect("Death",TargetDied)
		Update_Target_Location(EnemyTarget.global_position)
		pass
	else:
		pass
	pass # Replace with function body.


func _on_area_3d_body_entered(body):
	if body.is_in_group("ally"):
		EnemyTarget = body
	pass # Replace with function body.
	
func Die():
	queue_free()
	Globals.CurrentMap.MapRoundManager.CurrentKillsPerRound+=1
	Globals.CurrentMap.MapRoundManager.emit_signal("IncreaseKills")
	pass
