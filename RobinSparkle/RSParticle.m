//
//  RSParticle.m
//  RobinSparkle
//
//  Created by Anthony on 21/01/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import "RSParticle.h"
#import "RSManager.h"

@implementation RSParticle
{
    float _currentLife;
    
    GLuint uM;
    GLuint uMR;
    GLuint uE;
    GLuint uAlpha;
    GLuint uSize;
    GLuint uColor;
}

@synthesize life            = _life;
@synthesize startSize       = _startSize;
@synthesize endSize         = _endSize;
@synthesize alpha           = _alpha;
@synthesize angleSpeed      = _angleSpeed;
@synthesize acceleration    = _acceleration;

@synthesize time            = _time;
@synthesize debit           = _debit;
@synthesize loop            = _loop;

@synthesize textureName     = _textureName;

@synthesize active          = _active;
@synthesize relative        = _relative;

@synthesize startColor  	= _startColor;
@synthesize endColor    	= _endColor;
@synthesize direction   	= _direction;

@synthesize startMatrix 	= _startMatrix;

-(id)init
{
    if(self = [super init])
    {
        uM = 0;
        uMR = 0;
        uE = 0;
        uAlpha = 0;
        uSize = 0;
        uColor = 0;
        
        _life = 0.0;
        _startSize = 0.0;
        _endSize = 0.0;
        _alpha = 1.0;
        _angleSpeed = 0.0;
        _acceleration = 1.0;
        
        _time = 1.0;
        _debit = 0.0;
        _loop = YES;
        
        _textureName = @"";
        
        _active = YES;
        _relative = NO;
        
        _startColor = GLKVector3Make(0.0, 0.0, 0.0);
        _endColor = GLKVector3Make(0.0, 0.0, 0.0);
        
        _direction = GLKVector4Make(0.0, 0.0, 0.0, 0.0);
        
        _startMatrix = GLKMatrix4Identity;
        
        GLuint shader = [RSManager sharedManager].shader;
        uM = glGetUniformLocation(shader, "M");
        uMR = glGetUniformLocation(shader, "MR");
        uE = glGetUniformLocation(shader, "E");
        uAlpha = glGetUniformLocation(shader, "alpha");
        uSize = glGetUniformLocation(shader, "size");
        uColor = glGetUniformLocation(shader, "color");
    }
    return self;
}

-(void)update:(NSTimeInterval)timeSinceLastUpdate
{
    if(!_active)
        return;
    
    _currentLife += timeSinceLastUpdate;
    if(_currentLife > _life)
    {
        _active = NO;
        _currentLife = _life;
    }
    float coef = 1.0 - _currentLife / _life;
    _alpha = coef;
    self.position = GLKVector4Add(self.position, GLKVector4MultiplyScalar(_direction, timeSinceLastUpdate * _acceleration));
    self.angle += _angleSpeed * timeSinceLastUpdate;
}

-(void)drawWithShader:(GLuint)shader
{
    if(!_active)
        return;
    
    glUniformMatrix4fv(uM, 1, 0, self.matrix.m);
    
    GLKMatrix4 matrixRotationTexture = GLKMatrix4Identity;
    matrixRotationTexture = GLKMatrix4Translate(matrixRotationTexture, 0.5, 0.5, 0.0);
    matrixRotationTexture = GLKMatrix4Rotate(matrixRotationTexture, GLKMathDegreesToRadians(self.angle), 0.0, 0.0, 1.0);
    matrixRotationTexture = GLKMatrix4Translate(matrixRotationTexture, -0.5, -0.5, 0.0);
    glUniformMatrix4fv(uMR, 1, 0, matrixRotationTexture.m);
    
    if(_relative)
        glUniformMatrix4fv(uE, 1, 0, _startMatrix.m);
    else
        glUniformMatrix4fv(uE, 1, 0, GLKMatrix4Identity.m);
    
    glUniform1f(uAlpha, _alpha);
    
    float coef = 1.0 - _currentLife / _life;
    float coefi = _currentLife / _life;
    float size = _startSize * coef + _endSize * coefi;
    glUniform1f(uSize, size);
    
    GLKVector3 color = GLKVector3Add(GLKVector3MultiplyScalar(_startColor, coef), GLKVector3MultiplyScalar(_endColor, coefi));
    glUniform3fv(uColor, 1, color.v);
    
    glDrawArrays(GL_POINTS, 0, 1);
}

@end
