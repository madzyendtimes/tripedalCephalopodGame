shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform float brightness=1.0;
uniform float contrast=1.0;
uniform float saturation=1.0;

void fragment() {
	/*
	vec4 sprite_color=texture(SCREEN_TEXTURE,SCREEN_UV);
	float alpha=-8.0 *sprite_color.a;
	alpha+=texture(SCREEN_TEXTURE,SCREEN_UV + vec2(0.0,-0.1)).a;
	alpha+=texture(SCREEN_TEXTURE,SCREEN_UV + vec2(0.1,-0.1)).a;
	alpha+=texture(SCREEN_TEXTURE,SCREEN_UV + vec2(-0.1,0.1)).a;
	alpha+=texture(SCREEN_TEXTURE,SCREEN_UV + vec2(-0.1,-0.1)).a;
	vec4 finalC=mix(sprite_color,vec4(1.0,0.0,0.0,1.0),clamp(alpha,0.0,1.0));
	COLOR=vec4(finalC.rgb,clamp(abs(alpha)+sprite_color.a,0.0,1.0));
	*/
	vec3 c=textureLod(SCREEN_TEXTURE,SCREEN_UV,0.0).rbg;
	c.rgb=mix(vec3(0.0),c.rbg,brightness);
	c.rgb = mix(vec3(0.5),c.rgb,contrast);
	c.rgb=mix(vec3(dot(vec3(1.0),c.rgb)*0.333333),c.rgb,saturation);
	COLOR.rgb=c;



	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
