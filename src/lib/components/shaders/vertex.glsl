// vertex.glsl
void main() {
    gl_Position = projectionMatrix * modelViewMatrix * vec4(tan(position), 1.0);
}
