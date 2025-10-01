#include <flutter/runtime_effect.glsl>

uniform vec2 u_size;
uniform float u_time;
uniform float u_intensity;

uniform sampler2D u_texture_input;

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
    return pos + (randColor(pos, u_intensity).xy) * 0.01 * 2;
}

void main() {
    vec2 uv = FlutterFragCoord().xy / u_size;
    #ifdef IMPELLER_TARGET_OPENGLES
  uv.y = 1.0 - uv.y;
    #endif
    
    frag_color = texture(u_texture_input, dist(uv));
}