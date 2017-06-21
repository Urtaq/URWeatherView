kernel vec4 ripple(sampler src, float time) {
    vec2 tc = samplerCoord(src);
    vec2 p = -1.0 + 2.0 * tc;
    float len = length(p);
    vec2 uv = tc + (p / len) * cos(len * 12.0 - time * 4.0) * 0.03;
    vec3 col = sample(src, uv).rgb;
    return vec4(col.rgb, sample(src, tc).a);
}
