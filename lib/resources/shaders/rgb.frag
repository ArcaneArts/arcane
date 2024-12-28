precision mediump float;

#include <flutter/runtime_effect.glsl>

// Flutter uniforms
uniform vec2 uSize;       // Size of the draw area
uniform float uRadius;    // Controls how wide the radial effect is
uniform float uSpin;      // How strongly we spin the hue
uniform sampler2D uTexture;

out vec4 fragColor;

// Convert RGB to HSV
vec3 rgb2hsv(vec3 c) {
    float cMax = max(c.r, max(c.g, c.b));
    float cMin = min(c.r, min(c.g, c.b));
    float delta = cMax - cMin;

    float h = 0.0;
    float s = (cMax == 0.0) ? 0.0 : delta / cMax;
    float v = cMax;

    if (delta != 0.0) {
        if (cMax == c.r) {
            h = ((c.g - c.b) / delta);
            if (c.g < c.b) {
                h += 6.0;
            }
        } else if (cMax == c.g) {
            h = 2.0 + (c.b - c.r) / delta;
        } else {
            h = 4.0 + (c.r - c.g) / delta;
        }
        h /= 6.0;
    }
    return vec3(h, s, v);
}

// Convert HSV back to RGB
vec3 hsv2rgb(vec3 c) {
    float h = c.x * 6.0;
    float s = c.y;
    float v = c.z;

    float i = floor(h);
    float f = h - i;
    float p = v * (1.0 - s);
    float q = v * (1.0 - s * f);
    float t = v * (1.0 - s * (1.0 - f));

    if (i < 0.0) i = 0.0;  // just to safeguard

    if (i == 0.0) return vec3(v, t, p);
    if (i == 1.0) return vec3(q, v, p);
    if (i == 2.0) return vec3(p, v, t);
    if (i == 3.0) return vec3(p, q, v);
    if (i == 4.0) return vec3(t, p, v);
    return vec3(v, p, q);
}

void main() {
    // Convert the current fragment coordinate into [0..1]
    vec2 uv = FlutterFragCoord().xy / uSize;

    // Sample the base color from the texture
    vec4 color = texture(uTexture, uv);

    // Distance from the center (0.5, 0.5) in normalized coords
    vec2 center = vec2(0.5, 0.5);
    float dist  = distance(uv, center);

    // Convert the current color to HSV
    vec3 hsv = rgb2hsv(color.rgb);

    // Compute a hue shift based on distance
    // "uRadius" to control how quickly the hue changes with distance
    // "uSpin" is how strong the spin can get at max distance
    float hueShift = dist / uRadius * uSpin;

    // Shift the hue; wrap with fract() so it stays in [0..1]
    hsv.x = fract(hsv.x + hueShift);

    // Convert back to RGB
    vec3 finalColor = hsv2rgb(hsv);

    // Preserve the sampled alpha channel
    fragColor = vec4(finalColor, color.a);
}