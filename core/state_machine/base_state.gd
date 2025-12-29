class_name BaseState
extends Node


@export var animation_name : String = ""


func enter():
	pass


func exit():
	pass


func input(_event: InputEvent) -> BaseState:
	return null


func process(_delta: float) -> BaseState:
	return null


func physics_process(_delta: float) -> BaseState:
	return null
