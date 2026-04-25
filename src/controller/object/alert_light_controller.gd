class_name AlertLightController
extends OmniLight3D

func _ready() -> void:
    self.hide()
    AttackEvent.register(self._on_attack_event)
    GameOverEvent.register(self._on_game_over)

func _on_attack_event(attack: bool) -> void:
    if attack:
        self.show()
    else:
        self.hide()

func _on_game_over() -> void:
    self.hide()
    AttackEvent.unregister(self._on_attack_event)