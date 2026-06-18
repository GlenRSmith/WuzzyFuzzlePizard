shader_type canvas_item;

uniform float fuzz_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec3 gray = vec3(0.5);
	COLOR.rgb = mix(COLOR.rgb, gray, fuzz_amount);
}
