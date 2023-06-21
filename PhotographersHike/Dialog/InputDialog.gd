extends Control

signal input_completed(input)


func init(question: String):
	$Question.text = question
	$InputBox.text = ""


func _on_Input_Completed(_text = null):
	emit_signal("input_completed", $InputBox.text)
	
