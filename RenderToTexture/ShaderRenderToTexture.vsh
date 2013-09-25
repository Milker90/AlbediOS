//
//  Shader.vsh
//  ertztreter
//
//  Created by Anthony on 08/02/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//
precision highp float;

attribute vec4 position;

uniform mat4 O;

varying vec2 coords;

void main()
{
    mat4 bias = mat4(1.0, 0.0, 0.0, 0.0,
                    0.0, 1.0, 0.0, 0.0,
                    0.0, 0.0, 1.0, 0.0,
                    0.5, 0.5, 0.5, 1.0);
                    
    coords = vec4(bias * position).xy;
    
    gl_Position = O * position;
}
