extends Node3D

# Store the target rotation angle, starting at 0.
var target_rotation_y: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Check if the rotate_camera action is triggered.
	if Input.is_action_just_pressed("rotate_camera"):
		# Increase the target rotation by 90 degrees.
		target_rotation_y += 90.0

	# Smoothly interpolate towards the target rotation.
	rotation.y = lerp_angle(rotation.y, deg_to_rad(target_rotation_y), 5.0 * delta)

	# Ensure the target rotation remains a multiple of 90.
	target_rotation_y = round(target_rotation_y / 90.0) * 90.0
