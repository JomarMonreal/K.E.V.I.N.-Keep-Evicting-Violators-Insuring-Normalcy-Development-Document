class_name PlayerBaseState
extends BaseState

var parent : Player # change to different entity type as needed

func enter():
	parent.animations.play(animation_name)
