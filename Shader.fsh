//
//  Shader.fsh
//  3DEngine
//
//  Created by Anthony on 06/02/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#define kLightTypesDirectional 1
#define kLightTypesPoint 2

precision highp float;
precision highp int;

uniform sampler2D   uTexture;
uniform sampler2D   uTextureNM;
uniform sampler2D   uTextureSM;

uniform bool        uTextured;
uniform bool        uTexturedNM;
uniform bool        SMEnabled;

uniform vec4        uDiffuseColor;
uniform float       uShininess;

uniform float       uLightPower;
uniform int         uLightType;
uniform vec4        uLightColor;

varying vec3        vNormal;
varying mat3        vNormalMatrix;
varying vec4        vWorldPosition;
varying vec2        vCoords;
varying vec4        vSMcoords;
varying vec4        vDiffuseColor;
varying vec4        vLightPosition;
//varying vec4        SMz;

void main()
{    
    if(SMEnabled)
    {
        //gl_FragColor = vec4(SMz.z/SMz.w,SMz.z/SMz.w,SMz.z/SMz.w,1.0);
        gl_FragColor = vec4(gl_FragCoord.z,gl_FragCoord.z,gl_FragCoord.z,1.0);
    }
    else
    {
        vec4 diffuseColor = vec4(uDiffuseColor.xyz, 1.0);
        vec4 ambientColor = vec4(0.2, 0.2, 0.2, 1.0) * diffuseColor;
        vec4 lightColor = uLightColor;
        vec4 specularColor = vec4(1.0, 1.0, 1.0, 1.0);
        
        vec3 eyeNormal = normalize(vNormalMatrix * vNormal);
        vec3 lightVec = vLightPosition.xyz;
        vec3 eyeVec = -vWorldPosition.xyz;//le vecteur oeil->vertex est l'inverse de la position du vertex dans l'espace V
        
        if(uTexturedNM)
        {
            vec3 t;
            vec3 b;
            vec3 n = vNormal;
            
            vec3 rgb = texture2D(uTextureNM, vCoords.xy).rgb;
            eyeNormal = normalize(rgb * 2.0 - 1.0);
            
            vec3 c1 = cross(n, vec3(0.0, 0.0, 1.0));
            vec3 c2 = cross(n, vec3(0.0, 1.0, 0.0));
            
            if(length(c1)>length(c2))
            {
                t = c1;
            }
            else
            {
                t = c2;
            }
            
            t = normalize(t);
            
            b = cross(n, t);
            b = normalize(b);
            
            t = vNormalMatrix * t;
            b = vNormalMatrix * b;
            n = vNormalMatrix * n;
            
            lightVec.x = dot(vLightPosition.xyz, t);
            lightVec.y = dot(vLightPosition.xyz, b);
            lightVec.z = dot(vLightPosition.xyz, n);
            
            eyeVec.x = dot(-vWorldPosition.xyz, t);
            eyeVec.y = dot(-vWorldPosition.xyz, b);
            eyeVec.z = dot(-vWorldPosition.xyz, n);
        }
        
        float nDotVP = max(0.0, dot(eyeNormal, normalize(lightVec)));
        vec3 halfPlane = normalize(normalize(lightVec) - normalize(eyeVec));
        float specFactor = max(0.0, dot(halfPlane, eyeNormal));
        
        float shininess = uShininess;
        float power = (uLightType == kLightTypesDirectional)?1.0:uLightPower;
        float d = (uLightType == kLightTypesDirectional)?1.0:distance(vLightPosition, vWorldPosition);
        
        gl_FragColor =
        ((uTextured) ? texture2D(uTexture, vCoords.xy) : vec4(1.0, 1.0, 1.0, 1.0))
        *
            (
             ambientColor
             +
             (diffuseColor * lightColor * nDotVP * power / (d*d))
             +
             (specularColor * lightColor * power * pow(specFactor, shininess))
             );
        
        //shadow mapping
        float bias = 0.003;
        //cette ligne permet d'enlever l'ombre ajouté en dehors de la zone d'ombrage. Si on sort de la zone d'ombrage alors n'ajoute plus d'ombre.
        if(vSMcoords.x/vSMcoords.w > 0.0 && vSMcoords.x/vSMcoords.w < 1.0 && vSMcoords.y/vSMcoords.w > 0.0 && vSMcoords.y/vSMcoords.w < 1.0)
            if(texture2D(uTextureSM, vSMcoords.xy/vSMcoords.w).z < vSMcoords.z/vSMcoords.w - bias)
                gl_FragColor *= 0.3;
    }
}
