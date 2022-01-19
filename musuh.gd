extends KinematicBody2D

var gravitasi = 12
var laju = 25
var kecepatan = Vector2.ZERO
export var arah = 1

var apakah_terluka = false

onready var pivot = $Pivot
onready var raycast = $Pivot/RayCast2D

export var stamina = 5

func _ready():
	pass

func _physics_process(_delta):
	kecepatan.y += gravitasi
	
	if is_on_wall() or not raycast.is_colliding():
		arah = arah * -1
		pivot.scale.x = pivot.scale.x * -1
	
	kecepatan.x = laju * arah
	
	if not apakah_terluka:
		kecepatan = move_and_slide(kecepatan, Vector2.UP)
	
	if not apakah_terluka:
		_update_animasi()

func _update_animasi():
	if is_on_floor():
		$AnimatedSprite.play("lari")
	else:
		$AnimatedSprite.play("jatuh")
	$AnimatedSprite.flip_h = true
	if arah == -1:
		$AnimatedSprite.flip_h = false

func _on_DeteksiSamping_body_entered(body):
	if body.name == 'Char':
		body.terluka()


func _on_DeteksiAtas_body_entered(body):
	if body.name == "Char" and not apakah_terluka and stamina > 0:
		body.kecepatan.y = -100
	terluka()

func terluka():
	stamina -= 1 
	print("terluka")
	apakah_terluka = true
	$AnimatedSprite.play("terluka")
	yield(get_tree().create_timer(1), "timeout")
	if stamina <= 0:
		mati()
	else:
		apakah_terluka = false

func mati():
	$AnimatedSprite.play("mati")
	set_collision_layer_bit(2, false)
	set_collision_mask_bit(0, false)
	$mati.play()
	$DeteksiSamping.set_collision_layer_bit(2, false)
	$DeteksiSamping.set_collision_mask_bit(0, false)
	$DeteksiAtas.set_collision_layer_bit(2, false)
	$DeteksiAtas.set_collision_mask_bit(0, false)
	yield(get_tree().create_timer(1), "timeout")
	$AnimationPlayer.play("menghilang")
	
func hapus():
	print("hapus")
	queue_free()
