extends Node2D

@onready var timer = $Timer

enum phase { PLANNING, FIGHTING }

var turn_phase = phase.PLANNING

signal turn_changed(phase)

func _ready():
	#run_phase()
	timer.timeout.connect(_timeout)

func run_phase():
	timer.start(3)

func _timeout():
	if turn_phase == phase.PLANNING:
		print("planning acabou")
		turn_phase = phase.FIGHTING
	
	elif turn_phase == phase.FIGHTING:
		print("fighting acabou")
		turn_phase = phase.PLANNING
	turn_changed.emit(turn_phase)
	timer.start(3)
