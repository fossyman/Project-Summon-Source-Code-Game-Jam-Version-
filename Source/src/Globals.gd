extends Node

@onready var Player:PlayerManager

@onready var CurrentMap:MapDetails
var TestScene:PackedScene
func _ready():
	Player = get_tree().root.find_child("Player",true,false)
	CurrentMap = get_tree().root.find_child("MapDetails",true,false)
	TestScene = ResourceLoader.load("res://Scenes/TestArea.tscn")
func RestartScene():
	get_tree().paused = false
	var restartedscene = TestScene.instantiate()
	get_tree().root.find_child("Main",true,false).get_child(0).get_child(0).queue_free()
	get_tree().root.find_child("Main",true,false).get_child(0).add_child(restartedscene)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	Player.global_position = get_tree().root.find_child("SpawnPoint",true,false).global_position
	pass

func StartScene():
	get_tree().paused = false
	var restartedscene = TestScene.instantiate()
	get_tree().root.find_child("Main",true,false).get_child(0).get_child(0).queue_free()
	get_tree().root.find_child("Main",true,false).get_child(0).add_child(restartedscene)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	Player.global_position = get_tree().root.find_child("SpawnPoint",true,false).global_position
	pass
