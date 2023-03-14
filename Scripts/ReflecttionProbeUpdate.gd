extends ReflectionProbe

func _ready():
	Globals.update_reflections.connect(update_reflection)
	pass

func update_reflection():
	update_mode = ReflectionProbe.UPDATE_ONCE
	pass
