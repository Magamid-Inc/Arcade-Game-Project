class_name  CustomOptionButton
extends OptionButton

@export var focus_border_color : Color = Color("0a3e67")
@export var bg_check_color: Color = Color("06e0ef")
@export var bg_uncheck_color: Color = Color("010522")
@export var auto_clear_focus : bool = true
@export var popup_menu_font_size := 15
@export var popup_menu_font : FontFile = get_theme_font("font").duplicate()
@export var custom_check_marker: Texture2D
@export var border_width := 4
@export var border_radius := 8

var popup = Popup


func _ready():
	setup_focus_style()
	setup_normal_style()
	popup = get_popup()
	popup.popup_hide.connect(_on_popup_hide)
	setup_popup_style()


func setup_focus_style():
	var focus_style = StyleBoxFlat.new()
	focus_style.bg_color = get_theme_stylebox("normal").bg_color
	focus_style.border_color = focus_border_color
	
	focus_style.border_width_left = border_width
	focus_style.border_width_top = border_width
	focus_style.border_width_right = border_width
	focus_style.corner_radius_top_left = border_radius
	focus_style.corner_radius_top_right = border_radius
	
	add_theme_stylebox_override("focus", focus_style)


func setup_normal_style():
	var normal_style = StyleBoxFlat.new()
	normal_style.bg_color = get_theme_stylebox("normal").bg_color
	normal_style.border_color = focus_border_color
	normal_style.set_corner_radius_all(border_radius)
	normal_style.set_border_width_all(border_width)
	
	add_theme_stylebox_override("normal", normal_style)
	add_theme_stylebox_override("hover", normal_style)
	add_theme_stylebox_override("hover_pressed", normal_style)


func setup_popup_style():
	var style = StyleBoxFlat.new()
	var theme_button = Theme.new()
	
	style.bg_color = Color("010522")
	style.corner_radius_bottom_left = border_radius
	style.corner_radius_bottom_right = border_radius
	style.border_color = Color("0A3E67")
	style.border_width_bottom = border_width
	style.border_width_left = border_width
	style.border_width_right = border_width
	
	theme_button.set_constant("h_separation", "PopupMenu", 10)
	theme_button.set_constant("v_separation", "PopupMenu", 6)
	theme_button.set_constant("outline_size", "PopupMenu", 0)
	theme_button.set_font("font", "PopupMenu", popup_menu_font)
	theme_button.set_font_size("font_size", "PopupMenu", popup_menu_font_size)
	theme_button.set_color("font_color", "PopupMenu", Color("06E0EF"))
	
	var hover_style = style.duplicate()
	hover_style.set_border_width_all(0)
	hover_style.set_corner_radius_all(0)
	hover_style.bg_color = Color.TRANSPARENT
	
	var pressed_style = hover_style.duplicate()
	pressed_style.bg_color = Color.TRANSPARENT

	theme_button.set_stylebox("panel", "PopupMenu", style)
	theme_button.set_stylebox("hover", "PopupMenu", hover_style)
	theme_button.set_stylebox("pressed", "PopupMenu", pressed_style)
	
	popup.theme = theme_button


func _on_popup_hide():
	if auto_clear_focus:
		await get_tree().process_frame
		release_focus()
