tool
extends EditorPlugin

var select_base_property := preload("res://addons/VisualScript-Editor-Extention/select_base_property.gd").new()
var stringify_property := preload("res://addons/VisualScript-Editor-Extention/stringify_property.gd").new()
var string_multiline := preload("res://addons/VisualScript-Editor-Extention/default_raw_string.gd").new()

func _enter_tree():
	add_inspector_plugin(select_base_property)
	add_inspector_plugin(stringify_property)
	string_multiline.editor_plugin = self
	add_child(string_multiline)

func _exit_tree():
	remove_inspector_plugin(select_base_property)
	remove_inspector_plugin(stringify_property)
