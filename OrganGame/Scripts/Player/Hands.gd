extends Node2D

var fightColl = []
var disableColl = true
export var group := "P1Colliders"


export var group_name = ""

func _ready():
	handle_all_collider_disabling(true)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		disableColl = !disableColl
		handle_specific_collider_disabling(disableColl, 1)


func handle_all_collider_disabling(isDisabled : bool) -> void:
	var h = 0
	for collider in get_tree().get_nodes_in_group(group):
		fightColl.insert(h, collider)
		fightColl[h].set_disabled(isDisabled)
		
		if fightColl[h].is_disabled():
			print (fightColl[h].name + " is disabled")
		elif !fightColl[h].is_disabled():
			print (fightColl[h].name + " is NOT disabled")
		h += 1
		
	
func handle_specific_collider_disabling(isDisabled : bool, index : int) -> void:
	 fightColl[index].set_disabled(isDisabled)
