//
//  ADPlane.m
//  testPhys
//
//  Created by Anthony on 18/04/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import "ADPlane.h"

@implementation ADPlane

- (id)init
{
    self = [self initWithQuality:1];
    if (self) {
    }
    return self;
}

-(id)initWithQuality:(int)quality
{
    if(self = [super init])
    {
        self.diffuse = GLKVector3Make(1.0, 1.0, 1.0);
        
        GLuint va, vb;
        glGenVertexArraysOES(1, &va);
        glGenBuffers(1, &vb);
        self.vertexArray = va;
        self.vertexBuffer = vb;
        
        uint division = quality;
        uint count = 0;
        GLfloat gPlaneVertexData[8 * 6 * (int)powf(division, 2)];
        
        for (uint j = 0; j < division; j++)
        {
            for (uint i = 0; i < division; i++)
            {
                for (uint vertex = 1; vertex <= 6; vertex++)
                {
                    float x, y, z, d;
                    d = 1.0 / division;
                    float u, v;
                    
                    if(vertex == 1 || vertex == 5 || vertex == 6)
                    {
                        x = i * d;
                        u = 0;
                    }
                    else
                    {
                        x = i * d + d;
                        u = 1;
                    }
                    
                    if(vertex == 1 || vertex == 2 || vertex == 6)
                    {
                        y = j * d;
                        v = 0;
                    }
                    else
                    {
                        y = j * d + d;
                        v = 1;
                    }
                    
                    z = 0.0;
                    
                    gPlaneVertexData[count++] = -0.5 + x;    //X
                    gPlaneVertexData[count++] = -0.5 + y;    //Y
                    gPlaneVertexData[count++] = z;           //Z
                    
                    gPlaneVertexData[count++] = 0.0;         //NX
                    gPlaneVertexData[count++] = 0.0;         //NY
                    gPlaneVertexData[count++] = 1.0;         //NZ
                    
                    gPlaneVertexData[count++] = u;//x;       //U
                    gPlaneVertexData[count++] = v;//y;       //V
                }
            }
        }
        
        self.size = 6 * (int)powf(division, 2);
        
        glBindVertexArrayOES(self.vertexArray);
        glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(gPlaneVertexData), gPlaneVertexData, GL_STATIC_DRAW);
        
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