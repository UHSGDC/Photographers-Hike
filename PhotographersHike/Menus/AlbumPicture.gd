extends ColorRect

var level_text_dictionary: Dictionary = {
	"Base" : "Base Camp",
	"DenseForest" : "Dense Forest",
	"SparseForest" : "Sparse Forest",
	"Snowy" : "Snowy Tundra",
	"Summit" : "Summit"
}


func set_picture_texture(texture: Texture) -> void:
	$PictureTexture.texture = texture
	
func set_time_label_text(text: String) -> void:
	$TimeLabel.text = text
	
func set_level_label_text(text: String) -> void:
	$LevelLabel.text = level_text_dictionary[text]
