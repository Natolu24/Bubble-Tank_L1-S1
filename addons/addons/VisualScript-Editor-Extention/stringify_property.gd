extends EditorInspectorPlugin

var visual_script_node : VisualScriptNode

var stringify_propertys := false
var stringable_type := [TYPE_STRING, TYPE_NODE_PATH]

func can_handle(object):
	return object is VisualScriptNode

func parse_begin(object):
	var button := Button.new()
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.connect("button_down", self, "_on_button_down",[object])
	if stringify_propertys:
		button.text = "normalize_propertys"
	else:
		button.text = "stringify_propertys"
	add_custom_control(button)

func parse_property(object, type, path, hint, hint_text, usage):
	if stringify_propertys and stringable_type.has(type) and not hint == PROPERTY_HINT_NONE:
		var hbox := HBoxContainer.new()
		var label := Label.new()
		var line_edit := LineEdit.new()
		var value = object.get(path)
		hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		line_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.text = path
		line_edit.text = value
		line_edit.connect("text_entered", self, "_on_text_changed", [object, path])
		hbox.add_child(label)
		hbox.add_child(line_edit)
		add_custom_control(hbox)
		return true
	

func _on_button_down(object):
	stringify_propertys = not stringify_propertys
	object.property_list_changed_notify()
	
func _on_text_changed(new_value, object, path):
	object.set(path, new_value)
	_on_button_down(object)
