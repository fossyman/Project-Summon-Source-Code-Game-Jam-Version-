extends AI_Character

@export var FullSprite:Texture2D

enum TaskState{Idle,Searching,Mining,Returning}
var CurrentTask:TaskState = TaskState.Searching

var TargetMineral:BC_Mineral
var HeldMinerals:float = 0.0

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
	if Globals.CurrentMap.Mana >=100:
		return

	match(CurrentTask):
		1:
			MoveToMineral()
		2:
			MineMinerals()
		3:
			DumpMaterials()
	SpriteUpdater()
	pass # Replace with function body.

func FindMineral():
	var Target = Globals.CurrentMap.GetClosestMineral(global_position)
	TargetMineral = Target

func MoveToMineral():
	if is_instance_valid(TargetMineral):
		if NavAgent.is_target_reached() and CurrentTask == TaskState.Searching:
			CurrentTask = TaskState.Mining
		else:
			Update_Target_Location(TargetMineral.global_position)
	else:
		FindMineral()
	pass

func MineMinerals():
	if NavAgent.is_target_reached() and CurrentTask == TaskState.Mining:
		TargetMineral.Quantity -= 5
		TargetMineral.check_quantity.emit()
		HeldMinerals += 5
	else:
		Update_Target_Location(TargetMineral.global_position)
		
	if HeldMinerals >= 5:
		Update_Target_Location(Globals.CurrentMap.MineralBin.global_position)
		CurrentTask = TaskState.Returning
	pass
	
func DumpMaterials():
	if NavAgent.is_target_reached() and CurrentTask == TaskState.Returning:
		Globals.CurrentMap.AddMana(HeldMinerals)
		HeldMinerals = 0
		CurrentTask = TaskState.Searching
		if is_instance_valid(TargetMineral):
			Update_Target_Location(TargetMineral.global_position)
		else:
			FindMineral()
			Update_Target_Location(TargetMineral.global_position)
	else:
		Update_Target_Location(Globals.CurrentMap.MineralBin.global_position)
	pass
	
func SpriteUpdater():
	match(CurrentTask):
		1:
			CharaterSprite.texture = DefaultSprite
		2:
			CharaterSprite.texture = DefaultSprite
		3:
			CharaterSprite.texture = FullSprite

func _on_navigation_agent_3d_target_reached():
	print("TARGET REACHED, Current task is " + str(CurrentTask))
	pass # Replace with function body.
	
func Die():
	queue_free()
