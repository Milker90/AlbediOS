//
//  Light.m
//  FunQuizz
//
//  Created by Anthony on 03/04/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import "ADLight.h"

@interface ADLight ()
{
    GLuint uLightPosition;
    GLuint uLightType;
    GLuint uLightPower;
    GLuint uLightColor;
}

@end

@implementation ADLight

@synthesize type                = _type;
@synthesize power               = _power;

@synthesize color               = _color;
@synthesize directionalOffset   = _directionalOffset;

- (id)init
{
    self = [super init];
    if (self)
    {
        _type = kLightTypesDirectional;
        _power = 100.0;
        
        _color = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
        _directionalOffset = GLKVector4Make(0.0, 0.0, 0.0, 1.0);
        self.position = GLKVector4Make(0.0, 1.0, 0.0, 1.0);
    }
    return self;
}

-(void)configureUniform
{
    [super configureUniform];
    uLightPosition = glGetUniformLocation([ADShaderTools tools].shader, "uLightPosition");
    uLightType = glGetUniformLocation([ADShaderTools tools].shader, "uLightType");
    uLightPower = glGetUniformLocation([ADShaderTools tools].shader, "uLightPower");
    uLightColor = glGetUniformLocation([ADShaderTools tools].shader, "uLightColor");
}

-(void)draw
{
    glUniform4fv(uLightPosition, 1, self.position.v);
    glUniform1i(uLightType, _type);
    glUniform1f(uLightPower, _power);
    glUniform4fv(uLightColor, 1,_color.v);
}

@end
