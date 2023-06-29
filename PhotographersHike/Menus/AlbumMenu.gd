extends BaseMenu

var picture_textures: Array

export var album_picture_scene: PackedScene

export var picture_container_path: NodePath

onready var picture_container: Control = get_node(picture_container_path)

func update_album() -> void:
	picture_textures = Global.camera_item.picture_textures
	
	for child in picture_container.get_children():
		child.queue_free()
		
	for picture_texture in picture_textures:
		create_album_picture(picture_texture)
		
		
func create_album_picture(texture: Texture) -> void:
	var album_picture = album_picture_scene.instance()
	album_picture.set_picture_texture(texture)
	
	picture_container.add_child(album_picture)
		
	
	
	
	
