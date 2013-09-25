//
//  RSManager.h
//  RobinSparkle
//
//  Created by Anthony on 21/01/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSEmitter.h"
#import "RSMath.h"

@interface RSManager : NSObject

@property (nonatomic, assign) GLuint shader;

@property (nonatomic, assign) float  scale;

@property (nonatomic, assign) GLuint uP;
@property (nonatomic, assign) GLuint uW;
@property (nonatomic, assign) GLuint uScale;

-(void)update:(NSTimeInterval)timeSinceLastUpdate;
-(void)draw;

-(void)addEmitter:(RSEmitter*)emitter;
-(RSEmitter*)getEmitterWithName:(NSString*)name;

+(RSManager*)sharedManager;

@end
