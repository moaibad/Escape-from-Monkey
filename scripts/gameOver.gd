extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var monkey_sound: AudioStreamPlayer2D = $Monkey
# Called when the node enters the scene tree for the first time.
func _ready():
	monkey_sound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	if (Input.is_action_just_pressed("space")):
		get_tree().change_scene("res://scenes/mainMenu.tscn")
		if get_tree().change_scene("res://scenes/mainMenu.tscn") != OK:
			print("Scene Tidak Ada")
