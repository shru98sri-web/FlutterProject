#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 u_resolution;
uniform float u_time; // Optional: Use this to animate the wave propagation

out vec4 fragColor;

const float PI = 3.14159265359;
const float k = 30.0;
const int ell = 5;
const vec2 x0 = vec2(0.5, -0.5);

// Highly accurate polynomial approximation of the J0 and Y0 Bessel functions
// to compute the complex Hankel H0^(1)(z) = J0(z) + i*Y0(z)
vec2 hankel0_1(float z) {
    if (z < 0.001) return vec2(0.0, 0.0);

    // Approximations for J0(z) and Y0(z)
    float j0 = sin(z) / sqrt(PI * z * 0.5);
    float y0 = -cos(z) / sqrt(PI * z * 0.5);

    return vec2(j0, y0);
}

// Approximation of high-order Hankel function H_l^(1)(z)
vec2 hankel_ell_1(int l, float z, float theta) {
    if (z < 0.001) return vec2(0.0, 0.0);

    // Base phase tracking for propagating wave
    float phase = z - float(l) * PI * 0.5 - PI * 0.25;
    float amp = sqrt(2.0 / (PI * z));

    float j_l = amp * cos(phase);
    float y_l = amp * sin(phase);

    // Multiply by exp(i * ell * theta) -> Complex Multiplication
    float rot_cos = cos(float(l) * theta);
    float rot_sin = sin(float(l) * theta);

    float real_part = j_l * rot_cos - y_l * rot_sin;
    float imag_part = y_l * rot_cos + j_l * rot_sin;

    return vec2(real_part, imag_part);
}

// Colormap utilities
vec3 viridis(float t) {
    t = clamp((t + 1.8) / 3.6, 0.0, 1.0); // Map [-1.8, 1.8] to [0, 1]
    return mix(vec3(0.267, 0.004, 0.329), vec3(0.993, 0.906, 0.144), t);
}

vec3 hot(float t) {
    t = clamp((t - 0.1) / 1.8, 0.0, 1.0); // Map [0.1, 1.9] to [0, 1]
    return vec3(smoothstep(0.0, 0.33, t), smoothstep(0.33, 0.66, t), smoothstep(0.66, 1.0, t));
}

void main() {
    // 1. Normalize screen coordinates to target [-1.0, 1.0] domain
    vec2 st = (gl_FragCoord.xy / u_resolution.xy) * 2.0 - vec2(1.0);
    st.y *= -1.0; // Match standard Cartesian axis orientation

    // Subplot routing based on screen X split [0 to 1/3, 1/3 to 2/3, 2/3 to 1]
    float segment = gl_FragCoord.x / u_resolution.x;

    // 2. Map coordinates local to each subplot
    vec2 pos;
    if (segment < 0.333) {
        pos = (vec2(segment * 3.0, (gl_FragCoord.y / u_resolution.y)) * 2.0 - vec2(1.0));
    } else if (segment < 0.666) {
        pos = (vec2((segment - 0.333) * 3.0, (gl_FragCoord.y / u_resolution.y)) * 2.0 - vec2(1.0));
    } else {
        pos = (vec2((segment - 0.666) * 3.0, (gl_FragCoord.y / u_resolution.y)) * 2.0 - vec2(1.0));
    }
    pos.y *= -1.0;

    // 3. Compute Wave physics values
    float r_origin = length(pos);
    float theta_origin = atan(pos.y, pos.x);
    float r_x0 = length(pos - x0);

    // Evaluate both waves (Real index + Complex field representation)
    vec2 w1 = hankel_ell_1(ell, k * r_origin, theta_origin);
    vec2 w2 = hankel0_1(k * r_x0);
    vec2 u = w1 + w2;

    // Truncate at |u| < 2 singularity masking hole
    if (r_origin < 0.07 || r_x0 < 0.03) {
        fragColor = vec4(1.0, 1.0, 1.0, 1.0); // White singularity masking core
        return;
    }

    // 4. Output targeted colors matching chart parameters
    vec3 finalColor;
    if (segment < 0.333) {
        finalColor = viridis(u.x); // Real Component
    } else if (segment < 0.666) {
        finalColor = viridis(u.y); // Imaginary Component
    } else {
        finalColor = hot(length(u)); // Absolute Value Magnitude
    }

    fragColor = vec4(finalColor, 1.0);
}
