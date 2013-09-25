//
//  ADSphere.m
//  testPhys
//
//  Created by Anthony on 17/04/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import "ADSphere.h"

@implementation ADSphere

- (id)init
{
    self = [self initWithRadius:1.0 quality:10];
    if (self) {
    }
    return self;
}

-(id)initWithRadius:(float)radius quality:(int)quality
{
    if(self = [super init])
    {        
        self.diffuse = GLKVector3Make(1.0, 1.0, 1.0);
        
        GLuint va, vb;
        glGenVertexArraysOES(1, &va);
        glGenBuffers(1, &vb);
        self.vertexArray = va;
        self.vertexBuffer = vb;
        self.drawMode = GL_TRIANGLE_STRIP;
        
        float cx, cy, cz, r;
        int p;
        
        cx = 0.0;
        cy = 0.0;
        cz = 0.0;
        r = radius;
        p = quality;
        
        int count = 0;
        int icount = 0;
        //calcul de la taille du pointer
        for(int i = 0; i < p/2; i++)
            for(int j = 0; j <= p; j++)
                count += 8 * 2;
        
        GLfloat gSphereVertexData[count];
        //
        float theta1 = 0.0, theta2 = 0.0, theta3 = 0.0;
        float ex = 0.0f, ey = 0.0f, ez = 0.0f;
        float px = 0.0f, py = 0.0f, pz = 0.0f;
        
        if( r < 0 )
            r = -r;
        
        if( p < 0 )
            p = -p;
        
        for(int i = 0; i < p/2; ++i)
        {
            theta1 = i * (M_PI*2) / p - M_PI_2;
            theta2 = (i + 1) * (M_PI*2) / p - M_PI_2;
            
            for(int j = 0; j <= p; ++j)
            {
                theta3 = j * (M_PI*2) / p;
                
                ex = cosf(theta2) * cosf(theta3);
                ey = sinf(theta2);
                ez = cosf(theta2) * sinf(theta3);
                px = cx + r * ex;
                py = cy + r * ey;
                pz = cz + r * ez;
                
                gSphereVertexData[icount++] = px;
                gSphereVertexData[icount++] = py;
                gSphereVertexData[icount++] = pz;
                
                gSphereVertexData[icount++] = ex;
                gSphereVertexData[icount++] = ey;
                gSphereVertexData[icount++] = ez;
                
                gSphereVertexData[icount++] = -(j/(float)p);
                gSphereVertexData[icount++] = 2*(i+1)/(float)p;
                
                ex = cosf(theta1) * cosf(theta3);
                ey = sinf(theta1);
                ez = cosf(theta1) * sinf(theta3);
                px = cx + r * ex;
                py = cy + r * ey;
                pz = cz + r * ez;
                
                gSphereVertexData[icount++] = px;
                gSphereVertexData[icount++] = py;
                gSphereVertexData[icount++] = pz;
                
                gSphereVertexData[icount++] = ex;
                gSphereVertexData[icount++] = ey;
                gSphereVertexData[icount++] = ez;
                
                gSphereVertexData[icount++] = -(j/(float)p);
                gSphereVertexData[icount++] = 2*(i+1)/(float)p;
            }
        }
        
        self.size = count/8;
        
        glBindVertexArrayOES(self.vertexArray);
        glBindBuffer(GL_ARRAY_BUFFER, self.vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(gSphereVertexData), gSphereVertexData, GL_STATIC_DRAW);
        
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