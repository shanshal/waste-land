extends Area2D

@onready var harpoon_sprite = $HarpoonSprite
@onready var harpoon_tip = $HarpoonTip

@export var rotation_speed: float = 1.0  # For smooth rotation (optional)
@export var max_range: float = 2.0

# Projectile system
@export var harpoon_projectile_scene: PackedScene  # Drag your projectile scene here
var can_fire: bool = true
@export var fire_cooldown: float = 1.0

func _ready():
	# Connect input for firing
	pass

func _input(event):
	# Fire harpoon on left mouse click
	if event.is_action_pressed("fire_harpoon"):  # You'll need to create this input action
		fire_harpoon()

func update_rotation_to_mouse():
	# Get mouse position relative to this node
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - global_position
	
	# Smooth rotation (optional)
	var target_rotation = direction.angle()
	rotation = lerp_angle(rotation, target_rotation, rotation_speed * get_process_delta_time())
	
	# Or instant rotation (simpler)
	# rotation = direction.angle()

func fire_harpoon():
	if not can_fire or not harpoon_projectile_scene:
		return
	
	# Create projectile
	var projectile = harpoon_projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	
	projectile.global_position = harpoon_tip.global_position
	projectile.rotation = rotation
	
	# Set projectile direction/velocity if it has those properties
	if projectile.has_method("set_direction"):
		var direction = Vector2.RIGHT.rotated(rotation)
		projectile.set_direction(direction)
	
	can_fire = false
	await get_tree().create_timer(fire_cooldown).timeout
	can_fire = true
