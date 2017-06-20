kernel vec4 waveWarp(sampler src, float time, float velocity, float wRatio, float hRatio, float pi) {
    vec2 tc = samplerCoord(src);
    vec2 p = vec2(tc.x, tc.y);
    float len = length(p);
    vec2 uv = tc + cos((len - time * velocity) * 12.0 * (1.0 / hRatio * 10.0)) * 0.003 * wRatio;
    vec3 col = sample(src, vec2(uv.x, tc.y)).rgb;
    return vec4(col.rgb, sample(src, tc).a);
}
