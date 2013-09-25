//
//  RSManager.m
//  RobinSparkle
//
//  Created by Anthony on 21/01/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import "RSManager.h"
#import "ADShaderTools.h"
#import "ADDirector.h"

GLfloat pointSpriteData[3] =
{
    0.0, 0.0, 0.0
};

@interface RSManager ()
{
    NSMutableArray *_emitters;
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    NSMutableArray *arrayToRemove;
}

@end

@implementation RSManager

@synthesize shader  = _shader;

@synthesize scale   = _scale;

@synthesize uP      = _uP;
@synthesize uW      = _uW;
@synthesize uScale  = _uScale;

static RSManager *_sharedManager = nil;

+(RSManager*)sharedManager
{
    if(_sharedManager == nil)
        _sharedManager = [[RSManager alloc] init];
    return _sharedManager;
}

-(id)init
{
    if(self = [super init])
    {
        _shader = [[ADShaderTools tools] getShaderNamed:@"ShaderRS"];
        
        _scale = 1.0;
        
        _uP = glGetUniformLocation(_shader, "P");
        _uW = glGetUniformLocation(_shader, "W");
        _uScale = glGetUniformLocation(_shader, "scale");
        
        _emitters = [NSMutableArray array];
        
        arrayToRemove = [NSMutableArray array];
        
        glGenVertexArraysOES(1, &_vertexArray);
        glBindVertexArrayOES(_vertexArray);
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(pointSpriteData), pointSpriteData, GL_STATIC_DRAW);
        glEnableVertexAttribArray(glGetAttribLocation(_shader, "position"));
        glVertexAttribPointer(glGetAttribLocation(_shader, "position"), 3, GL_FLOAT, GL_FALSE, 0, 0);
        glBindVertexArrayOES(0);
    }
    return self;
}

-(void)addEmitter:(RSEmitter*)emitter
{
    [_emitters addObject:emitter];
}

-(RSEmitter*)getEmitterWithName:(NSString*)name
{
    for (RSEmitter *e in _emitters) {
        if(e.name == name)
            return e;
    }
    return nil;
}

-(void)update:(NSTimeInterval)timeSinceLastUpdate
{
    for (RSEmitter *emitter in _emitters) {
        if(!emitter.active)
        {
            [arrayToRemove addObject:emitter];
            continue;
        }
        [emitter update:timeSinceLastUpdate];
    }
    if(arrayToRemove.count > 0)
    {
        [_emitters removeObjectsInArray:arrayToRemove];
        [arrayToRemove removeAllObjects];
    }
}

-(void)draw
{
    glUseProgram([RSManager sharedManager].shader);
    glUniform1f([RSManager sharedManager].uScale, _scale);
    glUniformMatrix4fv([RSManager sharedManager].uP, 1, 0, [ADDirector sharedDirector].camera.projection.m);
    if([ADDirector sharedDirector].camera.needInvert)
        glUniformMatrix4fv([RSManager sharedManager].uW, 1, 0, GLKMatrix4Invert([ADDirector sharedDirector].camera.matrix, NULL).m);
    else
        glUniformMatrix4fv([RSManager sharedManager].uW, 1, 0, [ADDirector sharedDirector].camera.matrix.m);
    
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
    glDepthMask(GL_FALSE);
    
    glBindVertexArrayOES(_vertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    for (RSEmitter *emitter in _emitters)
    {
        [emitter drawWithShader:_shader];
    }
    glBindVertexArrayOES(0);
    
    glDepthMask(GL_TRUE);
    glDisable(GL_BLEND);
}

@end
