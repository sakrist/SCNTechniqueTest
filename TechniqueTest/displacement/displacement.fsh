
uniform sampler2D colorSampler;
uniform sampler2D noiseSampler;

varying vec2 uv;

void main() {
    vec2 displacement = texture2D(noiseSampler, uv).rg - vec2(0.5, 0.5);
    gl_FragColor = texture2D(colorSampler, uv + displacement * vec2(0.1,0.1));
}
