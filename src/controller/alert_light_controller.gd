class_name AlertLightController
extends OmniLight3D

func _ready() -> void:
    self.hide()
    AttackEvent.register(self._on_attack_event)

func _on_attack_event(attack: bool) -> void:
    if attack:
        self.show()
    else:
        self.hide()