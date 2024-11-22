extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -250.0  # Adjust based on desired jump height

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var floor_level = 0.0
var jumping = false
var jump_from = 0.0

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	# Ensure the velocity starts at zero when the game starts.
	velocity = Vector2.ZERO

func _physics_process(delta):
	# Get the input direction for X axis.
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	
	# Prevent upward movement above floor_level, but allow downward movement.
	if position.y <= floor_level + 2 and direction_y < 0:
		direction_y = 0

	# Combine the directions into a Vector2.
	var direction = Vector2(direction_x, direction_y).normalized()

	# Flip the Sprite based on X direction.
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true

	# Handle jumping only when the character is on the floor.
	if Input.is_action_just_pressed("jump") and not jumping and position.y >= floor_level:
		velocity.y = JUMP_VELOCITY
		jumping = true
		jump_from = position.y
	
	# Apply gravity if above the floor level to bring the character back down after jumping.
	if jumping:
		if position.y <= jump_from:
			velocity.y += gravity * delta
		else:
			velocity.y -= gravity * delta
			jumping = false

	# Play animations.
	if position.y >= floor_level:
		if direction == Vector2.ZERO:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walk")
	else:
		animated_sprite.play("jump")
	
	# Apply movement.
	velocity.x = direction.x * SPEED
	if not jumping:
		velocity.y = direction.y * SPEED
	
	# Move the character using move_and_slide().
	move_and_slide()
