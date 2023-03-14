extends Control

@onready var fps_label =  get_node("../FPSLabel")
@onready var recolor_material : ShaderMaterial = preload("res://Materials/Utrim_SpaceShip/utrim_spaceship_recolored.tres")
#@onready var environment = 

func _ready():
	$Panel/VBox/ColorPickerButton.color = recolor_material.get_shader_parameter("paint_color")
	fps_label.visible = $Panel/VBox/FPSButton.button_pressed
	visible = false
	pass

func _process(_delta):
	if Input.is_action_just_pressed("open_menu"):
		if visible:
			close()
		else:
			open()	
	if fps_label.visible:
		fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

	if Input.is_action_just_pressed("toggle_fullscreen"):
		toggle_fullscreen()
		
func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		

func open():
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	$Panel/VBox/Continue.grab_focus()
	
func close():
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false

func _on_exit_pressed():
	get_tree().quit()

func _on_continue_pressed():
	close()

func _on_fullscreen_pressed():
	toggle_fullscreen()

func _on_scaling_option_button_item_selected(index):
	var root = get_tree().get_root()

	root.set_content_scale_aspect(Window.CONTENT_SCALE_ASPECT_KEEP)
	root.scaling_3d_scale = 1.0 - index * 0.1


func _on_color_picker_button_color_changed(color):
	recolor_material.set_shader_parameter("paint_color", color)
	Globals.emit_signal("update_reflections")

func _on_fps_button_toggled(_button_pressed):
	fps_label.visible = _button_pressed


func _on_free_fly_toggled(button_pressed):
	Globals.emit_signal("toggle_free_fly", button_pressed)
