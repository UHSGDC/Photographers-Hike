extends ParallaxLayer


var transitioning: bool = false
export var CLOUD_SPEED: float

var first: bool = true

onready var sprite = $Sprite
onready var transition_sprite = $TransitionSprite


func _ready() -> void:
	Global.connect("level_changed", self, "_on_level_changed")
	
	
func _process(delta: float) -> void:
	if transitioning:
		sprite.modulate.a -= delta
		transition_sprite.modulate.a += delta
		if transition_sprite.modulate.a >= 1:
			transition_sprite.modulate.a = 0
			sprite.modulate.a = 1
			sprite.texture = transition_sprite.texture
			transitioning = false
			
	if Global.current_level == "Snowy Tundra" or Global.current_level == "Summit":
		motion_offset.x -= delta * CLOUD_SPEED
			
	
	
func _on_level_changed(level: String) -> void:
	if first:
		sprite.texture = load("res://Assets/Art/Backgrounds/%sBackground%s.png" % [level, name[13]])
		transition_sprite.modulate.a = 0
		sprite.modulate.a = 1
		first = false
		return
	
	if transitioning:
		var temp = sprite
		sprite = transition_sprite
		transition_sprite = temp
	else:
		transition_sprite.texture = load("res://Assets/Art/Backgrounds/%sBackground%s.png" % [level, name[13]])
		transition_sprite.modulate.a = 0
		sprite.modulate.a = 1
		
		
	transitioning = true
