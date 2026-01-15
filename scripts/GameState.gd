extends Node

@onready var potion: Item = preload("res://Items/potion.tres")
@onready var shield: Item = preload("res://Items/shield.tres")
@onready var medkit: Item = preload("res://Items/medkit.tres")
@onready var heart: Item = preload("res://Items/heart.tres")
@onready var boost: Item = preload("res://Items/boost.tres")

var is_transitioning: bool = false

var player_health: int = 100
var max_health: int = 100
var SPEED: float = 300.0

var money: int = 200
var itemscounts = {}

var timeout_heal = false
var timeout_boost = false
var timeout_shield = false

var shield_active: bool = false

var occupied_cells: Array[Vector2i] = []

func _ready():
	itemscounts = {
		"potion": 1,
		"shield": 0,
		"medkit": 0,
		"heart": 0,
		"boost": 0
	}
	occupied_cells.clear()
