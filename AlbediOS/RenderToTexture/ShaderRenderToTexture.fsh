//
//  Shader.fsh
//  ertztreter
//
//  Created by Anthony on 08/02/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

precision highp float;

uniform sampler2D   texture;
uniform sampler2D   textureShowImage;

varying vec2        coords;

uniform bool        actionBlurH;
uniform bool        actionBlurV;
uniform bool        actionSepia;
uniform bool        actionRadialBlur;

uniform float       blurSize;

void main()
{
    vec4 color;
    
    if(actionBlurH)
    {
        color = texture2D(texture, vec2(coords.x - 4.0*blurSize, coords.y)) * 0.05;
        color += texture2D(texture, vec2(coords.x - 3.0*blurSize, coords.y)) * 0.09;
        color += texture2D(texture, vec2(coords.x - 2.0*blurSize, coords.y)) * 0.12;
        color += texture2D(texture, vec2(coords.x - blurSize, coords.y)) * 0.15;
        color += texture2D(texture, vec2(coords.x, coords.y)) * 0.16;
        color += texture2D(texture, vec2(coords.x + blurSize, coords.y)) * 0.15;
        color += texture2D(texture, vec2(coords.x + 2.0*blurSize, coords.y)) * 0.12;
        color += texture2D(texture, vec2(coords.x + 3.0*blurSize, coords.y)) * 0.09;
        color += texture2D(texture, vec2(coords.x + 4.0*blurSize, coords.y)) * 0.05;
    }
    else if(actionBlurV)
    {
        color = texture2D(texture, vec2(coords.x, coords.y - 4.0*blurSize)) * 0.05;
        color += texture2D(texture, vec2(coords.x, coords.y - 3.0*blurSize)) * 0.09;
        color += texture2D(texture, vec2(coords.x, coords.y - 2.0*blurSize)) * 0.12;
        color += texture2D(texture, vec2(coords.x, coords.y - blurSize)) * 0.15;
        color += texture2D(texture, vec2(coords.x, coords.y)) * 0.16;
        color += texture2D(texture, vec2(coords.x, coords.y + blurSize)) * 0.15;
        color += texture2D(texture, vec2(coords.x, coords.y + 2.0*blurSize)) * 0.12;
        color += texture2D(texture, vec2(coords.x, coords.y + 3.0*blurSize)) * 0.09;
        color += texture2D(texture, vec2(coords.x, coords.y + 4.0*blurSize)) * 0.05;
    }
    else if(actionSepia)
    {
        color = texture2D(texture, coords.xy);
        
        vec4 outputColor = color;
        outputColor.r = (color.r * 0.393) + (color.g * 0.769) + (color.b * 0.189);
        outputColor.g = (color.r * 0.349) + (color.g * 0.686) + (color.b * 0.168);
        outputColor.b = (color.r * 0.272) + (color.g * 0.534) + (color.b * 0.131);
        color = outputColor;
    }
    else if(actionRadialBlur)
    {
        const float sampleDist = 0.6;
        const float sampleStrength = 1.0;
        
        float samples[10];
        samples[0] = -0.08;
        samples[1] = -0.05;
        samples[2] = -0.03;
        samples[3] = -0.02;
        samples[4] = -0.01;
        samples[5] =  0.01;
        samples[6] =  0.02;
        samples[7] =  0.03;
        samples[8] =  0.05;
        samples[9] =  0.08;
        
        vec2 dir = vec2(0.5,0.5) - coords;
        float dist = sqrt(dir.x*dir.x + dir.y*dir.y);
        dir = dir/dist;
        
        color = texture2D(texture, coords);
        vec4 sum = color;
        
        for (int i = 0; i < 10; i++)
            sum += texture2D(texture, coords + dir * samples[i] * sampleDist );
        
        sum *= 1.0/11.0;
        float t = dist * sampleStrength;
        t = clamp( t ,0.0,1.0);
        
        color = mix( color, sum, t);
    }
    else
    {
        color = texture2D(texture, coords.xy);
    }
    
    gl_FragColor = color;
}
