extends EditorInspectorPlugin

var base_property_list := []
var visual_script_node : VisualScriptNode

var stringify_propertys := false

func can_handle(object:Object):
	if not object is VisualScriptNode:
		return false
	if not "base_type" in object:
		return false
	if not "base_script" in object:
		return false
	if not "property" in object:
		return false
	return true

func parse_end():
	var menu_button := MenuButton.new()
	menu_button.get_popup().connect("index_pressed", self, "on_index_pressed", [menu_button])
	menu_button.text = "select base property"
	menu_button.get_popup().allow_search = true
	add_custom_control(menu_button)
	
	for prop in base_property_list:
		menu_button.get_popup().add_item(prop)
	

func parse_begin(object):
	base_property_list = []
	visual_script_node = object
	
	if visual_script_node.base_type:
		var prop_list = ClassDB.class_get_property_list(visual_script_node.base_type, false)
		for prop in prop_list:
			base_property_list.append(prop.name)
	
	if visual_script_node.base_script:
		var script : GDScript = load(visual_script_node.base_script)
		var class_ = script.new().get_class()
		
		var prop_list = script.get_script_property_list()
		prop_list += ClassDB.class_get_property_list(class_, false)
		for prop in prop_list:
			base_property_list.append(prop.name)
	

func on_index_pressed(idx:int, menu_button):
	visual_script_node.property = menu_button.get_popup().get_item_text(idx)
