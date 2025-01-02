@tool
class_name FigmaGradientTexture2D
extends GradientTexture2D

# Gradient solution from CrazyStewie https://github.com/crazyStewie

@export var figma_transform_array : Array:
	set(value):
		var parsed = value
		if parsed is Array and can_transform_from_array(parsed):
			figma_transform = transform_from_array(parsed)

@export var figma_transform : Transform2D = Transform2D.IDENTITY: set = set_figma_transform
const handle_from_radial : Vector2 = Vector2(0.5, 0.5)
const handle_to_radial : Vector2 = Vector2(1, 0.5)

const handle_from_linear : Vector2 = Transform2D(Vector2(0.0, -1.0), Vector2(1.0, 0.0), Vector2(0.0, 1.0))*Vector2(0.5, 0.0)
const handle_to_linear : Vector2 = Transform2D(Vector2(0.0, -1.0), Vector2(1.0, 0.0), Vector2(0.0, 1.0))*Vector2(0.5, 1.0)

var _handle_update_queued : bool = false

func set_figma_transform(value : Transform2D):
	figma_transform = value
	update_handles()

func update_handles():
	var handle_from := handle_from_radial
	var handle_to := handle_to_radial
	if fill == FILL_LINEAR:
		handle_from = handle_from_linear
		handle_to = handle_to_linear
	var transform : Transform2D = figma_transform.affine_inverse()
	fill_from = transform * handle_from
	fill_to = transform * handle_to
	_handle_update_queued = false
	emit_changed()

func _init() -> void:
	update_handles()

func queue_handle_update():
	if not _handle_update_queued:
		_handle_update_queued = true
		update_handles.call_deferred()

func _set(property: StringName, value: Variant) -> bool:
	if property == &"fill":
		queue_handle_update()
	return false

static func can_transform_from_array(arr : Array) -> bool:
	return arr.size() == 2 and \
		arr[0] is Array and arr[0].size() == 3 and \
		arr[1] is Array and arr[1].size() == 3

static func transform_from_array(arr : Array) -> Transform2D:
	var result := Transform2D.IDENTITY
	if can_transform_from_array(arr):
		result.x.x = arr[0][0]
		result.x.y = arr[1][0]
		result.y.x = arr[0][1]
		result.y.y = arr[1][1]
		result.origin.x = arr[0][2]
		result.origin.y = arr[1][2]
	return result
