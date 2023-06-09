extends Node

onready var player: KinematicBody = $player_body
onready var spawn_timer: Timer = $spawn_timer
onready var spawn_env_timer: Timer = $spawn_env_timer
onready var spawn_obstacle_timer: Timer = $spawn_obstacle_timer
onready var spawn_poop_timer: Timer = $spawn_obstacle_timer
onready var spawn_mushroom_timer: Timer = $spawn_obstacle_timer

onready var audio_hit: AudioStreamPlayer3D = $HitRockSound
onready var audio_healtup: AudioStreamPlayer3D = $MushroomPickUp
onready var audio_poop: AudioStreamPlayer3D = $PoopSoundEffect
onready var audio_bgm: AudioStreamPlayer3D = $BGM

onready var tree1: PackedScene = preload("res://models/cartoon-assets/assets/tree/tree.tscn")
onready var tree2: PackedScene = preload("res://models/cartoon-assets/assets/tree/tree.tscn")
onready var fence: PackedScene = preload("res://models/cartoon-assets/fence.tscn")

onready var rock:  PackedScene = preload("res://models/cartoon-assets/assets/rock/rock.tscn")
onready var poop:  PackedScene = preload("res://models/cartoon-assets/assets/poop/poop.tscn")
onready var mushroom:  PackedScene = preload("res://models/cartoon-assets/assets/mushroom/mushroom.tscn")

var startz: float = -40.0
var road_spawnx: Array = [-3, -1.5, 0, 1.5, 3]
var tree_startx: Array = [30, 20, 10, -10, -20, -30]

onready var env_assets: Array = [tree1, tree2]

const FENCE_COUNT: int = 30
var fences: Array = []
var fencez: float = 0.0


func _ready():
	audio_bgm.play()
	var x = 0
	var y = 0
	var z = 5
	for i in FENCE_COUNT:
		var fence_inst = fence.instance()
		fence_inst.connect("body_entered", self, "fence_area_body_entered")
		fences.append(fence_inst)
		add_child(fence_inst)
		fence_inst.global_transform.origin = Vector3(
			x, y, z
		)
		z -= 1.5
		fencez = z


func fence_area_body_entered():
	var first_fence = fences.front()
	first_fence.global_transform.origin = Vector3(
		0, 0, fencez
	)
	fences.pop_front()
	fences.append(first_fence)


func _on_spawn_timer_timeout():
	randomize()
	#print("spawned a coin!")
	spawn_timer.wait_time = randi() % 5 + 1 
	
	var random_line_num = randi() % 3
	var prev_rand_line_n = null
	
	var line_count: int = randi() % 4 + 1



func _on_spawn_env_timer_timeout():
	randomize()
	#print("tree spawned")
	for i in range (10) : 
		var side: int = tree_startx[randi() % 6]
		var asset = env_assets[randi() % env_assets.size()].instance()
		add_child(asset)
		asset.global_transform.origin = Vector3(
			side,
			0,
			startz
		)
		asset.rotation_degrees.y = rand_range(0, 360)
	spawn_env_timer.wait_time = rand_range(1, 2)


func _on_spawn_obstacle_timer_timeout():
	randomize()
	#print("spawned an obstacle!")
	spawn_obstacle_timer.wait_time = randi() % 5 + 1
	
	var random_line_num = randi() % 5
	var prev_rand_line_n = null
	
	var line_count: int = randi() % 4 + 1
	
	
	for i in line_count:
		while (prev_rand_line_n != null and prev_rand_line_n == random_line_num):
			random_line_num = randi() % 5
		prev_rand_line_n = random_line_num
		
		var rock_inst = rock.instance()
		rock_inst.connect("player_entered", self, "on_player_entered_rock")
	
		
		add_child(rock_inst)
	
		rock_inst.global_transform.origin = Vector3(
			road_spawnx[random_line_num],
			0.0,
			startz
		)
		rock_inst.rotation_degrees.y = rand_range(0, 360)


func on_player_entered_rock():
	audio_hit.play()
	var target = get_node("/root/level/player_body/Camera")
	target.start_camera_shake()
	player.health -= 1


func _on_spawn_poop_timer_timeout():
	randomize()
	#print("spawned an obstacle!")
	spawn_poop_timer.wait_time = randi() % 5 + 1
	
	var random_line_num = randi() % 5
	var prev_rand_line_n = null
	
	var line_count: int = randi() % 4 + 1
	
	for i in line_count:
		while (prev_rand_line_n != null and prev_rand_line_n == random_line_num):
			random_line_num = randi() % 5
		prev_rand_line_n = random_line_num
		
		var poop_inst = poop.instance()
		poop_inst.connect("player_entered", self, "on_player_entered_poop")
	
		add_child(poop_inst)
	
		poop_inst.global_transform.origin = Vector3(
			road_spawnx[random_line_num],
			0.0,
			startz
		)
		poop_inst.rotation_degrees.y = rand_range(0, 360)


func on_player_entered_poop():
	audio_poop.play()
	var target = get_node("/root/level/player_body/Camera")
	target.start_camera_shake()
	player.health = 0


func _on_spawn_mushroom_timer_timeout():
	randomize()
	#print("spawned an obstacle!")
	spawn_mushroom_timer.wait_time = randi() % 5 + 1
	
	var random_line_num = randi() % 5
	var prev_rand_line_n = null
	
	while (prev_rand_line_n != null and prev_rand_line_n == random_line_num):
		random_line_num = randi() % 5
	prev_rand_line_n = random_line_num
	
	var mushroom_inst = mushroom.instance()
	mushroom_inst.connect("player_entered", self, "on_player_entered_mushroom")

	add_child(mushroom_inst)

	mushroom_inst.global_transform.origin = Vector3(
		road_spawnx[random_line_num],
		0.0,
		startz
	)
	mushroom_inst.rotation_degrees.y = rand_range(0, 360)


func on_player_entered_mushroom():
	audio_healtup.play()
	if player.health <= 3:
		player.health += 1
	

