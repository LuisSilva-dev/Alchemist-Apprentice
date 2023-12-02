extends Control

var intro = "A great war is approaching.
Don't know when, don't know why.
All I know is the rumors that spread on the streets.
Are they real? Are the elves really going to attack?
With what? They have never been skilled warriors.
How can they think they'll win against two fronts?"

var character = "I'm an alchemist's apprentice.
Since he isn't here, it's my job to run this store.
When costumers come in, I should answer their requests.
I can use this recipe book that my master left me with
to guide me in this first day."

var step = 0;

func _ready():
	get_node("Intro").text = intro

func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		match step:
			0:
				get_node("Intro").text = character
			1:
				get_tree().change_scene_to_file("res://World.tscn")
		step += 1
