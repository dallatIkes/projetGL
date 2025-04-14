shader_type spatial;

render_mode unshaded, fog_disabled;

uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
    vec3 color = texture(screen_texture, SCREEN_UV).rgb;
    float gray = dot(color, vec3(0.299, 0.587, 0.114));
    ALBEDO = vec3(gray);
}
