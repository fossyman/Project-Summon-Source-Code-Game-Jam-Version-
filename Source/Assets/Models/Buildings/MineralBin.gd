extends Node3D
class_name BC_MineralBin
@export var Cylinder:MeshInstance3D

@export var HealthComponent:AC_Health

@export var Sprite:Sprite3D
var DamageTween:Tween

var value := 0.5

func _ready():
	UpdateLiquidVisual()
	Globals.CurrentMap.connect("mana_changed",UpdateLiquidVisual)
	HealthComponent.Death.connect(Die)
	HealthComponent.Damaged.connect(ActivateDamageFX)

func UpdateLiquidVisual():
	value = float(Globals.CurrentMap.Mana)
	print("vaLlueHE: " + str(value))
	Cylinder.material_override.next_pass.set("shader_parameter/fill_amount",value)
	pass

func ActivateDamageFX():
	
	pass

func Die():
	Globals.CurrentMap.FinishState = Globals.CurrentMap.EndState.defeat
	Globals.CurrentMap.ShowEndScreen()
	pass
