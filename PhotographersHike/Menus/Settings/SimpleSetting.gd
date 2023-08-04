extends HSplitContainer
tool

signal value_changed(value)

enum Setting {
	NUMBER,
	PERCENT,
	STRING,
	SWITCH,
}

var current_value
var current_value_index: int

export var setting_name: String

export(Setting) var setting_type
export var initial_value: int

export var value_string_array: PoolStringArray
export var max_value: int
export var min_value: int

var DECREASE_BUTTON: Button

var INCREASE_BUTTON: Button

export var update_settings: bool setget update_export_settings


func _on_SimpleSetting_tree_entered() -> void:
	if DECREASE_BUTTON:
		return
	DECREASE_BUTTON = $Button/Decrease
	INCREASE_BUTTON = $Button/Increase
	_connect_button_signals()


func _connect_button_signals() -> void:
	match setting_type:
		Setting.NUMBER:
			DECREASE_BUTTON.connect("pressed", self, "_on_number_decreased")
			INCREASE_BUTTON.connect("pressed", self, "_on_number_increased")

		Setting.PERCENT:
			DECREASE_BUTTON.connect("pressed", self, "_on_percent_decreased")
			INCREASE_BUTTON.connect("pressed", self, "_on_percent_increased")
			
		Setting.STRING:
			DECREASE_BUTTON.connect("pressed", self, "_on_string_decreased")
			INCREASE_BUTTON.connect("pressed", self, "_on_string_increased")
			
		Setting.SWITCH:
			DECREASE_BUTTON.connect("pressed", self, "_on_switch_decreased")
			INCREASE_BUTTON.connect("pressed", self, "_on_switch_increased")


func _ready() -> void:
	_update()


func update_export_settings(new_value) -> void:
	update_settings = false
	_update()
				
	
func _update() -> void:
	DECREASE_BUTTON = $Button/Decrease
	INCREASE_BUTTON = $Button/Increase
	INCREASE_BUTTON.disabled = false
	DECREASE_BUTTON.disabled = false
	$Label.text = setting_name
	_update_button()


func _update_button() -> void:
	match setting_type:
		Setting.NUMBER:
			current_value = int(clamp(initial_value, min_value, max_value))
			
			if current_value >= max_value:
				INCREASE_BUTTON.disabled = true
				current_value = max_value
			if current_value <= min_value:
				DECREASE_BUTTON.disabled = true
				current_value = min_value
				
			_update_label(str(current_value))
			
		Setting.PERCENT:
			current_value = int(clamp(initial_value, 0, 100))
			
			if current_value >= 100:
				INCREASE_BUTTON.disabled = true
				current_value = 100
			elif current_value <= 0:
				DECREASE_BUTTON.disabled = true
				current_value = 0
				
			_update_label(str(current_value) + "%")
			
		Setting.STRING:
			
			current_value_index = initial_value
			
			if current_value_index >= value_string_array.size() - 1:
				INCREASE_BUTTON.disabled = true
				current_value_index = value_string_array.size() - 1
				
			if current_value_index <= 0:
				DECREASE_BUTTON.disabled = true
				current_value_index = 0
			
			current_value = str(value_string_array[current_value_index])
			_update_label(current_value)
			
		Setting.SWITCH:
			current_value = bool(initial_value)
			
			if current_value:
				_update_label("On")
				INCREASE_BUTTON.disabled = true
			else:
				_update_label("Off")
				DECREASE_BUTTON.disabled = true


func _update_label(text: String) -> void:
	$Button/Value.text = text
	if !Engine.editor_hint:
		emit_signal("value_changed", current_value)


func _on_number_decreased() -> void:
	INCREASE_BUTTON.disabled = false
	current_value -= 1
	
	if current_value <= min_value:
		current_value = min_value
		DECREASE_BUTTON.disabled = true
	
	_update_label(str(current_value))
	

func _on_number_increased() -> void:
	DECREASE_BUTTON.disabled = false
	current_value += 1
	
	if current_value >= max_value:
		current_value = max_value
		INCREASE_BUTTON.disabled = true
		
	_update_label(str(current_value))


func _on_percent_decreased() -> void:
	INCREASE_BUTTON.disabled = false
	current_value -= 1
	
	if current_value <= 0:
		current_value = 0
		DECREASE_BUTTON.disabled = true
		
	_update_label(str(current_value) + "%")
	

func _on_percent_increased() -> void:
	DECREASE_BUTTON.disabled = false
	current_value += 1
	
	if current_value >= 100:
		current_value = 100
		INCREASE_BUTTON.disabled = true
		
	_update_label(str(current_value) + "%")


func _on_string_decreased() -> void:
	INCREASE_BUTTON.disabled = false
	current_value_index -= 1
	
	if current_value_index <= 0:
		current_value_index = 0
		DECREASE_BUTTON.disabled = true
		
	current_value = value_string_array[current_value_index]
		
	_update_label(current_value)
	

func _on_string_increased() -> void:
	DECREASE_BUTTON.disabled = false
	current_value_index += 1
	
	if current_value_index >= value_string_array.size() - 1:
		current_value_index = value_string_array.size() - 1
		INCREASE_BUTTON.disabled = true
		
	current_value = value_string_array[current_value_index]
		
	_update_label(current_value)
	
	
func _on_switch_decreased() -> void:
	DECREASE_BUTTON.disabled = true
	INCREASE_BUTTON.disabled = false
	
	current_value = false
	_update_label("Off")
	

func _on_switch_increased() -> void:
	INCREASE_BUTTON.disabled = true
	DECREASE_BUTTON.disabled = false
	
	current_value = true
	_update_label("On")

