extends ColorRect
class_name FadeToBlack
@onready var button : TextureButton = $Button
@onready var message : Label = $Message
var _fade_duration : float = 0.8
@export var winAudio : AudioStream
@export var loseAudio : AudioStream

static var fade_to_black : ColorRect

var _on_input_callback : Callable
var _game_over : bool = false
var _time_till_input_enable : float = -1

func _ready() -> void:
	color.a = 0.0
	z_index = 25
	fade_to_black = self
	
	var screen_size = get_viewport_rect().size
	size = screen_size
	
	position = -screen_size / 2.0

func fade_in(on_input : Callable, msg : String, won : bool = false) -> void:
	message.text = "\n\n" + msg
	Player.player.z_index = 30
	
	_on_input_callback = on_input
	_game_over = true
	
	var endStream = winAudio if won else loseAudio
	_time_till_input_enable = _fade_duration + endStream.get_length() * 0.2
	var tween = create_tween()
	tween.tween_property(self, "color:a", 1, _fade_duration)
	
	var game_end : Callable = func() -> void : AudioManager.play_sfx(endStream); AudioManager.stop_music()
	
	tween.finished.connect(game_end)
	
func _process(delta: float) -> void:
	if _game_over and _time_till_input_enable > 0:
		_time_till_input_enable -= delta
	
func _input(event: InputEvent) -> void:
	if _game_over and _time_till_input_enable <= 0 and event.is_pressed() and not event.is_echo():
		_game_over = false
		
		get_viewport().set_input_as_handled()
		
		if _on_input_callback.is_valid():
			_on_input_callback.call()
