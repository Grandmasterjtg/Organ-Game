extends ProgressBar


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func update_progress_bar(new_hp : float) -> void:
	value = new_hp
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
