extends Node

var player: Node

func set_player(playerNode):
	player = playerNode
	
func set_timeout(callback: Callable, delay: float) -> void:
	# Create a one-shot timer
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = delay
	add_child(timer)  # Add the timer to the scene tree
	timer.start()

	# Wait for the timer to finish
	await timer.timeout

	# Call the provided callback
	callback.call()

	# Remove the timer from the scene tree
	timer.queue_free()
