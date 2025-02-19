#include <flutter/runtime_effect.glsl>
precision highp float;

uniform vec2 u_size;

uniform sampler2D u_texture_input;
uniform sampler2D u_texture_frost;
uniform sampler2D u_texture_frost1;
uniform sampler2D u_texture_frost2;

out vec4 frag_color;

float rand(vec2 uv) {
    float a = dot(uv, vec2(92., 80.));
    float b = dot(uv, vec2(41., 62.));
    float x = sin(a) + cos(b) * 51.;
    return fract(x * 1000);
}

vec4 randColor(vec2 uv, float intensity) {
    
    return vec4(rand(uv.xy) * intensity * ((rand(uv.yx)*2) - 1), 
                rand(uv.yx) * intensity * ((rand(uv.xy)*2) - 1),
                0, 1); 
} 

vec2 dist(vec2 pos) {
    float intensity = 5;
    return pos + (
    randColor(pos, intensity).xy 
    
) * 0.01 * 2;
}

void main() {
    vec2 uv = FlutterFragCoord().xy / u_size;
    frag_color = texture(u_texture_input, dist(uv));
}