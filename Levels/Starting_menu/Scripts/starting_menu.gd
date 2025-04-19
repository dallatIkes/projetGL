extends VBoxContainer

const WORLD = preload("res://Levels/Test/demo.tscn")
func _on_startbutton_pressed() -> void:
	get_tree().change_scene_to_packed(WORLD)


func _on_quitbutton_pressed() -> void:
	get_tree().quit()
