extends Control

var text


signal input_completed

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass



func init(question: String):
	$Question.text = question
	$InputBox.text = ""


#func _input(event):
#	if Input.is_action_just_pressed("ui_del_char"):
#			text = $InputBox.text
#			$InputBox.text = text.trim_suffix(text[-1])
#
#	elif event is InputEventKey and event.pressed:
#		$InputBox.append_at_cursor(event.unicode)





func _on_Input_Completed(_text = null):
	print("Text Entered")
	emit_signal("input_completed", $InputBox.text)
	


