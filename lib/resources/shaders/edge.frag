#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

uniform float uValue;
uniform vec2 uSize;
uniform sampler2D uTexture;

out vec4 fragColor;

vec3 samplef(const int x, const int y, in vec2 fragCoord)
{
    vec2 uv = fragCoord.xy / uSize.xy * uSize.xy;
    uv = (uv + vec2(x, y)) / uSize.xy;
    uv.y = 1-uv.y;
    return texture(uTexture, uv).xyz;
}

float luminance(vec3 c)
{
    return dot(c, vec3(.2126, .7152, .0722));
}

vec3 filterf(vec2 fragCoord)
{
    vec3 hc =samplef(-1,-1, fragCoord) *  1. + samplef( 0,-1, fragCoord) *  2.
    +samplef( 1,-1, fragCoord) *  1. + samplef(-1, 1, fragCoord) * -1.
    +samplef( 0, 1, fragCoord) * -2. + samplef( 1, 1, fragCoord) * -1.;
    vec3 vc =samplef(-1,-1, fragCoord) *  1. + samplef(-1, 0, fragCoord) *  2.
    +samplef(-1, 1, fragCoord) *  1. + samplef( 1,-1, fragCoord) * -1.
    +samplef( 1, 0, fragCoord) * -2. + samplef( 1, 1, fragCoord) * -1.;
    return samplef(0, 0, fragCoord) * pow(luminance(vc*vc + hc*hc), .6);
}

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    float u = fragCoord.x / uSize.x;
    float l = smoothstep(0., 1 / uSize.y, u);
    vec2 fc = fragCoord.xy;
    fc.y = uSize.y - fragCoord.y;
    vec3 cf = filterf(fc);
    vec3 cr = cf * l*0.5;

    fragColor = vec4(cr, length(cr));
}