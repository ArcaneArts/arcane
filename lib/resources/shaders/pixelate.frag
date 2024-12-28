#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

uniform float uValue;
uniform vec2 uSize;
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
    vec2 coord = FlutterFragCoord().xy;
    vec2 blockSize = vec2(uValue);
    vec2 pixelCoord = floor(coord / blockSize) * blockSize;
    vec2 uv = pixelCoord / uSize;
    fragColor = texture(uTexture, uv);
}