#If UID references break, run this script (right click and choose run) to fix it.

@tool
extends EditorScript

var files: Array[String]

func _run() -> void:
	files = []
	
	add_files("res://")
	
	for file in files:
		print(file)
		var res = load(file)
		ResourceSaver.save(res)

func add_files(dir: String):
	for file in DirAccess.get_files_at(dir):
		if file.get_extension() == "tscn" or file.get_extension() == "tres":
			files.append(dir.path_join(file))
	
	for dr in DirAccess.get_directories_at(dir):
		add_files(dir.path_join(dr))
