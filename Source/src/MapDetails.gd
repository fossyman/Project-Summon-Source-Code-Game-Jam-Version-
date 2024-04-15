extends Node
class_name MapDetails

@export var MineralParent:Node3D

@export var MineralBin:BC_MineralBin

@export var RallyPoint:Node3D

var Health:int = 100
@export var Mana:int = 15

@export var MapRoundManager:RoundManager

enum EndState{victory,defeat}
var FinishState:EndState

@export var EndScreen:BC_EndScreen

var SpawnerDeathsRequired:int = 2

signal mana_changed
signal health_changed

func _enter_tree():
	Globals.CurrentMap = self as MapDetails
	
func ModifyHealth(amount):
	Health = clamp(Health,0,100)
	pass

func AddMana(amount):
	print("ModifyingMana")
	Mana += amount
	Mana = clamp(Mana,0,100)
	mana_changed.emit()
	pass
	
func RemoveMana(amount):
	print("ModifyingMana")
	Mana -= amount
	Mana = clamp(Mana,0,100)
	mana_changed.emit()
	pass
	

func GetClosestMineral(StartPoint):
	var Minerals = MineralParent.get_children()
	var ClosestMineral:BC_Mineral
	for i in Minerals.size():
		var CurrentMineral = Minerals[i] as BC_Mineral
		if !ClosestMineral:
			ClosestMineral = Minerals[i] 
		if CurrentMineral.global_position.distance_to(StartPoint) < ClosestMineral.global_position.distance_to(StartPoint):
			ClosestMineral = Minerals[i] 
			pass
	return ClosestMineral as BC_Mineral
	
func ShowEndScreen():
	EndScreen.show()
	Globals.Player.CanLook = false
	Globals.Player.CanMove = false
	match(FinishState):
		0:
			EndScreen.OpenVictoryScene()
			pass
		1:
			EndScreen.OpenDefeat()
			pass
	pass

func SpawnerDeath():
	SpawnerDeathsRequired -=1
	
	if SpawnerDeathsRequired <= 0:
		FinishState = EndState.victory
		ShowEndScreen()
		get_tree().paused = true
		pass
