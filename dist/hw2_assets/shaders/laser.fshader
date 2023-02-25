precision mediump float;

varying vec4 v_Position;

/**
 * Macros that define constants used in the fragment shader program. 
 */
#define MIN_DISTANCE 0.00
#define MAX_DISTANCE 0.02
#define MIDLINE 0.0

/**
 *  This function generates the appropriate alpha value for the fragment color
 *  to render a laser that looks like a sin wave. The alpha value depends on 
 *  the distance of the vertex position from the sine waves curve. Positions
 *  closer to the curve of the sin wave should have a higher alpha value.
 *
 *  +------------------------------------------------------+
 *  | 	   __	  __	 __		__	   __	  __		   | 
 *  | 	  /	 \	 /	\	/  \   /  \	  /	 \	 /	\		   |
 *  |   _/	  \_/	 \_/	\_/	   \_/	  \_/	 \_		   |  
 *  | 													   |
 *  +------------------------------------------------------+
 *
 *  @param position - the position from the vertex shader (v_Position)
 *  @return - the alpha value of the fragment color
 */
float sinwave_laser(vec4 position);

/**
 *  This function generates the appropriate alpha value for the fragment shader
 *  to render a laser that is a straight line. The alpha value depends on the
 *  distance of the vertex fragments position from the midline of the lasers
 *  bounding rectangle. 
 *
 *  +------------------------------------------------------+
 *  | 													   |
 *  + -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - + <- this is the midline
 *  |													   |
 *  +------------------------------------------------------+
 */
float linear_laser(vec4 position);

// TODO Need to somehow pass in the color from the laser shader type
void main(){
    // Define color values
    vec4 blueColor = vec4(1.0, 0.0, 0.0, 1.0);
    vec4 purpleColor = vec4(0.5, 0.0, 1.0, 1.0);
    vec4 redColor = vec4(0.0, 0.0, 1.0, 1.0);

    // Calculate the sin wave value
    float sinWaveValue = sinwave_laser(v_Position);

    // Map sinWaveValue to a smooth transition between red and blue/purple
    float transitionValue = smoothstep(0.0, 1.0, sinWaveValue);
    vec4 finalColor = mix(blueColor, redColor, transitionValue);

    // Set the final color as the output
    gl_FragColor = finalColor;
    gl_FragColor.a = sinwave_laser(v_Position);
}


// TODO Get the laser to look like a sinwave
float sinwave_laser(vec4 position) {
    // Calculate the x- and y-coordinates
    float x = position.x * 30.0;
    float y = sin(x) * 0.02 + position.y * 0.02;
    
    // Set the alpha value based on the distance from the sin wave
    float alpha = smoothstep(0.0, 0.02, abs(position.y - y));
    
    // Interpolate between red and purple/blue based on the alpha value
    vec3 red = vec3(1.0, 0.0, 0.0);
    vec3 purple_blue = vec3(0.6, 0.0, 1.0);
    vec3 color = mix(red, purple_blue, alpha);
    
    // Return the final alpha value
    return alpha;
}

float linear_laser(vec4 position) {
	float dist = distance(position.y, MIDLINE);
	return 1.0 - smoothstep(MIN_DISTANCE, MAX_DISTANCE, dist);
}


