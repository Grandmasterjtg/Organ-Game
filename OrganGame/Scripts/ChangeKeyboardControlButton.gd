extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal cancel
var listening = false
export var action = ""
export var default = ""
var key = InputEventKey.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("button_up", self, "_button_pressed")
	if InputMap.get_action_list(action).front() == null:
		print("Specified action does not exist in Button")
	else:
		text = default

func _button_pressed():
	emit_signal("cancel")
	listening = true
	text = ""

func _cancel():
	listening = false
	text = key.as_text()
	if text == "":
		text = default

func _input(ev):
	if listening and ev is InputEventKey:
		for i in InputMap.get_action_list(action):
			if i is InputEventKey:
				InputMap.action_erase_event(action, i)
		key = ev
		InputMap.action_add_event(action, ev)
		text = ev.as_text()
		listening = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

