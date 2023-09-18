extends CanvasLayer

signal start_game

func update_score(score):
	$ScoreLabel.text = str(score)



func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()


func show_game_over():
	show_message("Game Over")
	await($MessageTimer.timeout)
	$MessageLabel.text = "Dodge The Creeps"
	$MessageLabel.show()
	await(get_tree().create_timer(1.0).timeout)
	$Start.show()

func _on_start_pressed():
	$Start.hide()
	emit_signal("start_game")


func _on_message_timer_timeout():
	
	$MessageLabel.hide()


