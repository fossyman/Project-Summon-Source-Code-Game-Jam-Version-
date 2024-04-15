extends Node3D

var RoundController:RoundManager
var CanSpawn = true
@export var SpawnDelayTimer:Timer
@export var SpawnableUnits:Array[PackedScene]

@export var HealthComponent:AC_Health

@export var Sprite:Sprite3D

var DamageTween:Tween

func  _ready():
	RoundController = Globals.CurrentMap.MapRoundManager
	RoundController.connect("StartRound",BeginSpawner)
	RoundController.connect("EndRound",StopSpawner)
	
	HealthComponent.Death.connect(Die)
	HealthComponent.Damaged.connect(ActivateDamageFX)
	
func BeginSpawner():
	print("START NOW?")
	CanSpawn = true
	SpawnDelayTimer.start()
	pass
	
func StopSpawner():
	CanSpawn = false
	SpawnDelayTimer.stop()
	pass

func SpawnEnemy():
	if CanSpawn and RoundController.CurrentMonsters.size() < RoundController.SpawnCap:
		if RoundController.CurrentRound < 5:
			var EnemyToSpawn:CharacterBody3D = SpawnableUnits[0].instantiate() as CharacterBody3D
			get_tree().root.find_child("Main",true,false).get_child(0).get_child(0).add_child(EnemyToSpawn)
			EnemyToSpawn.global_position = global_position
			RoundController.CurrentMonsters.append(EnemyToSpawn)
			pass
		else:
			var rng = randi_range(0,SpawnableUnits.size()-1)
			var EnemyToSpawn:CharacterBody3D = SpawnableUnits[rng].instantiate() as CharacterBody3D
			get_tree().root.find_child("Main",true,false).get_child(0).get_child(0).add_child(EnemyToSpawn)
			EnemyToSpawn.global_position = global_position
			RoundController.CurrentMonsters.append(EnemyToSpawn)
			pass
	pass

func _on_spawn_delay_timeout():
	SpawnEnemy()
	pass # Replace with function body.
	
func Die():
	Globals.CurrentMap.SpawnerDeath()
	queue_free()
	pass
	
func ActivateDamageFX():
	print("OUCH, YOU ARE HURTING THE SPAWNER")
	Sprite.modulate = Color.RED
	if DamageTween:
		DamageTween.stop()
	DamageTween = get_tree().create_tween()
	DamageTween.tween_property(Sprite,"modulate",Color.WHITE,1.0)
