extends Node

const SAVE_PATH := "user://leaderboard.save"
const MAX_ENTRIES := 5

var entries: Array = []
var last_name: String = ""

func _ready() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if f == null:
		return
	var data = f.get_var()
	f.close()
	if typeof(data) == TYPE_DICTIONARY:
		entries = data.get("entries", [])
		last_name = data.get("last_name", "")

func add_score(player_name: String, score: int) -> void:
	player_name = player_name.strip_edges()
	if player_name.is_empty():
		player_name = "AAA"
	last_name = player_name

	# If this name already has an entry, make it a new high score
	var existing : Variant = _find_entry(player_name)
	if existing != null:
		if score > existing["score"]:
			existing["score"] = score
	else:
		entries.append({"name": player_name, "score": score})
	# sorts the array by score
	entries.sort_custom(func(a, b): return a["score"] > b["score"])
	if entries.size() > MAX_ENTRIES:
		entries = entries.slice(0, MAX_ENTRIES)
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f == null:
		return
	f.store_var({"entries": entries, "last_name": last_name})
	f.close()

func _find_entry(player_name: String) -> Variant:
	var key := player_name.to_lower()
	for entry in entries:
		if String(entry["name"]).to_lower() == key:
			return entry
	return null
