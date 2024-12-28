#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2 uSize;
uniform float uSpeed;
uniform float uPower;
uniform vec2 uFocal;
uniform float uScale;
uniform vec3 uColor;
uniform vec2 uDirection;

out vec4 fragColor;

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = 1.5*(2.0*fragCoord.xy - uSize.xy) / uSize.y;
    vec2 mouse = 1.5*(2.0*uFocal.xy - uSize.xy) / uSize.y;
    vec2 offset = vec2(cos((uTime * uSpeed)/uDirection.x)*mouse.x,sin((uTime * uSpeed)/uDirection.y)*mouse.y);
    float light = 0.1 / distance(normalize(uv), uv);

    if(length(uv) < 1.0){
        light *= 0.1 / distance(normalize(uv-offset), uv-offset);
    }
 
    light = pow(light, uPower);
    fragColor = vec4(light*uColor, light);
}