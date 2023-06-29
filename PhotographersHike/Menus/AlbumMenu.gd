extends BaseMenu

export var album_picture_scene: PackedScene

export var picture_container_path: NodePath

onready var picture_container: Control = get_node(picture_container_path)

func update_album() -> void:
	var picture_textures = Global.camera_item.picture_textures
	var picture_times = Global.camera_item.picture_times
	var picture_levels = Global.camera_item.picture_levels
	
	
	for child in picture_container.get_children():
		child.queue_free()
		
	for i in picture_textures.size():
		create_album_picture(picture_textures[i], picture_times[i], picture_levels[i])
		
		
func create_album_picture(texture: Texture, time: String, level: String) -> void:
	var album_picture = album_picture_scene.instance()
	album_picture.set_picture_texture(texture)
	album_picture.set_time_label_text(time)
	album_picture.set_level_label_text(level)
	
	
	picture_container.add_child(album_picture)
		
	
	
	
	
