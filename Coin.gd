extends Area2D
	

func _on_Coin_body_entered(body):
	if body.name == "Char":
		body.ambil_koin()
	var _effectkoin = preload("res://Effect_Coin.tscn")
	var effectkoin = _effectkoin.instance()
	effectkoin.transform = self.transform
	get_tree().current_scene.add_child(effectkoin)
	queue_free()
