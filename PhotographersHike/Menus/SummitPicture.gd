extends ColorRect


func set_speedrun_label_text(text: String) -> void:
	$SpeedrunLabel.text = text


func set_death_label_text(text: String) -> void:
	$Death/DeathLabel.text = text


func set_picture_texture(texture: Texture) -> void:
	$PictureTexture.texture = texture


func get_picture_texture() -> Texture:
	return $PictureTexture.texture
	
	
func set_time_label_text(text: String) -> void:
	$TimeLabel.text = text
	
	
func set_level_label_text(text: String) -> void:
	$LevelLabel.text = text
