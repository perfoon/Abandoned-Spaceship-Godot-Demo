extends MeshInstance3D

@onready var screen = $ScreenPlane
@onready var viewport = $SubViewport
@onready var video_stream_player = $SubViewport/VideoStreamPlayer

func _ready():
	screen.material_override.set_texture(BaseMaterial3D.TEXTURE_ALBEDO, viewport.get_texture())
	video_stream_player.play()
	pass
	

func _on_video_stream_player_finished():
	video_stream_player.play()
