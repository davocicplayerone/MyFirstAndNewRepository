extends Node
@export var mob_scene: PackedScene
var score: int = 0

func _ready():
	pass

func _process(_delta: float):
	pass


func _on_player_hit(body: Node2D):
	if $Player.is_boost:
		print("Enemy got hit!")
		score += 10
		body.modulate = Color(0.5, 0, 0)
		body.gravity_scale = 1
	else:
		print("Game over!")
		game_over()

func new_game():
	score = 0
	$HUD.update_score(score)
	
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	
	$StartTimer.start()
	
	$HUD.show_message("Get ready...")
	await($StartTimer.timeout)
	$ScoreTimer.start()
	
	
	$MobTimer.start()
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop
	$HUD.show_game_over()
	

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	var direction = mob_spawn_location.rotation + PI / 2

	mob.position = mob_spawn_location.position 
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
