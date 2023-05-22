tool
extends KinematicBody

# warning-ignore:unused_class_variable
onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
onready var audio_jump: AudioStreamPlayer3D = $JumpSoundEffect
# warning-ignore:unused_class_variable
onready var tween : Tween = $Tween
onready var animation_player: AnimationPlayer = $player/AnimationPlayer
onready var animation_tree: AnimationTree = $player/AnimationTree
onready var gui: Control = $gui
onready var camera : Camera  = $Camera
onready var initial_rotation := camera.rotation_degrees as Vector3

export var trauma_reduction_rate := 1.0

export var noise : OpenSimplexNoise
export var noise_speed := 50.0

export var max_x := 10.0
export var max_y := 10.0
export var max_z := 5.0

var time := 0.0
var trauma := 0.0


const MOVE_SPEED: float = 4.0
var starting_point: Vector3 = Vector3.ZERO
var is_jumping: bool = false
var health: int = 4
var timer : int = 0

func _ready() -> void:
	starting_point = global_transform.origin

var shake_amount = 1.0
var i = 0

var coin_count: int = 0
# warning-ignore:unused_argument
func _physics_process(delta) -> void:
	var velocity: Vector3 = Vector3.ZERO
	var direction: Vector3 = Vector3.ZERO
	camera.rotation_degrees = initial_rotation
	
	timer += 1
	$Timer._start_timer(timer)
	
	
	if (Input.is_action_pressed("move_left")):
		direction.x -= 1
	if (Input.is_action_pressed("move_right")):
		direction.x += 1
	direction = direction.normalized()
	if (Input.is_action_just_pressed("jump")):
		is_jumping = true
		audio_jump.play()
	if (Input.is_action_just_released("jump")):
		is_jumping = false
	velocity = direction * MOVE_SPEED
	global_transform.origin.x = clamp(
		global_transform.origin.x,
		starting_point.x - 3,
		starting_point.x + 3
	)
	
	# warning-ignore:return_value_discarded
	move_and_slide(velocity)
	if is_jumping: animation_tree.set("parameters/jump-shot/active", true)
	
	if health <= 4:
		get_node("health/4").visible = true
		get_node("health/3").visible = true
		get_node("health/2").visible = true
		get_node("health/1").visible = true
	if health <= 3:
		get_node("health/4").visible = false
		get_node("health/3").visible = true
		get_node("health/2").visible = true
		get_node("health/1").visible = true
	if health <= 2:
		get_node("health/4").visible = false
		get_node("health/3").visible = false
		get_node("health/2").visible = true
		get_node("health/1").visible = true
	if health <= 1:
		get_node("health/4").visible = false
		get_node("health/3").visible = false
		get_node("health/2").visible = false
		get_node("health/1").visible = true
	if health <= 0:
		get_node("health/4").visible = false
		get_node("health/3").visible = false
		get_node("health/2").visible = false
		get_node("health/1").visible = false
		
	if health <= 0 :
		print('dead')
		trauma = max(trauma - delta * trauma_reduction_rate, 0.0)
		camera.rotation_degrees.x = initial_rotation.x + max_x * get_shake_intensity()
		camera.rotation_degrees.y = initial_rotation.x + max_y * get_shake_intensity()
		camera.rotation_degrees.z = initial_rotation.z + max_z * get_shake_intensity()
		coin_count += 1
		health = 4
		

func get_shake_intensity() -> float:
	return trauma*trauma
	
	


func _on_collision_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("coins"):
		audio_player.play()
		#print("picked up a coin!")
		coin_count += 1
		gui.get_node("label").text = "Coins: " + str(coin_count)
		parent.queue_free()

