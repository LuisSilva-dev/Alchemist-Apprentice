extends Node2D

@export var money: int

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameOver.text = "Game Over\n Money: " + money

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
