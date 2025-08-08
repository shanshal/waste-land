extends CharacterBody2D
var speed: float = 0           
var acceleration: float = 20   
var max_speed: float = 200     
var move_angle: float = 20     

var MaxHealth: int=100
var CurrentHealth: int= MaxHealth 

var max_oxygen: float = 100.0
var oxygen_depletion_rate: float = 2.0  
var oxygen_damage_rate: float = 10.0    
var current_oxygen: float
var oxygen_timer: Timer
var damage_timer: Timer

@onready var harpoon_mount = $HarpoonMount
@onready var harpoon = $HarpoonMount/Harpoon


signal health_changed(current_health: int, max_health: int)
signal oxygen_changed(current_oxygen: float, max_oxygen: float)
signal oxygen_depleted
signal submarine_died

#SPEED

func _physics_process(delta):
	
	speed += acceleration * delta
	if speed > max_speed:
		speed = max_speed

	
	var direction = Vector2.RIGHT.rotated(deg_to_rad(move_angle))
	
	velocity = direction * speed
	move_and_slide()
	update_harpoon_rotation()
	
# HEALTH

func _ready():
	CurrentHealth=MaxHealth
	health_changed.emit(CurrentHealth,MaxHealth)

func DamageTaken(Damage:int):
	CurrentHealth= CurrentHealth-Damage
	if CurrentHealth<=0:
		die()

func Heal(Amount:int):
	CurrentHealth= CurrentHealth-Amount
	health_changed.emit(CurrentHealth,MaxHealth)
	emit_signal(Heal(Amount))
	

func increase_max_health(Amount: int):
	MaxHealth+=Amount
	CurrentHealth+=Amount
	health_changed.emit(CurrentHealth,MaxHealth)
	

func die():
	submarine_died.emit()
	pass

#OXYGEN
func OxygenDeplation():
	current_oxygen=max_oxygen
	
	oxygen_timer=Timer.new()
	oxygen_timer.wait_time=0.1
	oxygen_timer.timeout.connect(_on_oxygen_timer_timeout)
	add_child(oxygen_timer)
	oxygen_timer.start()
	
	damage_timer=Timer.new()
	damage_timer.wait_time=0.1
	damage_timer.timeout.connect(die)
	add_child(damage_timer)
	damage_timer.start()
	
	oxygen_changed.emit(current_oxygen, max_oxygen)
	
func _on_oxygen_timer_timeout():
	current_oxygen -= oxygen_depletion_rate * oxygen_timer.wait_time
	oxygen_changed.emit(current_oxygen, max_oxygen)

	if current_oxygen <= 0:
		if not damage_timer.is_stopped():
			return
		oxygen_depleted.emit()
		damage_timer.emit()
	else :
		damage_timer.stop()
		  
		  
func _on_damage_timer_timeout():
	if current_oxygen<=0:
		take_damage(oxygen_damage_rate)
		
func take_damage(Damage: int):
	CurrentHealth= CurrentHealth-Damage
	if CurrentHealth<=0:
		die()
func restore_oxygen(Kelp: float):
	current_oxygen+= Kelp
	oxygen_changed.emit(current_oxygen, max_oxygen)
	
func increas_max_oxygen(Kelp: float):
	max_oxygen+= Kelp
	current_oxygen+= Kelp
	oxygen_changed.emit(current_oxygen, max_oxygen)
	

#HARPOON

func update_harpoon_rotation():
	var MousePosition= get_global_mouse_position()
	var direction= MousePosition - harpoon_mount.global_position
	
	harpoon.rotation= direction.angle()
