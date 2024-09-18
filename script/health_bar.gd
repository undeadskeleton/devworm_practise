extends ProgressBar

var parent
var max_health
var min_health

func _ready() -> void:
	parent = get_parent()
	max_health = parent.max_health
	min_health = parent.min_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.value = parent.health
	if parent.health != max_health:
		self.visible = true
		if parent.health == min_health:
			self.visible = false
	else:
		self.visible = false
