extends Panel

class_name DialogBox

signal next_dialog


const dialog_json_filepath: String = "res://dialog.json"

var dialog_data: Dictionary

var dialog_playing: bool = false

export var speaker_name_dictionary: Dictionary

export var dialog_sounds: Array

enum Levels {
	BASE,
	DENSE,
	SPARSE,
	SNOWY,
	SUMMIT
}


enum TextDelay {
	VERY_SLOW,
	SLOW,
	MEDIUM,
	FAST,
	VERY_FAST,
	INSTANT
}

const text_delay_dictionary: Dictionary = {
	TextDelay.VERY_SLOW: 0.2,
	TextDelay.SLOW: 0.08,
	TextDelay.MEDIUM: 0.04,
	TextDelay.FAST: 0.01,
	TextDelay.VERY_FAST: 0.005,
	TextDelay.INSTANT: 0
}

var skip_input: bool = false
var waiting_for_next: bool = false

func _ready() -> void:
	Global.dialog_box = self
	dialog_data = JSONOpener.get_data(dialog_json_filepath)
	$NextIcon.hide()


func wait_while_paused() -> void:
	while get_tree().paused:
		yield(get_tree().create_timer(0), "timeout")
	yield(get_tree().create_timer(0), "timeout")
	

func play_dialog(speaker: String, level_id: int, dialog_number: int) -> String:	
	##
	var output: String = ""
	
	var should_display_name: bool = dialog_data[speaker][0]
	
	if should_display_name:
		show_speaker_name(speaker_name_dictionary[speaker])
	else:
		$SpeakerName.hide()
	
	##
	var level_dialog_array: Array = dialog_data[speaker][1][level_id]
	var dialog_array: Array = level_dialog_array[dialog_number]
	
	$TextOutput.text = ""
	show()
	dialog_playing = true
	Global.platforming_player.velocity = Vector2.ZERO
	
	for dialog in dialog_array:
		if speaker == "old_man":
			play_sound()
		if dialog.size() >= 4:
			output = yield(output_question(dialog), "completed")
			continue
		yield(output_dialog(dialog), "completed")
	
	dialog_playing = false
	hide()
	return output	


func play_sound() -> void:
	$DialogSound.stream = dialog_sounds[int(rand_range(0, dialog_sounds.size() - 1))]
	$DialogSound.play()
	

func show_speaker_name(name: String) -> void:
	$SpeakerName.text = name
	$SpeakerName.show()


func output_question(dialog: Array) -> String:
	var text_delay: float

	if dialog[1] != null:
		text_delay = text_delay_dictionary[int(dialog[1])]
	else:
		text_delay = text_delay_dictionary[TextDelay.MEDIUM]
	
	
	yield(output_text_and_sound(dialog[0], text_delay), "completed")
	
	
	var answers: Array = []
	
	for answer_index in range(2, dialog.size()):
		answers.append(dialog[answer_index])
	
	$AnswerContainer.init(answers)
	return yield($AnswerContainer, "answer_selected")
	

func output_dialog(dialog: Array) -> void:
	var text_delay: float
	
	if dialog[1] != null:
		text_delay = text_delay_dictionary[int(dialog[1])]
	else:
		text_delay = text_delay_dictionary[TextDelay.MEDIUM]
	
	
	yield(output_text_and_sound(dialog[0], text_delay), "completed")
	
	
	$NextIcon.show()
	waiting_for_next = true
	yield(self, "next_dialog")
	$NextIcon.hide()



func output_text_and_sound(text: String, delay: float) -> void:
	$TextOutput.text = ""
	for character in text:
		$TextOutput.text += character
		yield(wait_while_paused(), "completed")
		if skip_input:
			$TextOutput.text = text
			skip_input = false
			break
		yield(get_tree().create_timer(delay), "timeout")


func _input(event: InputEvent) -> void:
	if !dialog_playing:
		return
	
	if Input.is_action_just_pressed("menu_confirm") and !waiting_for_next:
		skip_input = true
	
	if waiting_for_next and (event.is_action_pressed("menu_confirm") or event.is_action_pressed("interact")):
		waiting_for_next = false
		emit_signal("next_dialog")
		get_tree().set_input_as_handled()
