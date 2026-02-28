shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// A boolean flag to toggle between rendering pipelines
uniform bool use_canvas_group = false;

// Tell the shader how many frames are in your AnimatedSprite2D sheet (Columns, Rows)
// For a standard standalone Sprite2D, leave this at vec2(1.0, 1.0)
uniform vec2 spritesheet_frames = vec2(1.0, 1.0); 

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec4 stone_tint : source_color = vec4(0.6, 0.6, 0.6, 1.0);
uniform float tint_weight : hint_range(0.0, 1.0) = 0.85; 
uniform float edge_blur : hint_range(0.0, 0.5) = 0.05;
uniform vec2 pixel_resolution = vec2(64.0, 16.0); 

void fragment() {
    vec4 tex_color;
    
    // 1. Fix the Darkening Issue
    if (use_canvas_group) {
        tex_color = textureLod(screen_texture, SCREEN_UV, 0.0);
        if (tex_color.a > 0.0001) {
            tex_color.rgb /= tex_color.a;
        }
    } else {
        // In Godot 4, COLOR already contains the texture * modulate.
        // Reading the texture again and multiplying it later squares the color!
        tex_color = COLOR; 
    }
    
    // Calculate standard luminance
    float grey = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 final_stone_rgb = mix(vec3(grey), stone_tint.rgb, tint_weight);
    vec4 stone_color = vec4(final_stone_rgb, tex_color.a);
    
    // 2. Fix the Atlas UV Issue
    // fract() wraps the global atlas UV into a neat 0.0 to 1.0 space for the current frame
    vec2 local_uv = fract(UV * spritesheet_frames);
    
    // Discretise the local UV space for pixel perfection
    vec2 discrete_uv = floor(local_uv * pixel_resolution) / pixel_resolution;
    
    float aspect_ratio = pixel_resolution.x / pixel_resolution.y;
    vec2 center = vec2(0.5, 0.5);
    
    vec2 adjusted_uv = discrete_uv;
    adjusted_uv.x = (adjusted_uv.x - center.x) * aspect_ratio + center.x;
    
    float dist = distance(adjusted_uv, center);
    
    float max_radius = length(vec2(0.5 * aspect_ratio, 0.5));
    float start_radius = max_radius + edge_blur;
    float end_radius = -edge_blur;
    float current_radius = mix(start_radius, end_radius, progress);
    
    float transition_edge = smoothstep(current_radius - edge_blur, current_radius + edge_blur, dist);
    float biased_transition = pow(transition_edge, 0.5);
    
    vec4 final_color = mix(tex_color, stone_color, biased_transition);
    
    // Output directly instead of multiplying by COLOR again
    COLOR = final_color;
}