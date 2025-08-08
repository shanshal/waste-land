extends ProgressBar
@onready var HealthBar = $ProgressBar

func _ready():
   
	HealthBar.show_percentage = true
	
func update_health(CurrentHealth: int, MaxHealth: int):
	HealthBar.max_value = MaxHealth
	HealthBar.value = CurrentHealth
	
	
	
	var health_percentage = float(CurrentHealth) / float(MaxHealth)
	if health_percentage > 0.6:
		HealthBar.modulate = Color.GREEN
	elif health_percentage > 0.3:
		HealthBar.modulate = Color.YELLOW
	else:
		HealthBar.modulate = Color.RED




func _on_submarine_health_changed(current_health: int, max_health: int) -> void:
	update_health(current_health,max_health) # Replace with function body.


func _on_submarine_submarine_died() -> void:
	pass # Replace with function body.


func _on_submarine_oxygen_depleted() -> void:
	pass # Replace with function body.


func _on_submarine_oxygen_changed(current_oxygen: float, max_oxygen: float) -> void:
	pass # Replace with function body.
