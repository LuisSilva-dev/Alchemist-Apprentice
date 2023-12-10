extends Node2D

static var timeFill = 3
static var timeMix = 2
static var maxTime = 7
static var timeOfDay = 60*8
static var startingHour = 8

var hasPotion
var potion
var hasIngredient
var handIngredient
var isOpen
var curTimeFill
var curTimeMix
var curClientTime
var curTime
var time
var reqInd
var timeLabelNode
var moneyLabelNode
var money

# Called when the node enters the scene tree for the first time.
func _ready():
	hasPotion = false
	hasIngredient = false
	isOpen = false
	potion = ""
	curTimeFill = 0.0
	curTimeMix = 0.0
	curTime = 0.0
	curClientTime = 0.0
	money = 0
	timeLabelNode = get_node("Time")
	reqInd = 1
	time = RandomNumberGenerator.new().randf_range(0, maxTime)
	print("Time: ", time)
	var n = 1
	while n <= 4:
		var coll = "TalkBubbleAll/Collision"+str(n)
		var obj = "TalkBubbleAll/TalkBubble"+str(n)
		get_node(coll).disabled = true
		get_node(obj).visible = false
		print("Is visible: ", get_node(obj).visible)
		n += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if curTimeFill > 0 and curTimeFill <= timeFill:
		curTimeFill += delta
	if curTimeMix > 0 and curTimeMix <= timeMix:
		curTimeMix += delta
	if curClientTime >= time and isOpen:
		_makeRequests()
	timeLabelNode.text = "Time: %01d:%02d" % [startingHour + (curTime / 60), fmod(curTime, 60.0)]
	curClientTime += delta
	curTime += delta
	if(curTime >= timeOfDay):
		get_tree().change_scene_to_file("res://MenuScreen.tscn")
	


func _potion_box_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and isOpen and !hasIngredient:
			print("I got the potion from the box")
			hasPotion = !hasPotion
			potion = "Nothing"


func _alchemist_setup_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and isOpen:
		if hasPotion:
			print("I clicked the setup with potion")
			hasPotion = false
			potion = "liquid"
			curTimeFill = 0.01
			# add a potion to background sprite
		elif hasIngredient && curTimeFill >= timeFill:
			print("I clicked the setup with ingredient")
			hasIngredient = false
			potion = $Alchemist_Setup.getPotion(potion, handIngredient)
			curTimeMix = 0.01
		elif curTimeMix >= timeMix:
			print("Took out the potion")
			hasPotion = true
			# potion in hand
		
		


func _ingredient_box_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and isOpen and !hasPotion:
		print("I clicked the ingredient box")
		hasIngredient = !hasIngredient
		handIngredient = "red"
		# add ingredient to setup
		

func _open_sign_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("sign clicked")
		isOpen = true
		$OpenSign/Sign.text = "Open"


func _hand_book_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("book clicked")
		# display popup instructions
		


func _talk_bubble_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and hasPotion:
		match shape_idx:
			0:
				if $TalkBubbleAll/Collision1.gotProduct(potion):
					money += 5
					moneyLabelNode.text = "Money: " + str(money)
				$TalkBubbleAll/TalkBubble1.visible = false
				$TalkBubbleAll/Collision1.disabled = true
				
			1:
				if $TalkBubbleAll/Collision2.gotProduct(potion):
					money += 5
					moneyLabelNode.text = "Money: " + str(money)
				$TalkBubbleAll/TalkBubble2.visible = false
				$TalkBubbleAll/Collision2.disabled = true
			2:
				if $TalkBubbleAll/Collision3.gotProduct(potion):
					money += 5
					moneyLabelNode.text = "Money: " + str(money)
				$TalkBubbleAll/TalkBubble3.visible = false
				$TalkBubbleAll/Collision3.disabled = true
			3:
				if $TalkBubbleAll/Collision4.gotProduct(potion):
					money += 5
					moneyLabelNode.text = "Money: " + str(money)
				$TalkBubbleAll/TalkBubble4.visible = false
				$TalkBubbleAll/Collision4.disabled = true
		hasPotion = false
		curTimeFill = 0
		curTimeMix = 0
				
func _makeRequests():
	if get_node("TalkBubbleAll/Collision"+str(reqInd)).disabled:
		get_node("TalkBubbleAll/TalkBubble"+str(reqInd)).makeRequest()
		get_node("TalkBubbleAll/Collision"+str(reqInd)).disabled = false
		get_node("TalkBubbleAll/TalkBubble"+str(reqInd)).visible = true
		time = RandomNumberGenerator.new().randf_range(0, maxTime)
		curClientTime = 0.0
		
	reqInd = RandomNumberGenerator.new().randi_range(1, 4)
