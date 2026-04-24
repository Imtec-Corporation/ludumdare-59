class_name SigFreqProvider
extends IRandProvider

func provide() -> Variant:
    return float(randf_range(0.0, 9.5))