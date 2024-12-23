uniform float time;

varying vec2 vUv; // Pass UVs to the fragment shader

void main() {
    vUv = uv;

    // Add distortion to the vertex positions
    vec3 pos = position;
    float noise = sin(pos.x * 3.0 + time) * cos(pos.y * 3.0 + time);
    pos.z += noise * 0.3;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(pos, 1.0);
}
