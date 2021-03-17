extends CanvasLayer

onready var score_label = $Control/MarginContainer/HBoxContainer/ScoreLabel
onready var life_label = $Control/MarginContainer/HBoxContainer/LifeBox/LifeLabel
onready var cherry_count_label = $Control/MarginContainer/HBoxContainer/HBoxContainer/CherryCountLabel



func _on_Player_life_changed(value):
	life_label.text = str(value)
	


func _on_Level_score_changed(value):
	if value > 0:
		$AudioStreamPlayer.play()
	score_label.text = str(value)


func _on_Player_cherry_changed(value):
	cherry_count_label.text = str(value)
