extends Node3D

@onready var bg_viewport: SubViewport = $Base/BGViewportContainer/BGViewport
@onready var fg_viewport: SubViewport = $Base/FGViewportContainer/FGViewport

@onready var background: Camera3D = $Base/BGViewportContainer/BGViewport/Background
@onready var foreground: Camera3D = $Base/FGViewportContainer/FGViewport/Foreground

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resize()

func resize():
	bg_viewport.size = DisplayServer.window_get_size()
	fg_viewport.size = DisplayServer.window_get_size()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	background.global_transform = GameManager.player.camera_attach.global_transform
	foreground.global_transform = GameManager.player.camera_attach.global_transform
