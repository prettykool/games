shader_type sky;
uniform sampler3D noise;

void sky() {
    if (AT_CUBEMAP_PASS) {
        COLOR = vec3(0.0);
        ALPHA = 1.0;
    } else {
		vec2 norm = (SKY_COORDS * 2.0) - vec2(-1.0, -1.0);
		float long = norm.x * PI;
		float lat = norm.y * (PI/2.0);
		vec3 projected = vec3(cos(lat) * sin(long), cos(lat) * cos(long), sin(lat));
		vec3 color = texture(noise, projected).rgb;
		COLOR = color;
    }
}