//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
uniform vec4 uColour;

void main()
{
    vec4 texColour = texture2D( gm_BaseTexture, v_vTexcoord );
	gl_FragColor = vec4( uColour.rgb, texColour.a );
}
