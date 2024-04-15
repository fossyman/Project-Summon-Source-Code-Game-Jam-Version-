extends Control
class_name BC_EndScreen
@export var VictoryScreen:Control

@export var DefeatScreen:Control
@export var TestScene:PackedScene
func OpenVictoryScene():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	show()
	VictoryScreen.show()
	DefeatScreen.hide()
	pass
	
func OpenDefeat():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	show()
	VictoryScreen.hide()
	DefeatScreen.show()
	pass

func _on_quit_button_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_restart_button_pressed():
	Globals.RestartScene()
	
	pass # Replace with function body.
