shader_type canvas_item;

uniform sampler2D tile: filter_nearest, repeat_enable;

uniform vec2 tiles;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec2 rotate(vec2 uv, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return mat2(vec2(c, -s), vec2(s, c)) * uv;
}

void fragment() {
	vec2 uv = rotate(UV + TIME * 0.02 * vec2(0.8, 0.3), 0.) * tiles;
	COLOR = texture(tile, uv);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
