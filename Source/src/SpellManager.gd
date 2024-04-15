extends Control
class_name SpellManager
@export var TestSpells:Array[PackedScene]

@export var SpellScene:BC_Spell
@export var Spellcast:RayCast3D
@export var SpellCastArea:CastArea
@export var TestGoblin:PackedScene

@export var SpellDrawParticles:CPUParticles2D

@export var NoManaParticles:CPUParticles2D

@export var NoManaTexture:Texture2D
@export var FailTexture:Texture2D

@export var SpellSoundPlayer:AudioStreamPlayer
@export var FailSound:AudioStream
@export var SummonSound:AudioStream

var CurrentSpellPoints:Array[Area2D]
var CurrentSpellScore:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SpellScene = get_child(0) as BC_Spell
	RefreshSpellDetails()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_physical_key_pressed(KEY_1):
		TestEquipSpell(1)
	if Input.is_physical_key_pressed(KEY_2):
		TestEquipSpell(2)
	if Input.is_physical_key_pressed(KEY_3):
		TestEquipSpell(3)
	
	SpellCastArea.global_position = Spellcast.get_collision_point()
	SpellCastArea.global_rotation = -Spellcast.get_collision_normal()
	pass
	
func SpellScoreChange():
	CurrentSpellScore += 1

	pass

func RefreshSpellDetails():
	
	CurrentSpellPoints.clear()
	CurrentSpellPoints.append_array(SpellScene.CastPoints.get_children())
	for i in CurrentSpellPoints.size():
		CurrentSpellPoints[i].visible = true
		CurrentSpellPoints[i].monitoring = true
		CurrentSpellPoints[i].monitorable = true
	
	for i in CurrentSpellPoints.size():
		CurrentSpellPoints[i].visible = true
		CurrentSpellPoints[i].monitoring = true
		CurrentSpellPoints[i].monitorable = true
		
		
	SpellCastArea.ChangeColor(SpellScene.SpellColor)
	SpellCastArea.ChangeIcon(SpellScene.SpellIcon)
	SpellDrawParticles.color = SpellScene.SpellColor
	

func Touch_entered(area):
	var asarea = area as Area2D
	SpellScoreChange()
	if area.name == CurrentSpellPoints[CurrentSpellPoints.size()-1].name:
		if CurrentSpellScore >= SpellScene.RequiredCastScore and SpellScene.CastCost <= Globals.CurrentMap.Mana:
			SpellScene.Cast(Spellcast.get_collision_point())
			CurrentSpellScore = 0
			Globals.CurrentMap.RemoveMana(SpellScene.CastCost)
			Globals.Player.ArmsParent.LowerHand()
			PlaySound(SummonSound)
		else:
			if SpellScene.CastCost > Globals.CurrentMap.Mana:
				EmitErrorParticle(NoManaTexture)
			if CurrentSpellScore < SpellScene.RequiredCastScore:
				EmitErrorParticle(FailTexture)
			print("EITHER NO MANA OR NOT ACCURATE ENOUGH")
			Globals.Player.ArmsParent.LowerHand()
			CurrentSpellScore = 0
			PlaySound(FailSound)
		print(CurrentSpellScore)
	
	if asarea:
		asarea.set_deferred("monitorable", false) 
		asarea.monitoring = false
		asarea.visible = false
	pass # Replace with function body.
	
func TestEquipSpell(ID):
	SpellScene.queue_free()
	var newspell:PackedScene
	match(ID):
		1:
			newspell = TestSpells[0]
			pass
		2:
			newspell = TestSpells[1]
			pass
		3:
			newspell = TestSpells[2]
			pass
	var Scene = newspell.instantiate()
	add_child(Scene)
	SpellScene = Scene
	
	RefreshSpellDetails()
	
func EmitErrorParticle(Error:Texture2D):
	NoManaParticles.texture = Error
	NoManaParticles.emitting = true
	
func PlaySound(Sound:AudioStream):
	if SpellSoundPlayer.stream == Sound:
		SpellSoundPlayer.play()
	else:
		SpellSoundPlayer.stream = Sound
		SpellSoundPlayer.play()
