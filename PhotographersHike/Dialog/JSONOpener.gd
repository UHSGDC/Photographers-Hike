extends Node

class_name JSONOpener

static func get_string(filepath: String) -> String:
	var file: File = File.new()
	file.open(filepath, File.READ)
	var content = file.get_as_text()
	file.close()
	return content


static func get_data(filepath: String): 
	var contents: String = get_string(filepath)
	var json_data = JSON.parse(contents).get_result()
	return json_data

