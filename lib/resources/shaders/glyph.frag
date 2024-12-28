#include <flutter/runtime_effect.glsl>

uniform float iTime;
uniform vec2 iResolution;
uniform float uIntensity;
uniform float uSpeed;
uniform float uRotationSpeed;
uniform float uThreshold;
uniform float uComplex;
uniform float uColorBias;
uniform float uZoom;
uniform float uInvert;
uniform float uBloom;
uniform float uPower;
uniform vec3 color1;
uniform vec3 color2;
        
out vec4 fragColor;

vec2 rotate2D(vec2 p, float a) {
    float c = cos(a);
    float s = sin(a);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

vec3 palette(float d) {
    return mix(color1, color2, d);
}

float mapFunc(vec3 p) {
    for (int i = 0; i < 64 ; i++) {
        if(i > uComplex) break;
        float t = iTime * 0.2 * uSpeed;
        p.xz = rotate2D(p.xz, t);
        vec2 tmpXY = rotate2D(vec2(p.x, p.y), t * 1.89);
        p.x = tmpXY.x;
        p.y = tmpXY.y;
        p.xz = abs(p.xz);
        p.xz -= 0.5;
    }
    
    return dot(sign(p), p) / uBloom;
}

vec4 raymarch(vec3 ro, vec3 rd) {
    float t = 0.0;
    float d = 0.0;
    vec3 col = vec3(0.0);
    
    for (int i = 0; i < 64; i++) {
        vec3 p = ro + rd * t;
        d = mapFunc(p) * 1;
        if (d < uThreshold) break;
        if (d > 100.0) break; 
        col += palette(length(p) * (1.0/uComplex)*uColorBias) / (uIntensity * d * 1); 
        t += d; 
    }

    return pow(vec4(col, 1.0 / (d * 100.0)), vec4(uPower));
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = (fragCoord - (iResolution * 0.5)) / iResolution.x;
    vec3 ro = vec3(0.0, 0.0, -50.0);
    ro.xz = rotate2D(ro.xz, iTime * uRotationSpeed); 
    vec3 forward = normalize(-ro);
    vec3 right = normalize(cross(forward, vec3(0.0, 1.0, 0.0)));
    vec3 up = normalize(cross(forward, right));
    vec3 center = ro + forward * (1/ (uComplex*0.1) * uZoom);
    vec3 uuv = center + uv.x * right + uv.y * up;
    vec3 rd = normalize(uuv - ro);
    vec4 color = raymarch(ro, rd);
    fragColor = vec4(color.rgb * uInvert, color.a);
}