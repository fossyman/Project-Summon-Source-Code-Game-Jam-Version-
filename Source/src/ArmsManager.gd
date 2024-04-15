extends Control
class_name ArmParent

@export var ArmContainer:Control
@export var MovementContainer:Control
@export var ArmsSprite:Sprite2D

@export var Touchpoint:Node2D
@export var TouchParticles:CPUParticles2D

@export var TouchArea:Area2D

const HandSpriteSize:int = 128

enum HandState{lowered,raised}
var CurrentHandState:HandState = HandState.lowered

var Animtime:float
var ArmAnimValue:float

# Called when the node enters the scene tree for the first time.
func _ready():
	TouchParticles.emitting = false
	LowerHand()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Animtime+=delta
	MovementContainer.position = Vector2((sin(Animtime * 6) * 20) * ArmAnimValue,(sin(Animtime * 12) * 20)*ArmAnimValue)
	
	match(CurrentHandState):
		0:
			ArmContainer.position.x = lerp(ArmContainer.position.x,0.0,16*delta)
			ArmContainer.position.y = lerp(ArmContainer.position.y,0.0,16*delta)
			pass
		1:
			pass
		
	
func BeginDrawing():
	ArmsSprite.region_rect.position.x = HandSpriteSize
	TouchParticles.emitting = true
	TouchArea.monitoring = true
	pass
	
func EndDrawing():
	ArmsSprite.region_rect.position.x = HandSpriteSize * 2
	TouchParticles.emitting = false
	TouchArea.monitoring = false
	pass
	
func RaiseHand():
	ArmsSprite.region_rect.position.x = HandSpriteSize * 2
	CurrentHandState = HandState.raised
	pass
	
func LowerHand():
	ArmsSprite.region_rect.position.x = 0
	CurrentHandState = HandState.lowered
	TouchParticles.emitting = false
	set_deferred("TouchArea.monitoring",false)
	pass
	
func _input(event):
	if event is InputEventMouseMotion:
		if CurrentHandState == HandState.raised:
			ArmContainer.position.x += event.relative.x
			ArmContainer.position.y += event.relative.y
