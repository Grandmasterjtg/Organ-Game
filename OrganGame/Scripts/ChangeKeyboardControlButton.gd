extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var listening = false
export var action = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("button_up", self, "_button_pressed")
	if InputMap.get_action_list(action).front() == null:
		print("Specified action does not exist in Button")
	else:
		_set_text()

func _button_pressed():
	listening = true
	text = ""

func _cancel():
	listening = false
	_set_text()

func _input(ev):
	if listening and ev is InputEventMouseButton:
		_cancel()
	if listening and ev is InputEventKey:
		for i in InputMap.get_action_list(action):
			if i is InputEventKey:
				InputMap.action_erase_event(action, i)
		InputMap.action_add_event(action, ev)
		_set_text()
		listening = false

func _set_text():
	for i in InputMap.get_action_list(action):
		if i is InputEventKey:
			text = OS.get_scancode_string(i.scancode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

