class_name SigAmpProvider
extends IRandProvider

func provide() -> Variant:
    return float(randf_range(0.0, 10.0))