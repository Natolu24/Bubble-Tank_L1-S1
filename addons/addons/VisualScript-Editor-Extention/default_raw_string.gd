extends Node

var editor_plugin : EditorPlugin
var script_editor : ScriptEditor

var connected_nodes := []
var multiline_buttons := []
var multiline_selected := false

func _enter_tree():
	if editor_plugin:
		script_editor = editor_plugin.get_editor_interface().get_script_editor()
		script_editor.connect("editor_script_changed", self, "_on_editor_script_changed", [script_editor])


func _on_editor_script_changed(_script, script_editor):
	_connect_vs_CustomPropertyEditor(script_editor)


func _connect_vs_CustomPropertyEditor(node):
	if node.name.begins_with("VisualScriptEditor"):
		_handle_custom_property_editor(node)
		_handle_graph_menu(node)
		return
	for child in node.get_children():
		var t = _connect_vs_CustomPropertyEditor(child)


func _handle_custom_property_editor(visual_script_editor):
	var custom_property_editor = visual_script_editor.get_node("CustomPropertyEditor")
	if not custom_property_editor.is_connected("visibility_changed", self, "_on_cpe_visi_changed"):
		custom_property_editor.connect("visibility_changed", self, "_on_cpe_visi_changed", [custom_property_editor])
		connected_nodes.append(custom_property_editor)


func _handle_graph_menu(visual_script_editor):
	var graph_edit_filter = visual_script_editor.get_node("GraphEdit").get_node("GraphEditFilter")
	var graph_menu = graph_edit_filter.get_node("HBoxContainer")
	var add_button := true
	for child in graph_menu.get_children():
		if multiline_buttons.has(child):
			add_button = false
	if add_button:
		var select_multiline_button = Button.new()
		select_multiline_button.toggle_mode = true
		select_multiline_button.icon = load("res://addons/VisualScript-Editor-Extention/icons/icon_multi_edit.svg")
		select_multiline_button.pressed = multiline_selected
		graph_menu.add_child(select_multiline_button)
		multiline_buttons.append(select_multiline_button)
		select_multiline_button.connect("toggled", self, "_on_multiline_toggled",[select_multiline_button])

func _on_multiline_toggled(value, button):
	for _button in multiline_buttons:
		if is_instance_valid(_button):
			if _button != button and _button.pressed != value:
				_button.pressed = value
			if multiline_selected != value:
				multiline_selected = value

func _on_cpe_visi_changed(obj):
	if multiline_selected:
		var l = obj.get_node("LineEdit")
		l.visible = false
		var b = obj.get_node("Button")
		b.visible = false
		var t = obj.get_node("TextEdit")
		t.visible = true
		t.rect_size.y = 100
		t.rect_size.x = 400
		if t.text == "":
			t.text = l.text


func _exit_tree():
	for node in connected_nodes:
		if is_instance_valid(node):
			if node.is_connected("visibility_changed", self, "_on_cpe_visi_changed"):
				node.disconnect("visibility_changed", self, "_on_cpe_visi_changed")
	for select_multiline_button in multiline_buttons: 
		select_multiline_button.get_parent().remove_child(select_multiline_button)

#func _unhandled_key_input(event):
#	if event is InputEventKey:
#		if event.pressed and event.scancode == KEY_E and event.control == true:
#			print(OS.get_scancode_string(event.get_scancode_with_modifiers()))
#	pass
