//
//  Shader.vsh
//  3DEngine
//
//  Created by Anthony on 06/02/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#define kLightTypesDirectional 1
#define kLightTypesPoint 2

precision highp float;
precision highp int;

attribute   vec4    position;
attribute   vec3    normal;
attribute   vec2    coords;

uniform     mat4    M;
uniform     mat4    V;
uniform     mat4    P;
uniform     mat3    normalMatrix;

//lights
uniform     int     uLightType;
uniform     vec4    uLightPosition;

//Shadow Mapping
uniform     mat4    SMP;
uniform     mat4    SMLV;
uniform     bool    SMEnabled;

varying     vec3    vNormal;
varying     mat3    vNormalMatrix;
varying     vec4    vWorldPosition;
varying     vec2    vCoords;
varying     vec4    vSMcoords;
varying     vec4    vDiffuseColor;
//varying     vec4    SMz;
varying     vec4    vLightPosition;

void main()
{
    if(SMEnabled)
    {
        gl_Position = SMP * SMLV * M * position;
        //SMz = gl_Position;
    }
    else
    {
        vCoords = coords;
        
        vNormalMatrix = mat3(V) * normalMatrix;
        vNormal = normal;
        
        vWorldPosition = V * M * position;
        
        if(uLightType == kLightTypesDirectional)
            vLightPosition = vec4(mat3(V) * normalize(uLightPosition.xyz), 1.0);
        if(uLightType == kLightTypesPoint)
            vLightPosition = (V * uLightPosition) - vWorldPosition;
        
        gl_Position = P * V * M * position;
        
        mat4 bias = mat4(0.5, 0.0, 0.0, 0.0,
                         0.0, 0.5, 0.0, 0.0,
                         0.0, 0.0, 0.5, 0.0,
                         0.5, 0.5, 0.5, 1.0);
        
        vSMcoords = bias * SMP * SMLV * M * position;
    }
}
