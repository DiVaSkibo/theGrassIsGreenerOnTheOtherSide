extends Node

#		CONST
const PATH := "user://SaveResource.tres"
#		VAR
pass

#		FUNC
func load_data() -> SaveResource:
	return ResourceLoader.load(PATH) as SaveResource
func save_data(resource : SaveResource) -> void:
	print(resource.health)
	print(resource.position)
	ResourceSaver.save(resource, PATH)
	var x:SaveResource = ResourceLoader.load(PATH) as SaveResource
	print(x.health)
	print(x.position)
