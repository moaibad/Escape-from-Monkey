extends Camera


# Variabel getaran kamera
var shake_duration = 0.3 # Durasi getaran dalam detik
var shake_amplitude = Vector3(0.1, 0.1, 0.1) # Amplitudo getaran dalam satuan koordinat

# Variabel internal untuk getaran kamera
var shake_timer = 0
var original_translation = Vector3()

func _ready():
	# Menyimpan posisi asli dari node Camera3D
	original_translation = translation

func _process(delta):
	# Mengurangi timer getaran
	if shake_timer > 0:
		shake_timer -= delta
		if shake_timer <= 0:
			# Menghentikan getaran dan mengatur posisi node Camera3D ke posisi asli
			translation = original_translation
		else:
			# Menghitung offset getaran berdasarkan amplitudo dan timer
			var shake_offset = Vector3(rand_range(-shake_amplitude.x, shake_amplitude.x),
									   rand_range(-shake_amplitude.y, shake_amplitude.y),
									   rand_range(-shake_amplitude.z, shake_amplitude.z))
			# Mengatur posisi node Camera3D berdasarkan posisi asli ditambah offset getaran
			translation = original_translation + shake_offset

# Memulai getaran kamera
func start_camera_shake():
	shake_timer = shake_duration
