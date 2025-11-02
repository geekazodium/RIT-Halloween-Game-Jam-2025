shader_type spatial;

uniform sampler2D albedo_texture : source_color, filter_linear;
uniform float reveal_percent : hint_range(0.0, 1.0) = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec2 uv = UV;

    // reveal from bottom to top
    if (uv.y > reveal_percent) {
        discard;
    }

    vec4 tex_color = texture(albedo_texture, uv);
    ALBEDO = tex_color.rgb;
    ALPHA = tex_color.a;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
