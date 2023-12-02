extends Node2D

var hasPotion
var hasIngredient
var isOpen

# Called when the node enters the scene tree for the first time.
func _ready():
	hasPotion = false
	hasIngredient = false
	isOpen = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _potion_box_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("I got the potion from the box")
		hasPotion = true
		


func _alchemist_setup_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if hasPotion:
			print("I clicked the setup with potion")
			hasPotion = false
			# add a potion to background sprite
		elif hasIngredient:
			print("I clicked the setup with ingredient")
			hasIngredient = false 
		


func _ingredient_box_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("I clicked the ingredient box")
		hasIngredient = true
		# add ingredient to setup
		
