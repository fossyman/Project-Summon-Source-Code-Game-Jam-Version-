extends BC_Spell

@export var WarriorScene:PackedScene

func Cast(CastPoint):
	var mob = WarriorScene.instantiate() as Node3D
	get_tree().root.find_child("Main",true,false).get_child(0).get_child(0).add_child(mob)
	mob.global_position = CastPoint
