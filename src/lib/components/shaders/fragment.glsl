uniform float time;
uniform vec3 color;
varying vec2 vUv;

void main() {
    // Grid effect
    float gridX = abs(sin(vUv.x * 30.0));
    float gridY = abs(sin(vUv.y * 30.0));
    float grid = gridX + gridY;

    // Glow intensity
    float intensity = smoothstep(0.8, 1.0, grid);

    // Color and glow
    vec3 finalColor = color * intensity;

    gl_FragColor = vec4(finalColor, 1.0);
}
