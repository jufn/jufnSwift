precision highp float;

uniform sampler2D Texture;
varying vec2 TextureCoordsVarying;

void main() {
    vec4 color = texture2D(Texture, TextureCoordsVarying);
    gl_FragColor = vec4(color.rgb, 1.0);
}
