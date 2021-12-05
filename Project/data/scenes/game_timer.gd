extends Label


var timeCounter: float=0.0
var timeLeft: int = 90

func _physics_process(delta:float)->void:
	timeCounter += delta
	if(int(timeCounter)==1):
		timeLeft -= 1
		timeCounter = 0
		print(timeLeft)
		
	if (timeLeft <= 0):
		timeLeft = 0


func _process(delta):
   self.text = "Time: " + str(timeLeft);
