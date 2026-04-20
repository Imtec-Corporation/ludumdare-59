class_name CoordinatesProvider
extends IRandProvider

const REGIONS: Array[String] = [
    "ANDROMEDA", "ORION", "LYRA", "CYGNUS", "VEGA", "ALTAIR", "DRACO", "NEBULA", "HELIOS", "ARCUS",
    "IONA", "PHOTON", "RIFT", "ZENITH", "AETHER", "NOVA", "PULSAR", "QUASAR", "TITAN", "ECLIPSE"
]

const AXES: Array[String] = ["X", "Y", "Z", "Q", "R"]

var _rng := RandomNumberGenerator.new()
var _coordinates: Array[String] = []

func _init(seed_value: int = 0) -> void:
    if seed_value == 0:
        _rng.randomize()
    else:
        _rng.seed = seed_value
    _coordinates = _build_coordinates()

func provide() -> Variant:
    return String(_coordinates[_rng.randi_range(0, _coordinates.size() - 1)])

func _build_coordinates() -> Array[String]:
    var generated: Array[String] = []
    var index := 0

    for region in REGIONS:
        for major in range(1, 11):
            for minor in range(1, 6):
                if generated.size() == 1000:
                    return generated
                var axis := AXES[index % AXES.size()]
                var vector := 100 + ((index * 47) % 900)
                generated.append("%s-%02d.%d-%s%03d" % [region, major, minor, axis, vector])
                index += 1

    return generated