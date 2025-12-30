shader_type canvas_item;

uniform vec4 point_color : source_color = vec4(0,0,0,1);
uniform float point_radius = 1.0;
uniform vec2 grid_cell_size = vec2(16,16);
//uniform vec2 rect_size = vec2(1);

float sdGridPoints(vec2 p, vec2 d) {
	p *= d;
	p = fract(p-0.5)-0.5;
	p /= d;
	
	return length(p);
}

varying vec2 model_pos;
void vertex() {
	model_pos = VERTEX;
}

void fragment() {
	
	float d = sdGridPoints(model_pos, 1.0 / grid_cell_size);
	
	d -= point_radius;
	
	d = clamp(d, 0.0, 1.0);
	
	COLOR = mix(point_color, COLOR, d);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
