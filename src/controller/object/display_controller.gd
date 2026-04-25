class_name DisplayController
extends Control

@export var line_width: float = 1.0
@export var speed: float = 1.0
## Station trace (the “scope” look).
@export var station_line_color: Color = Color(0.15, 1.0, 0.0, 1.0)
## Satellite trace (plain / telemetry look).
@export var satellite_line_color: Color = Color(0.12, 0.57, 0.562, 1.0)
@export var satellite_line_width: float = 0.9
## Vertical separation between the two traces (as a fraction of control height).
@export var trace_split: float = 0.22
## How many horizontal cycles are shown when frequency == ref_frequency_hz.
@export var cycles_at_ref_frequency: float = 8.0
## Frequency value that maps to cycles_at_ref_frequency.
## NOTE: Your UI slider currently tops out at 10.0Hz in `scenes/main.tscn`, so default this to 10
## for readable frequency changes. If you later change the slider range, update this too.
@export var ref_frequency_hz: float = 10.0
## Scroll speed in Hz at ref_frequency_hz (wave moves left as time increases).
@export var scroll_hz_at_ref_frequency: float = 1.0
## +1 / -1 flips perceived scroll direction on screen.
@export var scroll_direction: float = -1.0
## Extra cycles at low frequencies so the trace doesn't look "almost flat" near 0Hz.
@export var min_cycles_on_screen: float = 1.25
## Blend between linear frequency mapping (1.0) and sqrt mapping (0.0) for nicer low-end detail.
@export var cycle_curve: float = 0.35
@export var draw_grid: bool = true
@export var grid_color: Color = Color(0.0, 0.35, 0.0, 0.22)
@export var grid_step_px: float = 24.0
@export var station_phosphor_trail: bool = true
@export var trail_color: Color = Color(0.0, 1.0, 0.0, 0.18)
@export var trail_width_scale: float = 2.25

var time: float
var station_frequency_hz: float = 5.0
var station_amplitude: float = 2.0
var satellite_frequency_hz: float = 5.0
var satellite_amplitude: float = 2.0
var ampPct: float = 0.8
var gameStarted: bool = false

func _ready() -> void:
	time = 0.0
	GameStartEvent.register(self._on_game_start)
	GameOverEvent.register(self._on_game_over)

func _process(delta: float) -> void:
	if not self.gameStarted:
		return

	time += delta * speed
	queue_redraw()

func _on_game_start() -> void:
	self.gameStarted = true

func _on_game_over() -> void:
	self.gameStarted = false
	GameOverEvent.unregister(self._on_game_over)
	GameStartEvent.unregister(self._on_game_start)

func _draw() -> void:
	var w = size.x
	var h = size.y
	if w <= 1.0 or h <= 1.0:
		return

	var middle = h / 2.0
	var split_px: float = clampf(trace_split, 0.05, 0.45) * h
	var station_y: float = middle + split_px * 0.5
	var satellite_y: float = middle - split_px * 0.5

	if draw_grid:
		_draw_grid(Vector2(w, h), middle)

	var steps: int = clampi(int(w), 2, 4000)

	var station_points := _build_trace_points(
		steps, w, station_y, station_frequency_hz, station_amplitude
	)
	var satellite_points := _build_trace_points(
		steps, w, satellite_y, satellite_frequency_hz, satellite_amplitude
	)

	if satellite_points.size() > 1:
		draw_polyline(satellite_points, satellite_line_color, satellite_line_width, true)

	if station_points.size() > 1:
		if station_phosphor_trail:
			draw_polyline(station_points, trail_color, line_width * trail_width_scale, true)
		draw_polyline(station_points, station_line_color, line_width, true)


func update_signals(station_signal: SatSignal, satellite_signal: SatSignal) -> void:
	station_frequency_hz = station_signal.frequency
	station_amplitude = station_signal.amplitude
	satellite_frequency_hz = satellite_signal.frequency
	satellite_amplitude = satellite_signal.amplitude
	
	var deltaFreq: float = abs(station_frequency_hz - satellite_frequency_hz)
	var deltaAmp: float = abs(station_amplitude - satellite_amplitude)
	
	var delta: float = sqrt(pow(deltaFreq, 2) + pow(deltaAmp, 2))
	station_line_color.r = delta
	station_line_color.g = 1 / delta


func _build_trace_points(
	steps: int,
	w: float,
	baseline_y: float,
	frequency_hz: float,
	amplitude_value: float
) -> PackedVector2Array:
	var points: PackedVector2Array = PackedVector2Array()

	var half_h: float = size.y / 2.0
	var max_amplitude_px: float = half_h * ampPct
	var amp_norm: float = clampf(amplitude_value / ref_frequency_hz, 0.0, 1.0)
	var amp_px: float = max_amplitude_px * amp_norm

	var freq_hz: float = maxf(frequency_hz, 0.000001)
	var freq_norm: float = clampf(freq_hz / ref_frequency_hz, 0.0, 1.0)
	var freq_mapped: float = lerpf(freq_norm, sqrt(freq_norm), clampf(cycle_curve, 0.0, 1.0))
	var cycles_on_screen: float = maxf(min_cycles_on_screen, freq_mapped * cycles_at_ref_frequency)
	var scroll_hz: float = freq_mapped * scroll_hz_at_ref_frequency

	for i in range(steps + 1):
		var x: float = (w / float(steps)) * float(i)
		var progression: float = float(i) / float(steps)
		var spatial_phase: float = TAU * cycles_on_screen * progression
		var scroll_phase: float = TAU * scroll_hz * time * scroll_direction
		# Traveling wave: sin(kx + ωt) with sign controlled by scroll_direction.
		var y: float = baseline_y + sin(spatial_phase + scroll_phase) * amp_px
		points.push_back(Vector2(x, y))

	return points


func _draw_grid(size_px: Vector2, middle_y: float) -> void:
	var step: float = maxf(6.0, grid_step_px)
	var x: float = 0.0
	while x <= size_px.x:
		draw_line(Vector2(x, 0.0), Vector2(x, size_px.y), grid_color, 1.0, true)
		x += step

	var y: float = fmod(middle_y, step)
	while y <= size_px.y:
		draw_line(Vector2(0.0, y), Vector2(size_px.x, y), grid_color, 1.0, true)
		y += step

	draw_line(
		Vector2(0.0, middle_y),
		Vector2(size_px.x, middle_y),
		Color(station_line_color.r, station_line_color.g, station_line_color.b, 0.28),
		1.0,
		true
	)
