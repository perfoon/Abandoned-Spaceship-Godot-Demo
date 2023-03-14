shader_type spatial;
render_mode diffuse_burley, specular_schlick_ggx, depth_draw_opaque;

uniform float uv_scale = 1.0;
uniform float heightmap_scale;
uniform float normal_scale;
uniform float blend_min = 0.3;
uniform float blend_max = 0.4;

uniform sampler2D albedo_red : source_color;
uniform sampler2D heightmap_red;
uniform sampler2D orm_red;
uniform sampler2D normal_red;
uniform vec3 color_red : source_color = vec3(1.0, 1.0, 1.0);

uniform sampler2D albedo_green;
uniform sampler2D heightmap_green;
uniform sampler2D orm_green;
uniform sampler2D normal_green;
uniform vec3 color_green : source_color = vec3(1.0, 1.0, 1.0);

uniform sampler2D albedo_blue;
uniform sampler2D heightmap_blue;
uniform sampler2D orm_blue;
uniform sampler2D normal_blue;
uniform vec3 color_blue : source_color = vec3(1.0, 1.0, 1.0);

void fragment() {
	vec3 view_dir = normalize(normalize(-VERTEX)*mat3(TANGENT, -BINORMAL, NORMAL));
	
	float h_r = 1.0 - texture(heightmap_red, UV * uv_scale).r;
	float h_b = 1.0 - texture(heightmap_blue, UV * uv_scale).r;
	float h_g = 1.0 - texture(heightmap_green, UV * uv_scale).r;
	
	vec2 uv_r = UV * uv_scale - view_dir.xy * h_r * heightmap_scale * 0.01;
	vec2 uv_g = UV * uv_scale - view_dir.xy * h_g * heightmap_scale * 0.01;
	vec2 uv_b = UV * uv_scale - view_dir.xy * h_b * heightmap_scale * 0.01;
	vec3 albedo_r = texture(albedo_red, uv_r).rgb * color_red;
	vec3 albedo_g = texture(albedo_green, uv_g).rgb * color_green;
	vec3 albedo_b = texture(albedo_blue, uv_b).rgb * color_blue;
	vec4 orm_r = texture(orm_red, uv_r);
	vec4 orm_g = texture(orm_green, uv_g);
	vec4 orm_b = texture(orm_blue, uv_b);
	
	vec3 normal_r = texture(normal_red, uv_r).rgb;
	vec3 normal_g = texture(normal_green, uv_g).rgb;
	vec3 normal_b = texture(normal_blue, uv_b).rgb;
	//vec3(COLOR[0],COLOR[1],COLOR[2]);
	
	float blend1 = smoothstep(blend_min, blend_max, max(h_r + COLOR[1], h_g) - h_g);
	float blend2 = smoothstep(blend_min, blend_max, max(h_r + COLOR[2], h_b) - h_b);
	
	//ALBEDO = mix(albedo_r, mix(albedo_g, albedo_b, COLOR[2]), COLOR[1]);
	vec3 orm = mix(mix(orm_r, orm_b, blend2), orm_g, blend1).rgb;
	
	ALBEDO = mix(mix(albedo_r, albedo_b, blend2), albedo_g, blend1);
	AO = orm.r;
	ROUGHNESS = orm.g;
	METALLIC = orm.b;
	SPECULAR = 0.2;
	
	NORMAL_MAP = mix(mix(normal_r, normal_b, blend2), normal_g, blend1);
	NORMAL_MAP_DEPTH = normal_scale;
}
