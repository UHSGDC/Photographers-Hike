extends BaseMenu

export var SCROLL_SPEED: float

var playing: bool = false

func _on_Back_pressed() -> void:
	menus.change_menu(menus.previous_menu)


func show() -> void:
	playing = false
	$CreditsWindow/ScrollContainer.scroll_vertical = 0
	.show()
	yield(get_tree().create_timer(0.5),"timeout")
	playing = true
	
func hide() -> void:
	.hide()
	playing = false
	
	
func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(BUTTON_WHEEL_UP) or Input.is_mouse_button_pressed(BUTTON_WHEEL_DOWN):
		playing = false
		yield(get_tree().create_timer(0.5),"timeout")
		playing = true
	
	
func _physics_process(delta: float) -> void:
	if playing:
		var multiplier: float = 1
		
		if Input.is_action_pressed("menu_confirm") or Input.is_action_pressed("left_click"):
			multiplier = 4
		
		
		$CreditsWindow/ScrollContainer.scroll_vertical += delta * SCROLL_SPEED * multiplier
	
