extends Node3D
class_name BC_Mineral
@export var Quantity:int = 100

signal check_quantity

func _ready():
	check_quantity.connect(RemoveSelf)
	pass

func RemoveSelf():
	if Quantity <= 0:
		queue_free()
