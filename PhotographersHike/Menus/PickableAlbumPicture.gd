extends ColorRect

var selected: bool = false

func _ready() -> void:
	self_modulate.a = 0
	

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		selected = !selected
		if selected:
			self_modulate.a = 0.25
		else:
			self_modulate.a = 0


func get_picture_texture() -> Texture:
	return $AlbumPicture.get_picture_texture()

func set_picture_texture(texture: Texture) -> void:
	$AlbumPicture.set_picture_texture(texture)
	
func set_time_label_text(text: String) -> void:
	$AlbumPicture.set_time_label_text(text)
	
func set_level_label_text(text: String) -> void:
	$AlbumPicture.set_level_label_text(text)
