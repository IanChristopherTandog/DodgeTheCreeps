extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")

	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	
func update_score(_score):
	$ScoreLabel.text = str(Global.score)

func update_Hscore(_highscore):
	$HighScore.text = "High Score: " + str(Global.highscore)
func _ready():
	pass
func _process(_delta):
	
	hearts()
	pass


func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Message.hide()

func hearts():
	if Global.hp == 3:
		$hearts/heart1.show()
		$hearts/heart2.show()
		$hearts/heart3.show()
	elif Global.hp == 2:
		$hearts/heart3.hide()
	elif Global.hp == 1:
		$hearts/heart2.hide()
	elif Global.hp == 0:
		$hearts/heart1.hide()
		$hearts/heart2.hide()
		$hearts/heart3.hide()
