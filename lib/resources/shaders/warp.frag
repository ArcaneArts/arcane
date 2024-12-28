#version 460 core

precision highp float;

#include < flutter / runtime_effect.glsl >

uniform vec2 uSize;
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
    vec2 coord = FlutterFragCoord().xy;
    vec2 uv = coord / uSize;
     
    // look up a domain warped uv using simplex

    fragColor = texture(uTexture, uv);
}