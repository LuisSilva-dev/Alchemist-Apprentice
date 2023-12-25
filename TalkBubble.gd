extends Sprite2D

static var timer = 15
static var maxTime = 7
static var maxWaitingTime = 12
static var maxAnswerTime = 3
static var maxThanksTime = 3

var currentTime
var request
var dialog
var time
var thanksTime

# Called when the node enters the scene tree for the first time.
func _ready():
	dialog = ["Thank you!", "Not the potion I asked!", "You take too long!"]
	currentTime = 0.0
	thanksTime = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentTime > 0.0 and thanksTime <= 0.0:
		currentTime += delta
		if currentTime < maxWaitingTime:
			$Dialog.text = "I want a " + request + " potion\n" + str(maxWaitingTime - int(currentTime))
	if thanksTime > 0.0:
		thanksTime += delta
	
func gotProduct(potionName):
	if request == potionName:
		return true
	else:
		return false
	
func makeRequest():
	request = get_tree().get_root().get_node("World/Alchemist_Setup").getPotions(RandomNumberGenerator.new().randi_range(0, 5))
	visible = true
	$Human.visible = true
	currentTime = 0.01

func isWaiting(col):
	if currentTime >= maxWaitingTime:
		$Dialog.text = dialog[2]
		col.disabled = true

func answerWait():
	if currentTime >= maxAnswerTime + maxWaitingTime:
		currentTime = 0.0
		return true
	else:
		return false
		
func thanksWait():
	if thanksTime >= maxThanksTime:
		thanksTime = 0.0
		return true
	else:
		return false
		
func startThanksTimer(good, col):
	if good:
		$Dialog.text = dialog[0]
		col.disabled = true
	else:
		$Dialog.text = dialog[1] 
		col.disabled = true
	thanksTime = 0.01
