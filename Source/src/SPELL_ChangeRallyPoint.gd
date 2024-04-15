extends BC_Spell

func Cast(CastPoint):
	Globals.CurrentMap.RallyPoint.global_position = CastPoint
