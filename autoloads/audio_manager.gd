extends Node

@export var _music_player: AudioStreamPlayer
@export var _sfx_poly_player: AudioStreamPlayer


func _ready() -> void:
	if not _music_player:
		_music_player = AudioStreamPlayer.new()
		_music_player.bus = &"Music" # Route to a specific Audio Bus
		add_child(_music_player)
	
	if not _sfx_poly_player:
		_sfx_poly_player = AudioStreamPlayer.new()
		_sfx_poly_player.bus = &"SFX"
		_sfx_poly_player.max_polyphony = 32 
		add_child(_sfx_poly_player)

func play_music(stream: AudioStream) -> void:
	if _music_player.stream == stream and _music_player.playing:
		return
	_music_player.stream = stream
	_music_player.play()

func stop_music() -> void:
	if _music_player.playing:
		_music_player.stop()

func play_sfx(stream: AudioStream) -> void:
	if stream:
		_sfx_poly_player.stream = stream
		_sfx_poly_player.play()
