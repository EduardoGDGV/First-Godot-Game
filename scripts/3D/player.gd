extends CharacterBody3D

const SPEED = 4.0
const JUMP_VELOCITY = 8.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 2.5

@onready var animated_sprite = $AnimatedSprite3D
@onready var camera = $camorigin

func _ready():
	# Ensure the velocity starts at zero when the game starts.
	velocity = Vector3.ZERO

func _physics_process(delta):
	# Apply gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		# Make sure to reset the vertical velocity when on the ground to avoid floating.
		velocity.y = 0

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction for X and Z axes.
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_z = Input.get_axis("move_up", "move_down")
	
	# Combine the directions into a Vector3.
	var direction = Vector3(direction_x, 0, direction_z).rotated(Vector3.UP, camera.rotation.y).normalized()

	# Flip the Sprite based on X direction.
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
	
	# Play animations.
	if is_on_floor():
		if direction == Vector3.ZERO:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walk")
	else:
		animated_sprite.play("jump")
	
	# Apply movement.
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

	# Move the character using move_and_slide.
	move_and_slide()
