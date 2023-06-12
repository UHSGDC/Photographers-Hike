extends Control

signal clicked



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func init(text: String, position: Vector2, scale: Vector2):
	$Text.text = text
	self.rect_scale = scale
	self.rect_position = position
	return self




func _on_TextBox_pressed():
	emit_signal("clicked", $Text.text)
