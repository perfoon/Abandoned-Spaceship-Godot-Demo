shader_type spatial;
render_mode diffuse_burley, specular_schlick_ggx, depth_draw_opaque;

uniform sampler2D albedo_tex : source_color;
uniform sampler2D ORM_tex;
uniform sampler2D height_color_mask_tex;

uniform vec4 paint_color : source_color;
uniform float roughness_scale;
uniform float heightmap_scale;

uniform sampler2D normal_tex;
uniform float normal_scale;

uniform sampler2D detail_tex;

void fragment() {
	float depth = 1.0 - texture(height_color_mask_tex, UV).r;
	vec3 view_dir = normalize(normalize(-VERTEX)*mat3(TANGENT, -BINORMAL, NORMAL));
	vec2 base_uv = UV - view_dir.xy * depth * heightmap_scale * 0.01;
	float paint_mask = texture(height_color_mask_tex, base_uv).g;
	vec3 albedo = texture(albedo_tex, base_uv).rgb;
	vec4 detail = texture(detail_tex, base_uv * 3.7);
	vec4 orm = texture(ORM_tex, base_uv);
	
	ALBEDO = mix(albedo, albedo * paint_color.rgb, paint_mask) * detail.rgb;
	AO = orm.r;
	ROUGHNESS = orm.g * roughness_scale + (1.0 - detail.r);
	METALLIC = orm.b;
	SPECULAR = 0.3;
	
	NORMAL_MAP = texture(normal_tex, base_uv).rgb;
	NORMAL_MAP_DEPTH = normal_scale;
}
