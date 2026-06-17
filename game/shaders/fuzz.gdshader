shader_type canvas_item;

uniform float fuzz_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	vec3 gray = vec3(0.5);
	COLOR = vec4(mix(base.rgb, gray, fuzz_amount), base.a);
}
