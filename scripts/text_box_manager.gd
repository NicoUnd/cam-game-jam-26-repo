extends Control

@onready var animation_player: AnimationPlayer = $MarginContainer/NinePatchRect/AnimationPlayer
@onready var label: Label = $MarginContainer/NinePatchRect/Label

@export var queue: Array[String];

func _ready() -> void:
	if queue.size() > 0:
		play_next();

func play_next() -> void:
	label.text = queue.pop_front();
	animation_player.play("show_fade");

func enqueue(string: String) -> void:
	queue.append(string);
	if not animation_player.is_playing():
		play_next();

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if queue.size() > 0:
		play_next();
