extends Node
class_name RoundManager

var CurrentRound:int = 0
@export var RoundIntermissionTimer:Timer

var RequiredKillsPerRound = 10
var CurrentKillsPerRound=0

var SpawnCap = 5

enum RoundStatus{intermission,ongoing}
var CurrentRoundStatus:RoundStatus = RoundStatus.intermission

var CurrentMonsters:Array[Node3D]

signal StartRound
signal EndRound

signal IncreaseKills

func _ready():
	IncreaseKills.connect(AddToKillcount)
	EndRound.connect(BeginRoundIntermission)
	pass

func BeginRoundIntermission():
	RoundIntermissionTimer.start()
	pass

func _on_timer_timeout():
	print("ROUND SHOULD START")
	CurrentRound+=1
	CurrentRoundStatus = RoundStatus.ongoing
	StartRound.emit()
	pass # Replace with function body.
	
func AddToKillcount():
	CurrentKillsPerRound +=1
	
	if CurrentKillsPerRound >= RequiredKillsPerRound:
		EndRound.emit()
		CurrentRoundStatus = RoundStatus.intermission
	pass
