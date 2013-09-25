//
//  RSParticle.h
//  RobinSparkle
//
//  Created by Anthony on 21/01/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

/*

Exemple de particule

-(id)init
{
    if(self = [super init])
    {
        self.startSize = 20 + arc4random() % 5;
        self.endSize = self.startSize * 0.5;
        self.life = RAND_BETWEEN(0.8, 0.9);
        
        self.debit = 30.0;
        self.loop = YES;
        
        self.active = YES;
        self.relative = YES;
        
        self.angleSpeed = 45.0;
        
        self.startColor = GLKVector3Make(0.2, 0.2, 0.8);
        self.endColor = GLKVector3Make(0.0, 0.0, 0.5);
        
        self.direction = GLKVector4Make(0.0, 0.0, 0.0, 1.0);
        
        self.acceleration = 0.4;
        
        self.textureName = @"texture.png";
    }
    return self;
}
*/

#import "RSSpacePoint.h"

@interface RSParticle : RSSpacePoint

@property (nonatomic, assign) float         life;
@property (nonatomic, assign) float         startSize;
@property (nonatomic, assign) float         endSize;
@property (nonatomic, assign) float         alpha;
@property (nonatomic, assign) float         angleSpeed;
@property (nonatomic, assign) float         acceleration;

@property (nonatomic, assign) float         time;
@property (nonatomic, assign) float         debit;
@property (nonatomic, assign) BOOL          loop;

@property (nonatomic, strong) NSString      *textureName;

@property (nonatomic, assign) BOOL          active;
@property (nonatomic, assign) BOOL          relative;

@property (nonatomic, assign) GLKVector3    startColor;
@property (nonatomic, assign) GLKVector3    endColor;
@property (nonatomic, assign) GLKVector4    direction;

@property (nonatomic, assign) GLKMatrix4    startMatrix;

@end
