extends Area2D

var ingredients
var potions

# Called when the node enters the scene tree for the first time.
func _ready():
	ingredients = ["red", "blue", "green"]
	potions = ["health", "mana", "stamina", "cure", "strenght", "poison"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func getPotions(index):
	return potions[index]

func getPotion(potion, ingredient):
	if potion == "liquid":
		potion = ingredient
	elif potion == "red" and ingredient == "blue":
		potion = "white"
	elif potion == "red" and ingredient == "green":
		potion = "orange"
	elif potion == "blue" and ingredient == "green":
		potion = "black"
	print(potion)
	return potion
	
func finishPotion(potion):
	if potion == "red":
		return "health"
	elif potion == "green":
		return "stamina"
	elif potion == "blue":
		return "mana"
	elif potion == "orange":
		return "strength"
	elif potion == "black":
		return "poison"
	elif potion == "white":
		return "cure"
	
func getIngredients(index):
	return ingredients[index]
