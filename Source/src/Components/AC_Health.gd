extends Node
class_name AC_Health
@export var Health:int = 10

signal Damaged
signal Death


func Damage(amount):
	print("ouch")
	Health -= amount
	if Health <= 0:
		Death.emit()
	else:
		Damaged.emit()
	
	pass
	
func Die():
	queue_free()
	pass
