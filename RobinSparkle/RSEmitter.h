//
//  RSEmitter.h
//  RobinSparkle
//
//  Created by Anthony on 21/01/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import "RSSpacePoint.h"
#import "RSParticle.h"

@interface RSEmitter : RSSpacePoint

@property (nonatomic, assign) BOOL          active;

@property (nonatomic, strong) NSString      *name;

@property (nonatomic, assign) GLuint        texture;

@property (nonatomic, strong) RSParticle    *particle;

-(void)addParticle;
-(void)clean;
-(id)initWithParticle:(RSParticle*)particle;

@end
