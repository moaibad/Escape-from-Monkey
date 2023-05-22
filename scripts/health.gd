extends Node


var heart_size: int = 4

func on_player_life_changed(player_health:int) -> void:
	$TextureRect.rect_size.x - player_health * heart_size
