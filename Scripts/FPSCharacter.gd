extends CharacterBody3D

@export var speed : float = 4.0
@export var run_speed : float = 8.0
@export var acceleration : float = 0.2
@export var jump_force : float = 4.0
@export var gravity : float = 18.0
@export var sensitivity : float = 0.003

@onready var head : Node3D = get_node("Head")
@onready var camera : Camera3D = get_node("Head/Camera3D")
@onready var collision : CollisionShape3D = get_node("CollisionShape3D")

var running : bool = false

func _ready():
	visible = camera.current
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Globals.toggle_free_fly.connect(toggle_free_fly)

func toggle_free_fly(value):
	visible = !value
	camera.current = !value
	if value:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if !visible:
		return
		
	if !is_on_floor():
		velocity.y -= gravity * delta
		
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y += jump_force
		
	if Input.is_action_just_pressed("toggle_run"):
		running = !running

	var move_dir = Input.get_vector("left", "right", "up", "down").normalized()
	move_dir = (head.basis * Vector3(move_dir.x, 0, move_dir.y)).normalized()
	
	if move_dir.length_squared() > 0.0001:
		var h_velocity = Vector3(velocity.x, 0, velocity.z) + move_dir
		var max_speed = speed
		if Input.is_action_pressed("run") != running:
			max_speed = run_speed
		if h_velocity.length() > max_speed:
			h_velocity = h_velocity.normalized() * max_speed
		velocity = Vector3(h_velocity.x, velocity.y, h_velocity.z);
	else:
		var h_velocity = Vector3(velocity.x, 0, velocity.z)
		h_velocity = h_velocity.move_toward(Vector3.ZERO, acceleration)
		velocity = Vector3(h_velocity.x, velocity.y, h_velocity.z);
		
	var look_dir = Input.get_vector("look_left", "look_right", "look_up", "look_down")
	head.rotate_y(look_dir.x * sensitivity * -2)
	camera.rotate_x(look_dir.y * sensitivity * -2)
	
	move_and_slide()

func _input(event):
	if !visible:
		return
	if event is InputEventMouseMotion:
		head.rotate_y(event.relative.x * sensitivity * -1)
		camera.rotate_x(event.relative.y * sensitivity * -1)
		camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
