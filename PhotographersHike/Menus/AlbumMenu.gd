extends BaseMenu

signal confirm_pressed(confirmed)


export var album_picture_scene: PackedScene

export var picture_container_path: NodePath

onready var picture_container: Control = get_node(picture_container_path)

func _ready() -> void:
	var error = $ConfirmDownloadDialog.get_cancel().connect("pressed", self, "download_cancelled")
	if error:
		push_error("Error connecting confirm download dialog cancel signal to album menu node")


func _back_input() -> void:
	if $ConfirmDownloadDialog.visible:
		$ConfirmDownloadDialog.hide()
		get_tree().set_input_as_handled()
		return
	if $FileDialog.visible:
		$FileDialog.hide()
		get_tree().set_input_as_handled()
		return
	if $DownloadDialog.visible:
		$DownloadDialog.hide()
		get_tree().set_input_as_handled()
		return

func update_album() -> void:
	var picture_textures = Global.camera_item.picture_textures
	var picture_times = Global.camera_item.picture_times
	var picture_levels = Global.camera_item.picture_levels
	
	
	for child in picture_container.get_children():
		child.queue_free()
		
	for i in picture_textures.size():
		create_album_picture(picture_textures[i], picture_times[i], picture_levels[i])
		
		
	if picture_textures.size() == 1:
		$PictureCount.text = "1 Picture "
	else:
		$PictureCount.text = str(picture_textures.size()) + " Pictures "
		
		
func create_album_picture(texture: Texture, time: String, level: String) -> void:
	var album_picture = album_picture_scene.instance()
	album_picture.set_picture_texture(texture)
	album_picture.set_time_label_text(time)
	album_picture.set_level_label_text(level)
	
	
	picture_container.add_child(album_picture)


func download_cancelled() -> void:
	emit_signal("confirm_pressed", false)


func download_confirmed() -> void:
	emit_signal("confirm_pressed", true)


func _on_DownloadButton_pressed() -> void:
	var picture_textures: Array
	for picture in picture_container.get_children():
		if picture.selected:
			picture_textures.append(picture.get_picture_texture())
		
	if picture_textures.size() == 0:
		$ConfirmDownloadDialog.dialog_text = "Please select some photos download."
		$ConfirmDownloadDialog.popup_centered()
		return
		
	if OS.has_feature("web"):
		_handle_web_download(picture_textures)
		return
	_handle_desktop_download(picture_textures)
	

func _handle_web_download(picture_textures: Array) -> void:			
	$ConfirmDownloadDialog.dialog_text = "Download %s pictures? Please give permission to download multiple files in your browser's settings." % picture_textures.size()
	$ConfirmDownloadDialog.popup_centered()
	
	if !yield(self, "confirm_pressed"):
		return

	var picture_count: int = 0
	
	for i in picture_textures.size():
		var image = picture_textures[i].get_data()
		var buf = image.save_png_to_buffer()
		JavaScript.download_buffer(buf, "Picture %s.png" % (i + 1))
		picture_count += 1
	
	
	$DownloadDialog.dialog_text = "%s pictures downloaded!" % picture_count
		
	$DownloadDialog.popup_centered()
	


func _handle_desktop_download(picture_textures: Array) -> void:
	$FileDialog.popup_centered()
	var directory_path = yield($FileDialog, "dir_selected")
	
	$ConfirmDownloadDialog.dialog_text = "Download %s pictures at \"%s\"?" % [picture_textures.size(), directory_path]
	$ConfirmDownloadDialog.popup_centered()
	
	
	if !yield(self, "confirm_pressed"):
		return

	var failed: bool = false
	var picture_count: int = 0
	
	for i in picture_textures.size():
		var image = picture_textures[i].get_data()
		var error = image.save_png(directory_path + "/Picture %s.png" % (i + 1))
		if error:
			failed = true
		else:
			picture_count += 1
	
	
	
	$DownloadDialog.dialog_text = "%s pictures downloaded successfully!" % picture_count
	
	if failed:
		$DownloadDialog.dialog_text = "Picture download failed! Only %s pictures donwloaded." % picture_count
		
	$DownloadDialog.popup_centered()


func _on_Back_pressed() -> void:
	menus.change_menu(menus.previous_menu)
