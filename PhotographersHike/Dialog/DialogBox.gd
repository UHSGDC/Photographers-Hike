extends NinePatchRect

class_name DialogBox

signal next_dialog


const dialog_json_filepath: String = "res://dialog.json"

var dialog_data: Dictionary

export var speaker_name_dictionary: Dictionary
export var speaker_sound_dictionary: Dictionary

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


func _ready() -> void:
	dialog_data = JsonOpener.get_data(dialog_json_filepath)
	$NextIcon.hide()


func play_dialog(speaker: String, level_id: int, dialog_number: int) -> void:	
	##
	var should_display_name: bool = dialog_data[speaker][0]
	
	if should_display_name:
		show_speaker_name(speaker_name_dictionary[speaker])
	else:
		$SpeakerName.hide()
	
	##
	var level_dialog_array: Array = dialog_data[speaker][1][level_id]
	var dialog_array: Array = level_dialog_array[dialog_number]
	
	
	show()
	
	for dialog in dialog_array:
		yield(output_dialog(dialog), "completed")
	
	hide()


func show_speaker_name(name: String) -> void:
	$SpeakerName.text = name
	$SpeakerName.show()


func output_dialog(dialog: Array) -> void:
	var text_delay: float
	
	if dialog[1] != null:
		text_delay = text_delay_dictionary[int(dialog[1])]
	else:
		text_delay = text_delay_dictionary[TextDelay.MEDIUM]
	
	
	yield(output_text_and_sound(dialog[0], text_delay), "completed")
	
	
	$NextIcon.show()
	yield(self, "next_dialog")
	$NextIcon.hide()


func output_text_and_sound(text: String, delay: float) -> void:
	if delay <= 0.0:
		$TextOutput.text = text
	else:
		$TextOutput.text = ""
		for character in text:
			$TextOutput.text += character
			yield(get_tree().create_timer(delay), "timeout")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu_confirm") or event.is_action_pressed("interact"):
		emit_signal("next_dialog")
