kernel vec4 frostedGlass(sampler src, float vx_offset) {
    vec2 uv = samplerCoord(src);
    vec3 tc = vec3(1.0, 0.0, 0.0);

    vec2 v1 = vec2(92.,80.);
    vec2 v2 = vec2(41.,62.);
    float rnd_factor = 0.05;
    float rnd_scale = 5.1;

    if (uv.x < (vx_offset - 0.005)) {
        float randomCoefficient = fract(sin(dot(uv.xy ,v1)) + cos(dot(uv.xy ,v2)) * rnd_scale);
        vec2 rnd = vec2(randomCoefficient, randomCoefficient);
        tc = sample(src, uv + rnd * rnd_factor).rgb;
    } else if (uv.x >= (vx_offset + 0.005)) {
        tc = sample(src, uv).rgb;
    }
    return vec4(sample(src, tc).rgba);
}
