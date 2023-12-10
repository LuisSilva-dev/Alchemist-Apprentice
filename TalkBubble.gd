extends Sprite2D

static var timer = 15
static var maxTime = 7

var currentTime: float
var request
var dialog
var time

# Called when the node enters the scene tree for the first time.
func _ready():
	currentTime = 0
	dialog = ["Thank you", "Not the potion"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	currentTime += 1/60
	
func gotProduct(potionName):
	print("request " + request + " potion: " + potionName)
	if request == potionName:
		print(dialog[1])
		return true
	else:
		print(dialog[2])
		return false
	
func makeRequest():
	var potion = get_tree().get_root().get_node("World/Alchemist_Setup").getPotions(RandomNumberGenerator.new().randi_range(-1,5))
	visible = true
	request = "I want a " + potion + " potion"
	print($Dialog)
	$Dialog.text = request
	$Human.visible = true
	print("Im here")

