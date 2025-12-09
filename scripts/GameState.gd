extends Node

@onready var potion: Item = preload("res://Items/potion.tres")
@onready var shield: Item = preload("res://Items/shield.tres")
@onready var heal_kit: Item = preload("res://Items/heal_kit.tres")
@onready var heart: Item = preload("res://Items/heart.tres")
@onready var boost: Item = preload("res://Items/boost.tres")

var player_health: int = 100
var max_health: int = 100

var money: int = 10
var itemscounts = {}

func _ready():
	itemscounts = {
		"potion": 0,
		"shield": 0,
		"heal_kit": 0,
		"heart": 0,
		"boost": 0
	}
