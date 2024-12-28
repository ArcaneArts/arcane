#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
    vec2 coord = FlutterFragCoord().xy;
    vec2 uv = coord / uSize;
    vec4 tex = texture(uTexture, uv);
    vec3 rgb = (1.0 - (tex.rgb / tex.a)) * tex.a;
    fragColor = vec4(rgb, tex.a);
}