shader_type spatial;
render_mode unshaded, cull_back, blend_mix;

uniform vec4 color;
uniform sampler2D albedo_texture: filter_nearest_mipmap;

void fragment() {
	vec4 c = color * texture(albedo_texture, UV);
	ALBEDO = c.rgb;
	ALPHA = c.a;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
