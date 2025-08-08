extends Node2D
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



#SPEED

func _physics_process(delta):
	
	speed += acceleration * delta
	if speed > max_speed:
		speed = max_speed

	
	var direction = Vector2.RIGHT.rotated(deg_to_rad(move_angle))
	
	velocity = direction * speed
	move_and_slide()
	
# HEALTH

func DamageTaken(Damage:int):
	CurrentHealth= CurrentHealth-Damage
	if CurrentHealth<=0:
		die()

func Heal(Amount:int):
	CurrentHealth= CurrentHealth-Amount
	

func increase_max_health(Amount: int):
	MaxHealth+=Amount
	CurrentHealth+=Amount
	

func die():
	pass

#OXYGEN
