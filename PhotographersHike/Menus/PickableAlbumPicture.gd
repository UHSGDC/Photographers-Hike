extends ColorRect


var mouse_inside: bool = false

var selected: bool = false

func _ready() -> void:
	self_modulate.a = 0
	

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and mouse_inside:
		selected = !selected
		if selected:
			self_modulate.a = 0.25
		else:
			self_modulate.a = 0


func _on_PickableAlbumPicture_mouse_entered() -> void:
	mouse_inside = true


func _on_PickableAlbumPicture_mouse_exited() -> void:
	mouse_inside = true


func get_picture_texture() -> Texture:
	return $AlbumPicture.get_picture_texture()

func set_picture_texture(texture: Texture) -> void:
	$AlbumPicture.set_picture_texture(texture)
	
func set_time_label_text(text: String) -> void:
	$AlbumPicture.set_time_label_text(text)
	
func set_level_label_text(text: String) -> void:
	$AlbumPicture.set_level_label_text(text)
