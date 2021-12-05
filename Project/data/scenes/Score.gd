extends Label

func _process(delta):
   self.text = "Score: " + str(Globals.score);
