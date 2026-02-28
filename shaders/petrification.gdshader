shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4 stone_tint : source_color = vec4(0.6, 0.6, 0.6, 1.0);
uniform float tint_weight : hint_range(0.0, 1.0) = 0.85; 
uniform float edge_blur : hint_range(0.0, 0.5) = 0.05;
uniform vec2 pixel_resolution = vec2(64.0, 16.0); 

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Calculate standard luminance
    float grey = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
    
    vec3 final_stone_rgb = mix(vec3(grey), stone_tint.rgb, tint_weight);
    vec4 stone_color = vec4(final_stone_rgb, tex_color.a);
    
    // Quantise the UV space for the pixel grid
    vec2 discrete_uv = floor(UV * pixel_resolution) / pixel_resolution;
    
    float aspect_ratio = pixel_resolution.x / pixel_resolution.y;
    vec2 center = vec2(0.5, 0.5);
    
    vec2 adjusted_uv = discrete_uv;
    adjusted_uv.x = (adjusted_uv.x - center.x) * aspect_ratio + center.x;
    
    float dist = distance(adjusted_uv, center);
    
    // Calculate the distance to the furthest corner dynamically
    float max_radius = length(vec2(0.5 * aspect_ratio, 0.5));
    
    // CORRECTED DOMAIN MAPPING:
    // Start slightly wider than the corner, end mathematically past zero.
    float start_radius = max_radius + edge_blur;
    float end_radius = -edge_blur;
    float current_radius = mix(start_radius, end_radius, progress);
    
    float transition_edge = smoothstep(current_radius - edge_blur, current_radius + edge_blur, dist);
    
    float biased_transition = pow(transition_edge, 0.5);
    
    COLOR = mix(tex_color, stone_color, biased_transition);
}