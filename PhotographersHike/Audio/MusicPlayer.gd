extends AudioStreamPlayer


onready var transition_player: AudioStreamPlayer = $TransitionPlayer

var transitioning: bool = false

var audio_bus: AudioBusLayout = preload("res://default_bus_layout.tres")


func _process(delta: float) -> void:
	if transitioning:
		transition_player.volume_db += 60 * delta
		volume_db -= 60 * delta
		
		if transition_player.volume_db >= 0:
			transition_player.volume_db = -60
			volume_db = 0
			
			stream = transition_player.stream
			play(transition_player.get_playback_position())
			
			transition_player.stop()
			transitioning = false


func play_song(song_name: String, transition: bool = true) -> void:
	if load("res://Assets/Music/" + song_name + ".wav") == stream:
		return
	
	if transition:
		transitioning = true
		transition_player.stream = load("res://Assets/Music/" + song_name + ".wav")
		transition_player.volume_db = -60
		transition_player.play()
	else:
		stream = load("res://Assets/Music/" + song_name + ".wav")
		volume_db = 0
		play()
