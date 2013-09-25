//
//  Shader.fsh
//  RobinSparkle
//
//  Created by Anthony on 21/01/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

precision highp float;
precision highp int;

uniform sampler2D Texture;

uniform float alpha;
uniform vec3 color;

uniform mat4 MR;

void main()
{
    gl_FragColor = vec4(color.xyz, alpha) * texture2D(Texture, (MR * vec4(gl_PointCoord.xy,0.0,1.0)).xy);
}
