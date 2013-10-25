//
//  RSSpacePoint.m
//  RobinSparkle
//
//  Created by Anthony on 21/01/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import "RSSpacePoint.h"

@implementation RSSpacePoint

@synthesize angle           = _angle;

@synthesize position        = _position;
@synthesize anchorMatrix    = _anchorMatrix;
@synthesize matrix          = _matrix;

-(id)init
{
    if(self = [super init])
    {
        _angle = 0.0;
        
        _position = GLKVector4Make(0.0, 0.0, 0.0, 1.0);
        _matrix = GLKMatrix4Identity;
        _anchorMatrix = GLKMatrix4Identity;
    }
    return self;
}

-(void)update:(NSTimeInterval)timeSinceLastUpdate
{
}

-(void)drawWithShader:(GLuint)shader
{
}

-(GLKMatrix4)matrix
{
    _matrix = GLKMatrix4Identity;
    _matrix = GLKMatrix4Multiply(GLKMatrix4MakeRotation(GLKMathDegreesToRadians(_angle), 0.0, 0.0, 1.0), _matrix);
    _matrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(_position.x, _position.y, _position.z), _matrix);
    _matrix = GLKMatrix4Multiply(_anchorMatrix, _matrix);
    return _matrix;
}

@end
