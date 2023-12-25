extends Node2D

static var timeFill = 3
static var timeMix = 2
static var maxTime = 7
static var timeOfDay = 60*2
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
var cursorIcon
var potionFillingNode
var backgroundFillingNode
var openTutorial

# Called when the node enters the scene tree for the first time.
func _ready():
	cursorIcon = null
	hasPotion = false
	hasIngredient = false
	isOpen = false
	openTutorial = false
	potion = ""
	curTimeFill = 0.0
	curTimeMix = 0.0
	curTime = 0.0
	curClientTime = 0.0
	money = 0
	timeLabelNode = get_node("Time")
	moneyLabelNode = get_node("Money")
	potionFillingNode = get_node("PotionFilling")
	backgroundFillingNode = get_node("Background")
	potionFillingNode.visible = false
	reqInd = 1
	time = RandomNumberGenerator.new().randf_range(0, maxTime)
	$IngredientBox/Blue.visible = false
	$IngredientBox/Red.visible = false
	$IngredientBox/Green.visible = false
	$IngredientBox/BlueCollision.disabled = true
	$IngredientBox/RedCollision.disabled = true
	$IngredientBox/GreenCollision.disabled = true
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
	for idx in range(0, 4):
		var node = get_node("TalkBubbleAll/TalkBubble"+str(idx+1))
		node.isWaiting(get_node("TalkBubbleAll/Collision"+str(idx+1)))
		if node.answerWait():
			node.visible = false
			get_node("TalkBubbleAll/Collision"+str(idx+1)).disabled = true
		if node.thanksWait():
			node.visible = false
			get_node("TalkBubbleAll/Collision"+str(idx+1)).disabled = true
	if(curTime >= timeOfDay):
		get_tree().change_scene_to_file("res://MenuScreen.tscn")


func _input(event):
	if cursorIcon != null and event is InputEventMouseMotion:
		cursorIcon.position = event.position
	


func _potion_box_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and isOpen and !hasIngredient:
		print("I got the potion from the box")
		hasPotion = !hasPotion
		potion = "Nothing"
		if cursorIcon != null:
			cursorIcon.queue_free()
			cursorIcon = null
		else:
			cursorIcon = load("res://EmptyPotion.tscn").instantiate()
			add_child(cursorIcon)


func _alchemist_setup_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and isOpen:
		if hasPotion:
			hasPotion = false
			potion = "liquid"
			curTimeFill = 0.01
			potionFillingNode.visible = true
			backgroundFillingNode.visible = true
			potionFillingNode.stop()
			potionFillingNode.play("Filling")
			backgroundFillingNode.get_child(0).stop()
			backgroundFillingNode.get_child(0).play("Filling")
			if cursorIcon != null:
				cursorIcon.queue_free()
				cursorIcon = null
		if curTimeFill >= timeFill:
			if hasIngredient:
				print("I clicked the setup with ingredient")
				hasIngredient = false
				potion = $Alchemist_Setup.getPotion(potion, handIngredient, potionFillingNode)
				curTimeMix = 0.01
				if cursorIcon != null:
					cursorIcon.queue_free()
					cursorIcon = null
			elif curTimeMix >= timeMix or curTimeMix == 0.0:
				print("Took out the potion")
				hasPotion = true
				potion = $Alchemist_Setup.finishPotion(potion)
				potionFillingNode.visible = false
				if potion == "health":
					cursorIcon = load("res://HealthPotion.tscn").instantiate()
				elif potion == "mana":
					cursorIcon = load("res://ManaPotion.tscn").instantiate()
				elif potion == "stamina":
					cursorIcon = load("res://StaminaPotion.tscn").instantiate()
				elif potion == "strength":
					cursorIcon = load("res://StrengthPotion.tscn").instantiate()
					print("cursorIcon ", cursorIcon)
				elif potion == "cure":
					cursorIcon = load("res://CurePotion.tscn").instantiate()
				elif potion == "poison":
					cursorIcon = load("res://PoisonPotion.tscn").instantiate()
				elif potion == "liquid":
					cursorIcon = load("res://Liquid.tscn").instantiate()
				add_child(cursorIcon)


func _ingredient_box_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and isOpen and !hasPotion:
		if cursorIcon != null:
			cursorIcon.queue_free()
			cursorIcon = null
		if shape_idx == 0:
			print("I clicked the ingredient box")
			$IngredientBox/Blue.visible = !$IngredientBox/Blue.visible
			$IngredientBox/Red.visible = !$IngredientBox/Red.visible
			$IngredientBox/Green.visible = !$IngredientBox/Green.visible
			$IngredientBox/BlueCollision.disabled = !$IngredientBox/BlueCollision.disabled
			$IngredientBox/RedCollision.disabled = !$IngredientBox/RedCollision.disabled
			$IngredientBox/GreenCollision.disabled = !$IngredientBox/GreenCollision.disabled
			hasIngredient = false
		else:
			match shape_idx:
				1:
					handIngredient = "blue"
					cursorIcon = load("res://BlueSprite.tscn").instantiate()
				2:
					handIngredient = "green"
					cursorIcon = load("res://GreenSprite.tscn").instantiate()
				3:
					handIngredient = "red"
					cursorIcon = load("res://RedSprite.tscn").instantiate()
			add_child(cursorIcon)
			hasIngredient = true
		

func _open_sign_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("sign clicked")
		isOpen = true
		$OpenSign/Sign.text = "Open"


func _hand_book_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		$Tutorial.visible = !openTutorial
		openTutorial = !openTutorial


func _talk_bubble_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and hasPotion:
		print("shaped idx: ", shape_idx)
		if get_node("TalkBubbleAll/TalkBubble"+str(shape_idx+1)).gotProduct(potion):
			money += 5
			moneyLabelNode.text = "Money: " + str(money)
			get_node("TalkBubbleAll/TalkBubble"+str(shape_idx+1)).startThanksTimer(true, get_node("TalkBubbleAll/Collision"+str(shape_idx+1)))
		else:
			get_node("TalkBubbleAll/TalkBubble"+str(shape_idx+1)).startThanksTimer(false, get_node("TalkBubbleAll/Collision"+str(shape_idx+1)))
		hasPotion = false
		curTimeFill = 0
		curTimeMix = 0
		if cursorIcon != null:
			cursorIcon.queue_free()
			cursorIcon = null
	

func _makeRequests():
	if get_node("TalkBubbleAll/Collision"+str(reqInd)).disabled:
		get_node("TalkBubbleAll/TalkBubble"+str(reqInd)).makeRequest()
		get_node("TalkBubbleAll/Collision"+str(reqInd)).disabled = false
		get_node("TalkBubbleAll/TalkBubble"+str(reqInd)).visible = true
		time = RandomNumberGenerator.new().randf_range(0, maxTime)
	reqInd = RandomNumberGenerator.new().randi_range(1, 4)
	curClientTime = 0.0
