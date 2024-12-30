#define PI 3.1415926535

uniform vec3 uColor;
void main() {
    vec2 coord = gl_PointCoord - vec2(0.5);
    float distance = length(coord);
    if (distance > 0.5) discard;
    gl_FragColor = vec4(uColor, 1);
}
