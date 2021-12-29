# VisualScript-Editor-Extention

**A series of additions to the VisualScript Editor to provide less friction when ariving from GDScript**

**Extendend select propertys**

By default not all property's are available for selection.
Now when selecting some VisualScriptNodes the button select base property apeares.
This list is autocompleted using the base_type or base_script available.

(see images)

**Stringify Property's**

Propertys in the inspactor are now able to be edited as string.

Example NodePath:
A nodePath property has a default selection popup that returns a path relative to the scene root.
So if the script is not attached to the scene root this gives a incorect path.
Now you are able to stringify proberty's en may freely edit the path.

(see images)

**Raw Edit Default as String**

(the vaiable inputs on a node input that is not connected)
VisualScriptNodes default property editor filters the spetial characters in strings. ("/n" is returnd as "//n")
To overcome this limitation there now is a button that provides you with a multiline editor that dous not have this filter.

(see images)
  
