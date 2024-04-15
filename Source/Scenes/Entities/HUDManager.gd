extends Control
class_name HudManager

@export var ManaBarSlider:HSlider
@export var ManaBarText:RichTextLabel

@export var RoundLabel:RichTextLabel

func _ready():
	UpdateRoundTest()
	UpdateManaBar()
	Globals.CurrentMap.connect("mana_changed",UpdateManaBar)
	Globals.CurrentMap.MapRoundManager.StartRound.connect(UpdateRoundTest)

func UpdateManaBar():
	ManaBarSlider.value = Globals.CurrentMap.Mana
	ManaBarText.text = ("[center][wave amp=15 freq=2]" + str(Globals.CurrentMap.Mana))

func UpdateRoundTest():
	if Globals.CurrentMap.MapRoundManager.CurrentRoundStatus == Globals.CurrentMap.MapRoundManager.RoundStatus.intermission:
		RoundLabel.text = "[center]Intermission"
	else:
		RoundLabel.text = "[center]Round " + str(Globals.CurrentMap.MapRoundManager.CurrentRound)


