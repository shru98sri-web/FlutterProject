#version 100

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;       // Canvas size (Index 0, 1)
uniform float uTime;      // Animation time (Index 2)
uniform float uIntensity; // Laser beam peak power (Index 3)
uniform float uExponent;  // Multiphoton order: 2.0 (Two-Photon) or 3.0 (Three-Photon) (Index 4)
uniform float uRadius;    // Focal beam waist radius (Index 5)

out vec4 fragColor;

void main() {
    // Normalized coordinates (-1.0 to 1.0)
    vec2 st = (FlutterFragCoord().xy - uSize * 0.5) / min(uSize.x, uSize.y);

    // Distance from laser focus center
    float r = length(st);

    // Scale spatial radius constraint according to the slider value
    // Guard against division by zero by setting a small minimum value
    float radial_scale = max(uRadius, 0.05);
    float linear_intensity = exp(-(r * r) / (radial_scale * radial_scale)) * uIntensity;

    // Pulse temporal simulation
    float pulse = sin(uTime * 3.0) * 0.5 + 0.5;

    // Multiphoton absorption scales to the power of the selected order (I^n)
    float multiphoton_absorption = pow(linear_intensity, uExponent) * (0.8 + 0.2 * pulse);

    // Structural color mapping based on dynamic thresholds
    vec3 color = vec3(1.0, 0.2, 0.5) * multiphoton_absorption;
    color += vec3(0.02, 0.0, 0.1) * (1.0 - r);

    fragColor = vec4(color, 1.0);
}
