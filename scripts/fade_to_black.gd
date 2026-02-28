extends ColorRect
class_name FadeToBlack
@onready var button : TextureButton = $Button
@onready var message : Label = $Message

static var fade_to_black : ColorRect

var _on_input_callback : Callable
var _waiting_for_input : bool = false

func _ready() -> void:
	color.a = 0.0
	z_index = 25
	fade_to_black = self
	
	var screen_size = get_viewport_rect().size
	size = screen_size
	
	position = -screen_size / 2.0

func fade_in(on_input : Callable, msg : String) -> void:
	message.text = "\n\n" + msg
	Player.player.z_index = 30
	
	_on_input_callback = on_input
	_waiting_for_input = true
	
	var tween = create_tween()
	tween.tween_property(self, "color:a", 1, 0.5)

func _input(event: InputEvent) -> void:
	if _waiting_for_input and event.is_pressed() and not event.is_echo():
		_waiting_for_input = false
		
		get_viewport().set_input_as_handled()
		
		if _on_input_callback.is_valid():
			_on_input_callback.call()
