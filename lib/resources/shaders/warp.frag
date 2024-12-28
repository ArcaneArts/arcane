/*
 * Example SkSL for Flutter's RuntimeEffect
 * Domain-warping a texture using 2D simplex noise,
 * with no bitwise operators and no array initializations.
 *
 * Replaces the permutation array with a big switch statement.
 */

#include <flutter/runtime_effect.glsl>

//--------------------------------------
// 1) Uniforms
//--------------------------------------
uniform vec2 uSize;
uniform sampler2D uTexture;
uniform float uFreq;
uniform float uAmp;
uniform float uZ;

out vec4 fragColor;

vec2 hash2( vec2 p ) // replace this by something better
{
    p = vec2( dot(p,vec2(127.1,311.7)), dot(p,vec2(269.5,183.3)) );
    return -1.0 + 2.0*fract(sin(p)*43758.5453123);
}

vec3 hash3( vec3 p )
{
    // "Seed" the coordinates by dotting against prime-ish constants
    p = vec3(
    dot(p, vec3(127.1, 311.7,  74.7)),
    dot(p, vec3(269.5, 183.3, 246.1)),
    dot(p, vec3(113.5, 271.9, 124.6))
    );
    // Convert to [-1,+1] range by taking fract(sin()) and remapping
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float n3( vec3 p )
{
    // Skew/Unskew factors for 3D
    const float F3 = 1.0/3.0;  // skew factor
    const float G3 = 1.0/6.0;  // unskew factor

    //-------------------------------------------
    // 1) Skew the incoming space to figure out 
    //    which simplex cell we’re in:
    //-------------------------------------------
    float s  = (p.x + p.y + p.z) * F3;
    vec3  i  = floor(p + s);  // integer cell coords
    float t  = (i.x + i.y + i.z) * G3;
    vec3  X0 = i - t;         // unskew
    vec3  x0 = p - X0;        // position within cell

    //-------------------------------------------
    // 2) Determine the order of the (x,y,z) 
    //    components to figure out which corners 
    //    come first in the simplex.
    //-------------------------------------------
    // Trick: we compare components pairwise using step()
    vec3 e  = step(x0.yzx, x0.xyz);
    // “i1” picks which axes are >= the others
    vec3 i1 = min(e, 1.0 - e.zxy);
    // “i2” picks the next set
    vec3 i2 = max(e, 1.0 - e.zxy);

    //-------------------------------------------
    // 3) Offsets for the three other corners:
    //-------------------------------------------
    vec3 x1 = x0 - i1 + G3;        // offset for corner #2
    vec3 x2 = x0 - i2 + 2.0*G3;    // offset for corner #3
    vec3 x3 = x0 - 1.0 + 3.0*G3;   // offset for corner #4

    //-------------------------------------------
    // 4) Fetch random gradients at each corner:
    //-------------------------------------------
    vec3 g0 = hash3(i);
    vec3 g1 = hash3(i + i1);
    vec3 g2 = hash3(i + i2);
    vec3 g3 = hash3(i + vec3(1.0));

    //-------------------------------------------
    // 5) Calculate contribution from each corner:
    //-------------------------------------------
    // Each corner gets a “radius” contribution:
    float t0 = 0.5 - dot(x0, x0);
    float t1 = 0.5 - dot(x1, x1);
    float t2 = 0.5 - dot(x2, x2);
    float t3 = 0.5 - dot(x3, x3);

    float n0 = (t0 < 0.0) ? 0.0 : pow(t0, 4.0) * dot(g0, x0);
    float n1 = (t1 < 0.0) ? 0.0 : pow(t1, 4.0) * dot(g1, x1);
    float n2 = (t2 < 0.0) ? 0.0 : pow(t2, 4.0) * dot(g2, x2);
    float n3 = (t3 < 0.0) ? 0.0 : pow(t3, 4.0) * dot(g3, x3);

    //-------------------------------------------
    // 6) Sum all corner contributions 
    //-------------------------------------------
    // The “*32.0” is a scale factor typical in simplex noise.
    return 32.0 * (n0 + n1 + n2 + n3);
}

float n2( in vec2 p )
{
    const float K1 = 0.366025404; // (sqrt(3)-1)/2;
    const float K2 = 0.211324865; // (3-sqrt(3))/6;

    vec2  i = floor( p + (p.x+p.y)*K1 );
    vec2  a = p - i + (i.x+i.y)*K2;
    float m = step(a.y,a.x);
    vec2  o = vec2(m,1.0-m);
    vec2  b = a - o + K2;
    vec2  c = a - 1.0 + 2.0*K2;
    vec3  h = max( 0.5-vec3(dot(a,a), dot(b,b), dot(c,c) ), 0.0 );
    vec3  n = h*h*h*h*vec3( dot(a,hash2(i+0.0)), dot(b,hash2(i+o)), dot(c,hash2(i+1.0)));
    return dot( n, vec3(70.0) );
}

void main()
{
    vec2 coord = FlutterFragCoord().xy;
    vec2 uv    = coord / uSize;
    vec2 warpScale  = vec2(0.6) * (uSize / 100.0) * uFreq;
    vec2 warpAmount = vec2(0.005) * (uSize / 100.0) * uAmp;
    float nx = n3(vec3(uv * warpScale, uZ));
    float ny = n3(vec3((uv + vec2(13.37, 42.42)) * warpScale, uZ));
    uv += warpAmount * vec2(nx, ny);

    if(uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
        fragColor = vec4(0.0, 0.0, 0.0, 0.0);
        return;
    }
    
    // Sample the texture
    fragColor = texture(uTexture, uv);
}