extends Area2D

var ingredients
var potions

# Called when the node enters the scene tree for the first time.
func _ready():
	ingredients = ["red", "blue", "green"]
	potions = ["health", "mana", "stamina", "cure", "strength", "poison"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func getPotions(index):
	return potions[index]

func getPotion(potion, ingredient, anim):
	if potion == "liquid":
		potion = ingredient
		if ingredient == "red":
			anim.play("HealthTrans")
		elif ingredient == "green":
			anim.play("StaminaTrans")
		elif ingredient == "blue":
			anim.play("ManaTrans")
	elif (potion == "red" and ingredient == "blue") or (potion == "blue" and ingredient == "red"):
		potion = "white"
		anim.play("CureTrans")
	elif (potion == "red" and ingredient == "green") or (potion == "green" and ingredient == "red"):
		potion = "orange"
		anim.play("StrenghtTrans")
	elif (potion == "blue" and ingredient == "green") or (ingredient == "blue" and potion == "green"):
		potion = "black"
		anim.play("PoisonTrans")
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
	return potion
	
func getIngredients(index):
	return ingredients[index]
