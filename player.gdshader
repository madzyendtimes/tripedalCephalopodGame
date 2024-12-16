shader_type canvas_item;

 uniform float rate=0.0;

void vertex() {
	float pi=3.141592563589793;
	VERTEX *= 1.0 + (sin(fract(TIME*rate)*pi *1.0)+1.0)/4.0;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
