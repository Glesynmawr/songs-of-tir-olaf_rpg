//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec2 utexel_size;
uniform vec4 uRGBA;

void main(){
    vec4 end_pixel =  v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	if ( texture2D( gm_BaseTexture, v_vTexcoord ).a <= 0.0) {
		
		float alpha = 0.0;
	    alpha = max(alpha, texture2D( gm_BaseTexture, vec2(v_vTexcoord.x - utexel_size.x , v_vTexcoord.y)).a );
	    alpha = max(alpha, texture2D( gm_BaseTexture, vec2(v_vTexcoord.x + utexel_size.x , v_vTexcoord.y)).a );
	    alpha = max(alpha, texture2D( gm_BaseTexture, vec2(v_vTexcoord.x, v_vTexcoord.y + utexel_size.y)).a );       
	    alpha = max(alpha, texture2D( gm_BaseTexture, vec2(v_vTexcoord.x, v_vTexcoord.y - utexel_size.y)).a ); 
		
		if (alpha != 0.0) {
            end_pixel = vec4(uRGBA);
        }
	}
	
	gl_FragColor = end_pixel;
}