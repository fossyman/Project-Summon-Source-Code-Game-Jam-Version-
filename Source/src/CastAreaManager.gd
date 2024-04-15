extends Node3D
class_name CastArea
var SpellColor:Color

@export var SpellMeshes:Array[MeshInstance3D]
@export var SpellIconArea:MeshInstance3D
@export var SummonerIcons:Array[Texture2D]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ChangeIcon(NewIcon:Texture2D):
	var material = (SpellIconArea as MeshInstance3D).get_active_material(0)
	material.albedo_texture = NewIcon
	pass

func ChangeColor(NewColor):
	SpellColor = NewColor
	(SpellMeshes[0].mesh.surface_get_material(0) as StandardMaterial3D).emission = NewColor
	pass
