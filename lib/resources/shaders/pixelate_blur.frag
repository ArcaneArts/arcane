precision mediump float;

#include <flutter/runtime_effect.glsl>
uniform vec2 iResolution;
uniform float samples;
uniform float pixelSize;
uniform float radius;
uniform sampler2D uTexture;

out vec4 FragColor;

#define MAX_SAMPLES 25

void main() {
    vec2 fragCoord   = FlutterFragCoord().xy;
    vec2 uv          = fragCoord / iResolution.xy;
    vec2 pixelatedUV = floor(uv * iResolution.xy / pixelSize) * pixelSize / iResolution.xy;

    // Accumulate full RGBA
    vec4 col = vec4(0.0);

    int iSamples = int(floor(samples));
    if (iSamples < 1)         iSamples = 1;
    if (iSamples > MAX_SAMPLES) iSamples = MAX_SAMPLES;

    int halfSamples = iSamples / 2;

    for (int x = -MAX_SAMPLES; x <= MAX_SAMPLES; x++) {
        // Skip loop values outside [-halfSamples..halfSamples]
        if (x < -halfSamples) continue;
        if (x >  halfSamples) break;

        for (int y = -MAX_SAMPLES; y <= MAX_SAMPLES; y++) {
            if (y < -halfSamples) continue;
            if (y >  halfSamples) break;

            vec2 samplePos = pixelatedUV + vec2(float(x), float(y)) * (radius / iResolution.xy);

            // Add the entire RGBA from the texture
            col += texture(uTexture, samplePos);
        }
    }

    float total = float((iSamples + 1) * (iSamples + 1));
    col /= total;

    // col now includes alpha from sampled pixels
    FragColor = col;
}