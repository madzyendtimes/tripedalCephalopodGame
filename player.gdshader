shader_type canvas_item;

uniform float rate=2.0;
uniform bool doblink=false;
uniform bool lowgraphic=false;

void vertex() {
	//float pi=3.141592563589793;
	//VERTEX *= 0.75 + (sin(fract(TIME*rate)*pi *1.0)+1.0)/4.0;
}

void fragment() {
	if (doblink){
	float pi=3.141592563589793;
	COLOR.b*= 0.75 + (sin(fract(TIME*rate)*pi *1.0)+1.0)/2.0;
	COLOR.r*= 0.75 + (sin(fract(TIME*rate)*pi *1.0)+1.0)/4.0;
	COLOR.g*= 0.05 + (sin(fract(TIME*rate)*pi *1.0)+1.0)/3.0;
	}
	if (lowgraphic!=false){
		vec2 grid_uv=round(UV*float(16.0))/float(16.0);
		vec4 txtr=texture(TEXTURE, grid_uv);
		COLOR=txtr;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
