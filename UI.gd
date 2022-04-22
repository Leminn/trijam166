extends Control

var score := 0

signal no_cheese()

func _process(_delta):
	if Cheeseman.cheese_amount < 6:
		$button_prompt.visible = true
	else:
		$button_prompt.visible = false
	if Input.is_action_just_pressed("retry") and $EndScreen.visible:
		Cheeseman.cheese_amount = 6
		get_tree().reload_current_scene()
		$ScoreTimer.start()


func _on_Player_cheese_eaten():
	if Cheeseman.cheese_amount > -1:
		Cheeseman.cheese_amount -= 1

		match(Cheeseman.cheese_amount):
			5:
				$StatusGUI/CheeseText.text = "CHEES"
				$StatusGUI/CheesePic.frame = 1
			4:
				$StatusGUI/CheeseText.text = "CHEE"
				$StatusGUI/CheesePic.frame = 2
			3:
				$StatusGUI/CheeseText.text = "CHE"
				$StatusGUI/CheesePic.frame = 3
			2:
				$StatusGUI/CheeseText.text = "CH"
				$StatusGUI/CheesePic.frame = 4
			1:
				$StatusGUI/CheeseText.text = "C"
				$StatusGUI/CheesePic.frame = 5
			0: 
				$StatusGUI/CheeseText.text = ""
				$StatusGUI/CheesePic.visible = false


func _on_Player_cheese_repair():
		if Cheeseman.cheese_amount < 6:
			Cheeseman.cheese_amount += 1
			$StatusGUI/CheesePic.visible = true
			match(Cheeseman.cheese_amount):
				6:
					$StatusGUI/CheeseText.text = "CHEESE"
					$StatusGUI/CheesePic.frame = 0
				5:
					$StatusGUI/CheeseText.text = "CHEES"
					$StatusGUI/CheesePic.frame = 1
				4:
					$StatusGUI/CheeseText.text = "CHEE"
					$StatusGUI/CheesePic.frame = 2
				3:
					$StatusGUI/CheeseText.text = "CHE"
					$StatusGUI/CheesePic.frame = 3
				2:
					$StatusGUI/CheeseText.text = "CH"
					$StatusGUI/CheesePic.frame = 4
				1:
					$StatusGUI/CheeseText.text = "C"
					$StatusGUI/CheesePic.frame = 5


func _on_ScoreTimer_timeout():
	score += 1
	$Score.text = "Score: " + str(score)
	$EndScreen/Score.text = "Score: " + str(score)


func _on_killzone_body_entered(body):
	if body.name == "Player":
		$EndScreen.visible = true
		$ScoreTimer.stop()

