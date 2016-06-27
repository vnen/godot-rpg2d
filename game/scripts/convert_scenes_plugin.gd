
extends SceneTree

var visited = []

func traverse_dir(path):
	if path in visited:
		return
	visited.push_back(path)
	print("Entering dir %s" % path)
	var dir = Directory.new()
	if dir.open(path) != OK:
		return

	dir.list_dir_begin()
	var subpath = "start"

	while subpath != "":
		subpath = dir.get_next()
		if subpath == "." or subpath == "..":
			continue
		print ("subpath %s" % subpath)
		if dir.current_is_dir():
			traverse_dir(path.plus_file(subpath))
		elif subpath.extension() == "xscn":
			convert_scene(path.plus_file(subpath))

func convert_scene(path):
	print("Converting file %s to %s" % [path,path.basename() + ".tscn"])
	var packedScene = ResourceLoader.load(path, "PackedScene")
	ResourceSaver.save(path.basename() + ".tscn", packedScene)

func _init():
	traverse_dir("res://")
	quit()
