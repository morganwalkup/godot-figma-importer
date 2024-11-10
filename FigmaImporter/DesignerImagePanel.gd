@tool
class_name DesignerImagePanel
extends Panel

var script_dir:String = get_script().get_path().get_base_dir()
var frameShaderPath:String = script_dir + "/shader/vertextApplyShader.gdshader"
var is_scene_ready:bool = false
var the_name:String
var the_id:String
var isInAutoContainer:bool = false
var disable_size_update:bool = false
@export_category("Frame Controls")
## This differs from the default Godot anchors in that changing the anchors does not change the position or size of the frame/node.
@export_enum("Left","Center","Right","Left and Right") var horizontalAnchor: String = "Left" : set = set_anchor_horizontal
## This differs from the default Godot anchors in that changing the anchors does not change the position or size of the frame/node.
@export_enum("Top","Center","Bottom","Top and Bottom") var verticalAnchor: String = "Top" : set = set_anchor_vertical
@export_group("Size")
## Determines how the node will scale when in an auto layout.
@export_enum("FIXED", "FILL", "HUG") var widthSizeMode: String = "FIXED" : set = set_wSizing
## Determines how the node will scale when in an auto layout.
@export_enum("FIXED", "FILL", "HUG") var heightSizeMode: String = "FIXED" : set = set_hSizing
##If you want to manually control dimensions in auto-layouts, you do so by setting minimum size.
@export var minSize:Vector2 = Vector2(1.0,1.0) : set = set_minimum_size
@export var maxSize:Vector2 = Vector2(10000.0,10000.0) : 
	set(value):
		maxSize = value
@export_range(-180.0, 180.0, 0.1) var frameRotation:float : 
	set(value): 
		if is_scene_ready:
			self.set_rotation_degrees(value)
			frameRotation = value
## Centers the rotation/transform pivot point. This will be maintain even when changing the node size.
@export var center_rotation:bool = false : set = center_the_rotation
## Note that in Godot, clipping will not rotate with the frame/node.
@export var clipFrameContents:bool = false : set = set_clipping
@export_group("Style")
## If you find changing one node is changing others, click this to break the style link. This will duplicate the Stylebox and shader to break it free of others.
@export var breakStyleLinks:bool : set = break_the_style_link
@export_subgroup("Fill Color")
@export var fill_color:Color = Color(0.6,0.6,0.6,1.0): set = set_background_fill
## When placing an image with transparency, this option determines if the fill color appears behind it.
@export var use_solid_fill:bool : set = set_use_solid
@export var fill_gradient:GradientTexture2D: set = set_background_gradient
##  If there is a fill image, you can set whether it appears in front of or behind that image.
@export var gradient_behind_image:bool : set = set_gradientBehindImage
@export_subgroup("Fill Image")
@export var fill_texture: Texture : set = set_background_image
##Expands the image when using edge anti-aliasing.
@export_range(0.001, 1.0, 0.001) var edge_fill: float = 0.001 : set = update_edge_tolerance
## Godot will repeat the edge of pixels if there is not transparency and image does not fill the frame.
@export_enum("Fill", "Fit", "Stretch", "Keep Size") var textureSizeMode: String = "Fill" : set = set_image_sizing
@export var flip_x:bool : set = set_image_flipx
@export var flip_y:bool : set = set_image_flipy
@export_range(0.0, 6.0, 0.01) var zoom: float = 1.0 : set = update_fill_zoom
@export var tile_texture:bool : set = update_text_tile
@export var size_stretch:Vector2 = Vector2(1.0,1.0) : set = update_size_stretch
@export var position_offset:Vector2 = Vector2(0.0,0.0) : set = update_position_offset
@export var tint_color:Color = Color(1.0,1.0,1.0,1.0) : set = set_tint_color
@export_subgroup("Border Stroke")
@export var border_line_weight_all:int : set = set_borders
## An array of 4 border weights. Top, Right, Bottom, Left.
@export var border_weights:Array : set = add_border
@export var border_color:Color : set = add_border_color
## Smooths the border line. This can create color artifacts if using fill textures. See Edge Fill.
@export var anti_alias_border:bool = false : set = set_border_alias
@export_subgroup("Corners")
@export var corner_radius_all:int : set = change_all_corners
## An array of 4 corner radius. Top, Right, Bottom, Left.
@export var corner_radius:Array : set = round_the_corners
@export_subgroup("Shadow")
@export var shadow_color:Color = Color(0.0,0.0,0.0,0.5): set = update_shadow_color
@export var shadow_size:int : set = update_shadow_size
@export var shadow_offest:Vector2 = Vector2(0.0,0.0) : set = update_shadow_offest

var styleBox: StyleBoxFlat

func _ready():
	self.resized.connect(_on_control_resized)
	if !has_theme_stylebox_override("panel"):
		var newstylebox = StyleBoxFlat.new()
		add_theme_stylebox_override("panel", newstylebox)
		styleBox =get_theme_stylebox("panel")
	else:
		styleBox = get_theme_stylebox("panel").duplicate()
	#if Engine.is_editor_hint():
	is_scene_ready = true
		
func _validate_property(property : Dictionary) -> void:
	if property.name == "textureSizeMode" and fill_texture == null:
		property.usage |= PROPERTY_USAGE_READ_ONLY
	if property.name == "flip_x" and fill_texture == null:
		property.usage |= PROPERTY_USAGE_READ_ONLY
	if property.name == "flip_y" and fill_texture == null:
		property.usage |= PROPERTY_USAGE_READ_ONLY
	if property.name == "zoom" and fill_texture == null:
		property.usage |= PROPERTY_USAGE_READ_ONLY
	if property.name == "tile_texture" and fill_texture == null:
		property.usage |= PROPERTY_USAGE_READ_ONLY
	if property.name == "size_stretch" and fill_texture == null:
		property.usage |= PROPERTY_USAGE_READ_ONLY
	if property.name == "position_offset" and fill_texture == null:
		property.usage |= PROPERTY_USAGE_READ_ONLY
	if property.name == "tint_color" and fill_texture == null:
		property.usage |= PROPERTY_USAGE_READ_ONLY
	if property.name == "gradient_behind_image" and fill_gradient == null:
		property.usage |= PROPERTY_USAGE_READ_ONLY
	if property.name == "edge_fill" and anti_alias_border == false:
		property.usage |= PROPERTY_USAGE_READ_ONLY
	if property.name == "horizontalAnchor" and isInAutoContainer == true:
		property.usage |= PROPERTY_USAGE_READ_ONLY
	if property.name == "verticalAnchor" and isInAutoContainer == true:
		property.usage |= PROPERTY_USAGE_READ_ONLY
	if property.name == "framePosition" and isInAutoContainer == true:
		property.usage |= PROPERTY_USAGE_READ_ONLY
	if property.name == "frameRotation" and isInAutoContainer == true:
		property.usage |= PROPERTY_USAGE_READ_ONLY
	if property.name == "center_rotation" and isInAutoContainer == true:
		property.usage |= PROPERTY_USAGE_READ_ONLY
	if property.name == "frameSize" and isInAutoContainer == true:
		property.usage |= PROPERTY_USAGE_READ_ONLY

func break_the_style_link(theValue):
	UIDesignTools.break_the_style_link(self,frameShaderPath)

func center_the_rotation(theVar):
	center_rotation = theVar
	UIDesignTools.center_the_rotation_s(self, is_scene_ready, center_rotation)

func update_shadow_color(theVar):
	shadow_color = theVar
	if is_scene_ready:
		styleBox.set("shadow_color", shadow_color)
		add_theme_stylebox_override("panel", styleBox)
	
func update_shadow_size(theVar):
	shadow_size = theVar
	if is_scene_ready:
		styleBox.set("shadow_size", shadow_size)
		add_theme_stylebox_override("panel", styleBox)
	
func update_shadow_offest(theVar):
	shadow_offest = theVar
	if is_scene_ready:
		styleBox.set("shadow_offset", shadow_offest)
		add_theme_stylebox_override("panel", styleBox)
	
func set_tint_color(theVar):
	tint_color = theVar
	if fill_texture != null && UIDesignTools.shaderNameMatches(self,frameShaderPath) && is_scene_ready:
		self.material.set_shader_parameter("tint_color", tint_color)
		
func update_position_offset(theVar):
	position_offset = theVar
	if fill_texture != null && UIDesignTools.shaderNameMatches(self,frameShaderPath) && is_scene_ready:
		self.material.set_shader_parameter("offset", position_offset)
		
func update_size_stretch(theVar):
	size_stretch = theVar
	if fill_texture != null && UIDesignTools.shaderNameMatches(self,frameShaderPath) && is_scene_ready:
		self.material.set_shader_parameter("stretch", size_stretch)
		
func update_text_tile(theVar):
	tile_texture = theVar
	if fill_texture != null && UIDesignTools.shaderNameMatches(self,frameShaderPath) && is_scene_ready:
		self.material.set_shader_parameter("tile_texture", tile_texture)

func update_fill_zoom(theVar):
	zoom = theVar
	if fill_texture != null && UIDesignTools.shaderNameMatches(self,frameShaderPath) && is_scene_ready:
		self.material.set_shader_parameter("texture_scale", zoom)
	
func set_image_flipx(theVar):
	flip_x = theVar
	if fill_texture != null && UIDesignTools.shaderNameMatches(self,frameShaderPath) && is_scene_ready:
		self.material.set_shader_parameter("flip_x", flip_x)

func set_image_flipy(theVar):
	flip_y = theVar
	if fill_texture != null && UIDesignTools.shaderNameMatches(self,frameShaderPath) && is_scene_ready:
		self.material.set_shader_parameter("flip_y", flip_y)

func update_edge_tolerance(newTol):
	edge_fill = newTol
	if fill_texture != null && UIDesignTools.shaderNameMatches(self,frameShaderPath) && is_scene_ready:
		self.material.set_shader_parameter("tolerance", newTol)

func set_image_sizing(theSizing):
	textureSizeMode = theSizing
	UIDesignTools.set_image_sizing(self,textureSizeMode,frameShaderPath)

func set_use_solid(theVar):
	use_solid_fill = theVar
	if UIDesignTools.shaderNameMatches(self,frameShaderPath):
		self.material.set_shader_parameter("use_solid", use_solid_fill)
		
func set_gradientBehindImage(theVar):
	gradient_behind_image = theVar
	if UIDesignTools.shaderNameMatches(self,frameShaderPath):
		self.material.set_shader_parameter("gradient_behind", gradient_behind_image)

func set_background_gradient(_theGradient):
	fill_gradient = _theGradient
	UIDesignTools.set_background_gradient(self,is_scene_ready,fill_gradient,frameShaderPath)
	
func set_background_image(_theTexture):
	fill_texture = _theTexture
	UIDesignTools.set_background_image(self,is_scene_ready,fill_texture,frameShaderPath)

func _on_control_resized():
	UIDesignTools.restrictMaxSize(self,maxSize)
	UIDesignTools.centerOnResize(self,center_rotation)
	if UIDesignTools.shaderNameMatches(self,frameShaderPath):
		self.material.set_shader_parameter("node_size", Vector2(self.size))
	
func set_wSizing(_theSize):
	widthSizeMode = _theSize
	UIDesignTools.set_wSizing(self,is_scene_ready,widthSizeMode)
		
func set_hSizing(_theSize):
	heightSizeMode = _theSize
	UIDesignTools.set_hSizing(self,is_scene_ready,heightSizeMode)

func set_max_size(_theSize):
	maxSize = _theSize

func set_minimum_size(_theSize):
	minSize = _theSize
	if is_scene_ready:
		self.custom_minimum_size = minSize

func set_anchor_horizontal(_theAnchorString):
	horizontalAnchor = _theAnchorString
	UIDesignTools.set_anchor_horizontal(self,is_scene_ready,horizontalAnchor)

func set_anchor_vertical(_theAnchorString):
	verticalAnchor = _theAnchorString
	UIDesignTools.set_anchor_vertical(self,is_scene_ready,verticalAnchor)

func set_clipping(_theVar):
	clipFrameContents = _theVar
	self.clip_contents = clipFrameContents

func round_the_corners(_theRound):
	corner_radius = _theRound
	if is_scene_ready:
		if corner_radius != []:
			styleBox.set("corner_radius_top_left", corner_radius[0])
			styleBox.set("corner_radius_top_right", corner_radius[1])
			styleBox.set("corner_radius_bottom_right", corner_radius[2])
			styleBox.set("corner_radius_bottom_left", corner_radius[3])
			add_theme_stylebox_override("panel", styleBox)

func change_all_corners(_theRound):
	corner_radius_all = _theRound
	if is_scene_ready:
		corner_radius = [corner_radius_all,corner_radius_all,corner_radius_all,corner_radius_all]

func set_background_fill(_theFill):
	fill_color = _theFill
	if is_scene_ready:
		if UIDesignTools.shaderNameMatches(self,frameShaderPath):
			styleBox.set("bg_color", Color(0.6,0.6,0.6,1.0))
			self.material.set_shader_parameter("new_bg_color", fill_color)
		else:
			styleBox.set("bg_color", Color(fill_color))
		add_theme_stylebox_override("panel", styleBox)

func add_border(_theBorder):
	border_weights = _theBorder
	if is_scene_ready:
		if border_weights != []:
			styleBox.set("border_width_top", border_weights[0])
			styleBox.set("border_width_right", border_weights[1])
			styleBox.set("border_width_bottom", border_weights[2])
			styleBox.set("border_width_left", border_weights[3])
			add_theme_stylebox_override("panel", styleBox)

func set_border_alias(theVar):
	anti_alias_border = theVar
	if is_scene_ready:
		styleBox.set("anti_aliasing", theVar)
		add_theme_stylebox_override("panel", styleBox)
		if theVar == false:
			edge_fill = 0.001
		notify_property_list_changed()

func set_borders(_borderSize):
	border_line_weight_all = _borderSize
	if is_scene_ready:
		add_border([border_line_weight_all,border_line_weight_all,border_line_weight_all,border_line_weight_all])

func add_border_color(_theBorderColor):
	border_color = _theBorderColor
	if is_scene_ready:
		styleBox.set("border_color", border_color)
		add_theme_stylebox_override("panel", styleBox)
