#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>


layout(location = 0) uniform vec2 size;
layout(location = 1) uniform vec2 prevSize;
layout(location = 2) uniform vec2 deltaPosition;
layout(location = 3) uniform float intensity;
layout(location = 4) uniform sampler2D frame;

out vec4 fragColor;

void main() {
    const int numSteps = 60;
    vec2 uv = FlutterFragCoord().xy/size;
    vec2 deltaPositionUv = deltaPosition/size;
    vec2 sizeRatio = size/prevSize;
    vec4 pixel = vec4(0);

    for(int i=0;i<int(numSteps);i++){
        vec2 scaled = uv+(uv*sizeRatio-uv)*float(i)/float(numSteps)*intensity;
        vec2 translated = scaled - intensity*deltaPositionUv*sizeRatio*float(i)/float(numSteps);
        pixel+=texture(frame,translated);
    }

    pixel/=numSteps;
    fragColor = pixel;
}