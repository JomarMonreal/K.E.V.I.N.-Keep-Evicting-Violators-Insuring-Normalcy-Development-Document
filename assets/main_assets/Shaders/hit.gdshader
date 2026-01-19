shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0);
uniform float flash_modifier : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec2 center = vec2(0.5, 0.5);
	float d = length(UV - center);
	vec4 color_gradient = vec4(d * flash_color.rgb, flash_modifier);
	
	vec4 color = texture(TEXTURE, UV);
	
	color_gradient.rgb = mix(color_gradient.rgb, flash_color.rgb, flash_modifier);
	color.rgb = mix(color.rgb, color_gradient.rgb, flash_modifier);
	COLOR = color;
}