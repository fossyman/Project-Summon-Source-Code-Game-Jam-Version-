extends CharacterBody3D
class_name PlayerManager
const SENSITIVITY = 0.002

@export_category("Jump Parameters")
@export var JumpHeight:float = 2.0
@export var JumpPeakTime:float = .5
@export var JumpFallTime:float = .5
@export var JumpDistance:float = 4.0

@export var GroundSpeed: float = 10.0
@export var AirSpeed: float = 5
@onready var CurrentSpeed: float = GroundSpeed

var JumpVelocity: float = 5.0

var Jump_Gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")
var Fall_Gravity:float = 5.0



const ACCEL = 15
const DECEL = 15

@export var Head:Node3D
@export var CameraPoint:Node3D

@export var HUD:HudManager

@export var ArmsParent:ArmParent
@export var SpellCaster:SpellManager

var CanLook := true
var CanMove := true

enum GameplayStates{normal,casting}
var CurrentGameplayState:GameplayStates = GameplayStates.normal

func _enter_tree():
	Globals.Player = self

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	CalculateMovementParameters()
	

func _process(delta):
	DrawingManager()
	MovementManager(delta)
	
func DrawingManager():
	if Input.is_action_just_pressed("raise_hand"):
		ArmsParent.RaiseHand()
		CanMove = false
		CanLook = false
		SpellCaster.SpellCastArea.show()
		pass
	if Input.is_action_just_released("raise_hand"):
		ArmsParent.LowerHand()
		CanMove = true
		CanLook = true
		SpellCaster.SpellCastArea.hide()
		SpellCaster.RefreshSpellDetails()
		pass
		
	if ArmsParent.CurrentHandState == ArmsParent.HandState.raised:
		if Input.is_action_pressed("draw"):
			ArmsParent.BeginDrawing()
		else:
			ArmsParent.EndDrawing()
	pass
	pass

func MovementManager(delta):
	if not is_on_floor():
		if velocity.y > 0.0:
			velocity.y -= Jump_Gravity * delta
		else:
			velocity.y -= Fall_Gravity * delta
	
	if CurrentGameplayState == GameplayStates.normal:
		var input_dir:Vector2
		var direction:Vector3
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JumpVelocity
		
		if is_on_floor():
			CurrentSpeed = GroundSpeed
		else:
			CurrentSpeed = AirSpeed
		
		if CanMove:
			input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
			direction = (Head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = lerp(velocity.x,direction.x * CurrentSpeed, ACCEL * delta)
			velocity.z = lerp(velocity.z,direction.z * CurrentSpeed, ACCEL * delta)
			ArmsParent.ArmAnimValue = lerp(ArmsParent.ArmAnimValue,1.0,8*delta)
		else:
			velocity.x = lerp(velocity.x,0.0,15*delta)
			velocity.z = lerp(velocity.z,0.0,15*delta)
			ArmsParent.ArmAnimValue = lerp(ArmsParent.ArmAnimValue,0.0,8*delta)
			
	move_and_slide()

func _input(event):
	if CanLook:
		if event is InputEventMouseMotion:
			Head.rotate_y(-event.relative.x * SENSITIVITY)
			CameraPoint.rotate_x(-event.relative.y * SENSITIVITY)
			CameraPoint.rotation_degrees.x = clamp(CameraPoint.rotation_degrees.x,-80,80)
	pass



func CalculateMovementParameters()->void:
	Jump_Gravity = (2*JumpHeight)/pow(JumpPeakTime,2)
	Fall_Gravity = (2*JumpHeight)/pow(JumpFallTime,2)
	JumpVelocity = Jump_Gravity * JumpPeakTime

