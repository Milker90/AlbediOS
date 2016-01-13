//
//  RSEmitter.m
//  RobinSparkle
//
//  Created by Anthony on 21/01/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import "RSEmitter.h"
#import "ADUtils.h"

@interface RSEmitter ()
{
    NSMutableArray *_particles;
    NSMutableArray *arrayToRemove;
    NSTimeInterval _timeToAdd;
    NSTimeInterval _timeToCheck;
    
    uint _count;
    BOOL _finished;
}

@end

@implementation RSEmitter

@synthesize active      = _active;

@synthesize name        = _name;

@synthesize texture     = _texture;

@synthesize particle    = _particle;

-(id)init
{
    if(self = [super init])
    {
        _name = @"";
        
        _active = YES;
        
        _count = 0;
        
        _texture = 0;
        
        _particle = nil;
        
        _finished = NO;
        
        _particles = [NSMutableArray array];
        
        arrayToRemove = [NSMutableArray array];
    }
    return self;
}

-(id)initWithParticle:(RSParticle*)particle
{
    if(self = [self init])
    {
        _particle = particle;
        _timeToAdd = 1.0 / (_particle.debit / _particle.time);
        _timeToCheck = 0.0;
        
        self.texture = [ADUtils getTextureNamed:_particle.textureName];
    }
    return self;
}

-(void)addParticle
{
    if(!_particle.loop && _count > _particle.debit)
        _finished = YES;
    
    if(_finished)
        return;
    
    _count++;
    RSParticle *p = [[[_particle class] alloc] init];
    p.startMatrix = self.matrix;
    [_particles addObject:p];
}

-(void)update:(NSTimeInterval)timeSinceLastUpdate
{
    _timeToCheck += timeSinceLastUpdate;
    if(_timeToCheck > _timeToAdd)
    {
        for (uint i = 0; i <= floor(_timeToCheck / _timeToAdd); i++)
            [self addParticle];
        _timeToCheck = 0.0;
    }
    
    for (RSParticle *particle in _particles) {
        if(!particle.active)
        {
            [arrayToRemove addObject:particle];
            continue;
        }
        [particle update:timeSinceLastUpdate];
    }
    if(arrayToRemove.count)
    {
        [_particles removeObjectsInArray:arrayToRemove];
        [arrayToRemove removeAllObjects];
    }
    
    if(_finished && _particles.count == 0)
        self.active = NO;
}

-(void)clean
{
    _finished = YES;
}

-(void)drawWithShader:(GLuint)shader
{
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texture);
    glUniform1i(glGetUniformLocation(shader, "Texture"), 0);
    glUniformMatrix4fv(glGetUniformLocation(shader, "E"), 1, 0, self.matrix.m);
    for (RSParticle *particle in _particles) {
        [particle drawWithShader:shader];
    }
    glBindTexture(GL_TEXTURE_2D, 0);
}

@end
