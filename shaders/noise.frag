#include <flutter/runtime_effect.glsl>
#define PI 3.14159265358979323846

uniform vec2 uResolution;
uniform float uTime;
uniform vec4 uMin;
uniform vec4 uMax;
uniform float uTemp;

out vec4 fragColor;
float randW(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float rand(vec2 c){
    return fract(sin(dot(c.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p, float freq ){
    float unit = uTemp/freq;
    vec2 ij = floor(p/unit);
    vec2 xy = mod(p,unit)/unit;
    //xy = 3.*xy*xy-2.*xy*xy*xy;
    xy = .5*(1.-cos(PI*xy));
    float a = rand((ij+vec2(0.,0.)));
    float b = rand((ij+vec2(1.,0.)));
    float c = rand((ij+vec2(0.,1.)));
    float d = rand((ij+vec2(1.,1.)));
    float x1 = mix(a, b, xy.x);
    float x2 = mix(c, d, xy.x);
    return mix(x1, x2, xy.y);
}

float noiseW(vec2 p){
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u*u*(3.0-2.0*u);

    float res = mix(
        mix(randW(ip), randW(ip+vec2(1.0,0.0)), u.x),
        mix(randW(ip+vec2(0.0,1.0)), randW(ip+vec2(1.0,1.0)), u.x), u.y);
    return res*res;
}

float lerp(float a, float b, float t) {
    return a + (b - a) * t;
}

vec4 toPremultipliedAlpha(vec4 color) {
    return vec4(color.xyz * color.w, color.w);
}

void main() {
    vec2 uv = (gl_FragCoord.xy / uResolution.xy) *1500;
    float noiseA = noiseW(uv + uTime * 0.1) * 0.5;
    float noiseR = noiseW(uv + vec2(1000.0, 1000.0) + uTime * 0.2) * 0.5;
    float noiseG = noiseW(uv + vec2(2000.0, 2000.0) + uTime * 0.3) * 0.5;
    float noiseB = noiseW(uv + vec2(3000.0, 3000.0) + uTime * 0.4) * 0.5;
    noiseA += (noise(uv + uTime * 0.1, 1.) + 0.5) * 0.5;
    noiseR += (noise(uv + vec2(1000.0, 1000.0) + uTime * 0.2, 1.)  + 0.5) * 0.5;
    noiseG += (noise(uv + vec2(2000.0, 2000.0) + uTime * 0.3, 1.)  + 0.5) * 0.5;
    noiseB += (noise(uv + vec2(3000.0, 3000.0) + uTime * 0.4, 1.)  + 0.5) * 0.5;
    noiseA *=0.5;
    noiseR *=0.5;
    noiseG *=0.5;
    
    fragColor = toPremultipliedAlpha(vec4(
        lerp(uMin.y, uMax.y, noiseR),
        lerp(uMin.z, uMax.z, noiseG),
        lerp(uMin.w, uMax.w, noiseB),
        lerp(uMin.x, uMax.x, noiseA)
    ));
    
    
}