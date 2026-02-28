extends ColorRect
class_name FadeToBlack
@onready var button : TextureButton = $Button
@onready var message : Label = $Message

static var fade_to_black : ColorRect

func _ready() -> void:
	modulate.a = 255.0
	z_index = 25
	fade_to_black = self

func fade_in(on_click : Callable, msg : String) -> void:
	message.text = msg
	print(msg)
	button.connect("pressed", on_click)
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 254.0, 2.0)
