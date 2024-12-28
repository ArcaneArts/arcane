precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform float iTime;
uniform vec2 iResolution;
uniform vec3 color1;
uniform vec3 color2;
uniform vec3 color3;
uniform float uInvert;
uniform float uScale;
uniform float uSpeed;
uniform float uLength;
uniform float uRadius;
uniform float uFading;
uniform float uGlow;

#define uIntensity   25

out vec4 fragColor;

#define M_2_PI 6.28318530

vec2 sdBezier(vec2 pos, vec2 A, vec2 B, vec2 C)
{
    vec2 a = B - A;
    vec2 b = A - 2.0 * B + C;
    vec2 c = a * 2.0;
    vec2 d = A - pos;
    float kk = 1.0 / dot(b,b);
    float kx = kk * dot(a,b);
    float ky = kk * (2.0 * dot(a,a) + dot(d,b)) / 3.0;
    float kz = kk * dot(d,a);
    float p  = ky - kx * kx;
    float p3 = p * p * p;
    float q  = kx*(2.0 * kx*kx - 3.0 * ky) + kz;
    float h  = q*q + 4.0 * p3;
    h = sqrt(h);
    vec2 x  = (vec2(h, -h) - q) / 2.0;
    vec2 uv = sign(x) * pow(abs(x), vec2(1.0 / 3.0));
    float t = clamp(uv.x + uv.y - kx, 0.0, 1.0);

    return vec2(length(d + (c + b*t)*t), t);
}

vec2 circle(float t) {
    float x = uScale * sin(t);
    float y = uScale * cos(t);
    return vec2(x, y);
}

vec2 leminiscate(float t) {
    float s = sin(t);
    float c = cos(t);
    float denom = 1.0 + s * s; // 1 + sin^2(t)
    return vec2(
    uScale * (c / denom),
    uScale * (s * c / denom)
    );
}

float mapinfinite(vec2 pos, float sp) {
    float t  = fract(-uSpeed * iTime * sp);
    float dl = uLength / float(uIntensity);
    vec2 p1 = leminiscate(t * M_2_PI);
    vec2 p2 = leminiscate((dl + t) * M_2_PI);
    vec2 c  = (p1 + p2) / 2.0;
    float d = 1e9;
    
    for(int i = 2; i < uIntensity; i++) {
        float fi = float(i);
        p1 = p2;
        p2 = leminiscate((fi * dl + t) * M_2_PI);
        vec2 cPrev = c;
        c = (p1 + p2) / 2.0;
        vec2 f = sdBezier(pos, cPrev, p1, c);
        d = min(d, f.x + uFading * (f.y + fi) / float(uIntensity));
    }
    return d;
}

float mapcircle(vec2 pos, float sp) {
    float t  = fract(-uSpeed * iTime * sp);
    float dl = uLength / float(uIntensity);
    vec2 p1 = circle(t * M_2_PI);
    vec2 p2 = circle((dl + t) * M_2_PI);
    vec2 c  = (p1 + p2) / 2.0;
    float d = 1e9;

    for(int i = 2; i < uIntensity; i++) {
        float fi = float(i);
        p1 = p2;
        p2 = circle((fi * dl + t) * M_2_PI);
        vec2 cPrev = c;
        c = (p1 + p2) / 2.0;
        vec2 f = sdBezier(pos, cPrev, p1, c);
        d = min(d, f.x + uFading * (f.y + fi) / float(uIntensity));
    }
    return d;
}

void main()
{
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = (2.0 * fragCoord - iResolution.xy) / iResolution.y;
    float dist1 = mapcircle(   uv.yx * vec2(1.0, 0.66), 1.0 );
    float dist2 = mapinfinite( uv.xy * vec2(0.66, 1.0), 2.0 );
    float dist3 = mapcircle(   uv.xy * vec2(0.88, 0.88), 4.0 );
    vec3 col1 = color1 * pow(uRadius / dist1, uGlow);
    vec3 col2 = color2 * pow(uRadius / dist2, uGlow);
    vec3 col3 = color3 * pow(uRadius / dist3, uGlow);
    vec3 col = (col1 + col2 + col3) * (2.0 * uGlow);
    float alpha = max(col.r, max(col.g, col.b));
    alpha = clamp(alpha, 0.0, 1.0);
    fragColor = vec4(col * uInvert, alpha);
}