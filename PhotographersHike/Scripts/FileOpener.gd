extends Node

#Just opens a text file, nothing crazy. 
#But it could be used to load save data / highscores

func _ready():
	print(load_file("res://test_textfile.tres"))



func file_write(filepath, content) -> void:
	var file = File.new()
	file.open(filepath, File.WRITE)
	file.store_string(content)
	file.close()

func file_append(filepath, content) -> void:
        file_write(read_file(filepath) + content)
	

func read_file(filepath) -> String:
	var file = File.new()
	file.open(filepath, File.READ)
	var content = file.get_as_text()
	file.close()
	return content


