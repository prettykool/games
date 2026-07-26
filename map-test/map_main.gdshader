shader_type canvas_item;

uniform sampler2D noise_tex;
uniform vec4 dark  : source_color = vec4(0.075, 0.251, 0.059, 1.0);
uniform vec4 light : source_color = vec4(0.083, 0.251, 0.012, 1.0);
uniform float scale = 0.002;
uniform float pixel_size = 8.0;
uniform float threshold = 0.5;
uniform vec2 world_offset;
varying vec2 world_pos;

void vertex()
{
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment()
{
    vec2 snapped = floor(world_pos / pixel_size) * pixel_size;
    vec2 uv = fract((snapped + world_offset) * scale);
    float n = texture(noise_tex, uv).r;
    
    float s = step(threshold, n);
    COLOR = mix(dark, light, s);
}