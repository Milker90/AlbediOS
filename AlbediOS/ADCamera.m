//
//  Camera.m
//  3DEngine
//
//  Created by Anthony on 06/02/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import "ADCamera.h"

@interface ADCamera ()
{
    GLuint uV;
    GLuint uP;
}

@end

@implementation ADCamera

@synthesize projection = _projection;

@synthesize needInvert = _needInvert;

-(id)init
{
    if(self = [super  init])
    {
        _projection = GLKMatrix4Identity;
        
        _needInvert = YES;
    }
    return self;
}

-(void)setDynamic:(BOOL)dynamic
{
    [super setDynamic:dynamic];
    
    if(self.dynamic)
        _needInvert = YES;
    else
        _needInvert = NO;
}

-(void)configureUniform
{
    [super configureUniform];
    uV = glGetUniformLocation([ADShaderTools tools].shader, "V");
    uP = glGetUniformLocation([ADShaderTools tools].shader, "P");
}

-(void)draw
{
    if(_needInvert)
        glUniformMatrix4fv(uV, 1, 0, GLKMatrix4Invert(self.matrix, NULL).m);
    else
        glUniformMatrix4fv(uV, 1, 0, self.matrix.m);
    
    glUniformMatrix4fv(uP, 1, 0, _projection.m);
}

@end
