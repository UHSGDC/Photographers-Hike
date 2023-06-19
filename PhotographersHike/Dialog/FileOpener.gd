extends Node

#Just opens a text file, nothing crazy. 
#But it could be used to load save data / highscores


func file_write(filepath: String, content: String) -> void:
	var file = File.new()
	file.open(filepath, File.WRITE)
	file.store_string(content)
	file.close()

func file_append(filepath: String, content: String) -> void:
	file_write(filepath, file_read(filepath) + content)

func file_read(filepath: String) -> String:
	var file = File.new()
	file.open(filepath, File.READ)
	var content = file.get_as_text()
	file.close()
	return content


func read_json(file) -> Dictionary: 
	#var contents: String = file_read(file)
	#var json_data = JSON.parse(contents).get_result()
	
	return JSON.parse(file_read(file)).get_result()

