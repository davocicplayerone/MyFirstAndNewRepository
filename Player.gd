extends Area2D
signal hit

@export var playerSpeed = 450

var screen_size = Vector2.ZERO

@export var boost_factor: int = 4
@export_range(0, 1, 0.05, "suffix:s", "or_greater")
var boost_time: float = 0.2

@export_range(0, 5, 0.1, "suffix:s", "or_greater")
var boost_cool_down_time: float = 2

var timer_boost:= Timer.new()

var timer_cooldown := Timer.new()

var is_boost: bool = false

var is_cooldown: bool = false

@export_color_no_alpha
var boost_color: Color = Color(1, 0.5, 1)


func _ready():
	screen_size = get_viewport_rect().size
	add_child(timer_boost)
	timer_boost.wait_time = boost_time
	timer_boost.one_shot = true
	timer_boost.connect("timeout", boost_timer_timeout)
	
	add_child(timer_cooldown)
	timer_cooldown.wait_time = boost_cool_down_time
	timer_cooldown.one_shot = true
	timer_cooldown.connect("timeout", cooldown_timer_timeout)
	
	

func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * playerSpeed
	if is_boost:
		velocity *= boost_factor
	position += velocity * delta
	
	if position.x < 0:
		position.x = screen_size.x
	if position.x > screen_size.x:
		position.x = 0
	if position.y < 0:
		position.y = screen_size.y
	if position.y > screen_size.y:
		position.y = 0
	
	if Input.is_action_pressed("accelerate"):
		if not is_boost and not is_cooldown:
			timer_boost.start()
			timer_cooldown.start()
			is_boost = true
			is_cooldown = true
			$Sprite2D.modulate = boost_color
func boost_timer_timeout():
	is_boost = false
	print("Boost time out")
func cooldown_timer_timeout():
	is_cooldown = false
	$Sprite2D.modulate = Color(1, 1, 1)
	print("Cooldown time out")


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_body_entered(body):
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("hit")
	

