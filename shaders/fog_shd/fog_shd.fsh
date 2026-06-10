//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	// vec4 values =   (r,	g,	b,	 alpha);
	gl_FragColor = vec4(0.07, 0.11, 0.21, gl_FragColor.a);
}
