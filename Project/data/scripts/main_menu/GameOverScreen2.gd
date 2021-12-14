extends CanvasLayer

func _on_RestartButton_pressed():
	print("Restart")
	get_tree().change_scene("res://data/scenes/Main_Menu.tscn")
	


func _on_QuitButton_pressed():
	get_tree().quit()
