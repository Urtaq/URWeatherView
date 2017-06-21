kernel vec4 shockWave(sampler src, vec2 center, float time, vec3 shockParams)
{
    vec2 texture2D = samplerCoord(src);
    float distance = length(texture2D - center);
    if ( (distance <= (time + shockParams.z)) && (distance >= (time - shockParams.z)) )
    {
        float diff = (distance - time);
        float powDiff = 1.0 - pow(abs(diff * shockParams.x), shockParams.y);
        float diffTime = diff  * powDiff;
        vec2 diffUV = normalize(texture2D - center);
        texture2D = texture2D + (diffUV * diffTime);
    }
    return vec4(sample(src, texture2D).rgba);
}
