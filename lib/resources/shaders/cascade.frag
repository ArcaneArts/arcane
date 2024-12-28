#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2 uSize;
uniform float uThick;
uniform float uRepeats;
uniform float uScale; 
uniform float uShimmer;
uniform vec3 uColor;
uniform float uPower;

out vec4 fragColor;

vec3 palette( float t ) {
    vec3 a = uColor;
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263,0.416,0.557);

    return a + b*uShimmer*cos((1/uScale)*6.28318*(c*t+d) );
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = (fragCoord * 2.0 - uSize.xy) / uSize.y*uScale;
    vec2 uv0 = uv;
    vec4 finalColor = vec4(0.0);

    for (float i = 0.0; i < 128.; i++) {
        if(i < 0) break;
        if(i > uRepeats) break;
        
        uv = fract(uv * 1.5 * uThick) - 0.5;

        float d = length(uv) * exp(-length(uv0));

        vec3 col = palette(length(uv0) + i*.4 + uTime*.4);

        d = sin(d*8. + uTime)/8.;
        d = abs(d);

        d = pow(0.01 / d, 1.2);

        finalColor += vec4(col * d, d);
    }
    
    float al = pow(1.0 - length(fragCoord.xy - uSize/2.0) / (uSize.y/2.0), uPower);
    fragColor = vec4((finalColor.rgb/finalColor.a) * al, al); 
}