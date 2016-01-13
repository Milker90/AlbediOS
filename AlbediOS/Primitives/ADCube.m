//
//  Cube.m
//  FunQuizz
//
//  Created by Anthony on 05/04/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

@import OpenGLES;

#import "ADCube.h"

GLfloat gCubeVertexData[288] =
{
    // Data layout for each line below is:
    // positionX, positionY, positionZ,     normalX, normalY, normalZ,
    0.5f, -0.5f, -0.5f,        1.0f, 0.0f, 0.0f,    1,0,
    0.5f, 0.5f, -0.5f,         1.0f, 0.0f, 0.0f,    1,1,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,    0,0,
    0.5f, -0.5f, 0.5f,         1.0f, 0.0f, 0.0f,    0,0,
    0.5f, 0.5f, -0.5f,          1.0f, 0.0f, 0.0f,   1,1,
    0.5f, 0.5f, 0.5f,         1.0f, 0.0f, 0.0f,     0,1,
    
    0.5f, 0.5f, -0.5f,         0.0f, 1.0f, 0.0f,    1,1,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,    0,1,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,    1,0,
    0.5f, 0.5f, 0.5f,          0.0f, 1.0f, 0.0f,    1,0,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,    0,1,
    -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,    0,0,
    
    -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,   0,1,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,   0,0,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,   1,1,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,   1,1,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,   0,0,
    -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,   1,0,
    
    -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,   1,0,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,   0,0,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,   1,1,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,   1,1,
    0.5f, -0.5f, -0.5f,        0.0f, -1.0f, 0.0f,   0,0,
    0.5f, -0.5f, 0.5f,         0.0f, -1.0f, 0.0f,   0,1,
    
    0.5f, 0.5f, 0.5f,          0.0f, 0.0f, 1.0f,    1,1,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,    0,1,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,    1,0,
    0.5f, -0.5f, 0.5f,         0.0f, 0.0f, 1.0f,    1,0,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,    0,1,
    -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,    0,0,
    
    0.5f, -0.5f, -0.5f,        0.0f, 0.0f, -1.0f,   0,0,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,   1,0,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,   0,1,
    0.5f, 0.5f, -0.5f,         0.0f, 0.0f, -1.0f,   0,1,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,   1,0,
    -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f,   1,1
};

@implementation ADCube

-(id)init
{
    if(self = [super init])
    {
        self.diffuse = GLKVector3Make(1.0, 1.0, 1.0);
        
        GLuint va, vb;
        glGenVertexArraysOES(1, &va);
        glGenBuffers(1, &vb);
        self.vertexArray = va;
        self.vertexBuffer = vb;        
        self.size = 36;
        
        glBindVertexArrayOES(self.vertexArray);
        glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW);
        
        GLuint shader = [ADShaderTools tools].shader;
        glEnableVertexAttribArray(glGetAttribLocation(shader, "position"));
        glVertexAttribPointer(glGetAttribLocation(shader, "position"), 3, GL_FLOAT, GL_FALSE, 32, 0);
        glEnableVertexAttribArray(glGetAttribLocation(shader, "normal"));
        glVertexAttribPointer(glGetAttribLocation(shader, "normal"), 3, GL_FLOAT, GL_FALSE, 32, (const void*)(12));
        glEnableVertexAttribArray(glGetAttribLocation(shader, "coords"));
        glVertexAttribPointer(glGetAttribLocation(shader, "coords"), 2, GL_FLOAT, GL_FALSE, 32, (const void*)(24));
        
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindVertexArrayOES(0);
    }
    return self;
}

@end
