shader_type canvas_item;


void fragment(){
	vec4 col=texture(TEXTURE,UV);

	COLOR=(col * (vec4(0.0,0.1,0.1,0.5)));
 
	
	
}
