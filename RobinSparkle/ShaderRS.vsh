//
//  Shader.vsh
//  RobinSparkle
//
//  Created by Anthony on 21/01/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//
precision highp float;
precision highp int;

attribute vec4 position;

uniform mat4 M;
uniform mat4 E;
uniform mat4 P;
uniform mat4 W;

uniform float size;
uniform float scale;

void main()
{
    gl_Position = P * W * E * M * position;
    gl_PointSize = ((1.0 + (size*10.0)) * scale) / gl_Position.w;
}
