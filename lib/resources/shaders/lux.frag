#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2 uSize;
uniform float uThick;
uniform float uRepeats;
uniform float uScale; 
uniform float uShimmer;
uniform vec3 uColor;
uniform float uPower;

out vec4 fragColor;

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec3 c;
    float l,z=uTime;
    for(int i=0;i<3;i++) {
        vec2 uv,p=fragCoord.xy/uSize;
        uv=p;
        p-=.5;
        p.x*=uSize.x/uSize.y;
        z+=uShimmer * 0.07;
        l=length(p) * uScale;
        uv+=p/l*(sin(z)+1.)*abs(sin(l*uRepeats-z-z));
        c[i]=(.01 * uThick)/length(mod(uv,1.)-0.5);
    }
    
    vec3 color = vec3(c/l) * uColor;
    float al = uTime * 2;
    al = pow(1.0 - length(fragCoord.xy - uSize/2.0) / (uSize.y/2.0), uPower);
    fragColor=vec4(color*al, al);
}