extends ParallaxBackground

var transitioning: bool = false
export var TRANSITION_SPEED: float

func _ready() -> void:
	Global.connect("level_changed", self, "_on_level_changed")
	
	
func _process(delta: float) -> void:
	if transitioning:
		for child in get_children():
			var sprite: Sprite = child.get_node("Sprite")
			var transition_sprite: Sprite = child.get_node("Sprite/TransitionSprite")
			sprite.modulate.a -= delta * 0.1
			transition_sprite.modulate.a += delta * 0.1
			
			
	
	
func _on_level_changed(level: String) -> void:
	

	for child in get_children():
		var sprite: Sprite = child.get_node("Sprite")
		var transition_sprite: Sprite = child.get_node("Sprite/TransitionSprite")
	
		
		transition_sprite.texture = load("res://Assets/Art/Backgrounds/%sBackground%s.png" % [level, child.name[child.name.length()-1]])
		transition_sprite.modulate.a = 0
		sprite.modulate.a = 1
		
#		if transitioning:
#			var transition_modulate = transition_sprite.modulate
#			transition_sprite.modulate = sprite.modulate
#			sprite.modulate = transition_modulate
#			transition_sprite.texture = sprite.texture
		
		
	transitioning = true
		
