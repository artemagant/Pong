extends HSlider

@export var bus_name: String = "Master"
var bus_index: int

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	
	# Загружаем сохранённое значение или используем значение по умолчанию
	value = load_volume_setting()
	
	# Применяем громкость
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	
	value_changed.connect(_on_value_changed)

func load_volume_setting() -> float:
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
	if err == OK:
		return config.get_value("audio", bus_name, 1.0)  # 1.0 - значение по умолчанию
	else:
		return 1.0  # Если файла нет, возвращаем 100%

func _on_value_changed(val: float):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(val))
	save_volume_setting(val)

func save_volume_setting(val: float):
	var config = ConfigFile.new()
	config.load("user://settings.cfg")
	config.set_value("audio", bus_name, val)
	config.save("user://settings.cfg")
