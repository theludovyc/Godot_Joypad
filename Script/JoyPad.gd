extends Control

var isPressed := false

var position := Vector2()

var joypad_center:Vector2

var joypad_radius:int

var max_radius:float

var stick_radius:int

var onStick := false

var stick_start_pos:Vector2

var ratio:Vector2

onready var stick = $Stick

# Called when the node enters the scene tree for the first time.
func _ready():
	joypad_center = rect_position + rect_size / 2.0
	
	joypad_radius = rect_size.x / 2.0
	
	max_radius = joypad_radius * 0.6
	
	stick_radius = stick.rect_size.x / 2.0;
	
	stick_start_pos = stick.rect_position

func _input(event):
#	if event is InputEventScreenDrag:
#		isPressed = true
#
#		position = event.position
#	else:
#		isPressed = false
	
	if event is InputEventMouseMotion:
		position = event.global_position

	if event is InputEventMouseButton:
		if event.pressed:
			isPressed = true
		else:
			isPressed = false

func clampMagnitude(vector:Vector2, maxLength:float) -> Vector2:
	if vector.length() > maxLength:
		return vector.normalized() * maxLength
	return vector

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isPressed:
		if joypad_center.distance_to(position) < stick_radius:
			onStick = true
	elif onStick:
		stick.rect_position = stick_start_pos
		
		ratio = Vector2.ZERO
		
		onStick = false
	
	if onStick:
		var pos = position - (rect_global_position + rect_size / 2.0)
		
		ratio = pos.normalized()
		
		if pos.length() > max_radius:
			pos = ratio * max_radius
		
		pos += (rect_global_position + rect_size / 2.0)

		stick.rect_global_position = pos - stick.rect_size / 2.0
	pass
