class_name SatNameProvider
extends IRandProvider

const NAME_PREFIXES: Array[String] = [
    "AETHER", "AURORA", "BLADE", "CELEST", "CINDER", "COSMO", "CYGNUS", "DRACO", "ECHO", "EON",
    "FALCON", "FLARE", "GALAX", "HALCY", "HELIO", "HORIZ", "HYDRA", "IONIS", "JAVEL", "KRAIT",
    "LUMEN", "LYRAN", "MANTA", "NEBUL", "NEXUS", "NOVA", "OBSID", "ONYX", "ORBIT", "PHASE",
    "PHOTN", "PULSAR", "QUANT", "RADIX", "RAVEN", "RIFT", "SOLAR", "SPECT", "TITAN", "VECTOR"
]

const NAME_CORES: Array[String] = [
    "ARC", "AXIS", "BOLT", "CROWN", "DRIFT", "EDGE", "FORGE", "GATE", "HALO", "LANCE",
    "MATRIX", "NOVA", "PRISM", "PULSE", "RAY", "SHARD", "SIGMA", "SPIRE", "STRIKE", "VAULT",
    "VORTEX", "WARD", "WAVE", "WING", "ZENITH"
]

var _rng := RandomNumberGenerator.new()
var _satellite_names: Array[String] = []

func _init(seed_value: int = 0) -> void:
    if seed_value == 0:
        _rng.randomize()
    else:
        _rng.seed = seed_value
    _satellite_names = _build_satellite_names()

func provide() -> Variant:
    return String(_satellite_names[_rng.randi_range(0, _satellite_names.size() - 1)])

func _build_satellite_names() -> Array[String]:
    var generated: Array[String] = []
    var index := 0

    for prefix in NAME_PREFIXES:
        for core in NAME_CORES:
            if generated.size() == 1000:
                return generated
            var serial := 100 + ((index * 37) % 900)
            generated.append("%s%s-%03d" % [prefix, core, serial])
            index += 1

    return generated