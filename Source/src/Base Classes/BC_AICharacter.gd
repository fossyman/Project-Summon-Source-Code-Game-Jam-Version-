extends BC_Character
class_name AI_Character

@export var HealthComponent:AC_Health

@export var Sprite:Sprite3D

@export var NavAgent:NavigationAgent3D
@export var AITimer:Timer

@export var Moveespeed:float = 5
@export var AttackRange:float = 1.0
@export var AttackDamage:int = 5

var DamageTween:Tween

func _ready():
	
	pass

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

	SpriteUpdater()
	pass # Replace with function body.
	
func SpriteUpdater():
	pass
	
func _on_navigation_agent_3d_target_reached():

	pass # Replace with function body.

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = safe_velocity * Moveespeed
	move_and_slide()
	pass # Replace with function body.

func ActivateDamageFX():
	Sprite.modulate = Color.RED
	if DamageTween:
		DamageTween.stop()
	DamageTween = get_tree().create_tween()
	DamageTween.tween_property(Sprite,"modulate",Color.WHITE,1.0)
