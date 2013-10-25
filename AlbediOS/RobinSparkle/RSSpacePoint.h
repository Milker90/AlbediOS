//
//  RSSpacePoint.h
//  RobinSparkle
//
//  Created by Anthony on 21/01/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "RSMath.h"

@interface RSSpacePoint : NSObject

@property (nonatomic, assign) GLfloat       angle;

@property (nonatomic, assign) GLKVector4    position;
@property (nonatomic, assign) GLKMatrix4    anchorMatrix;
@property (nonatomic, assign) GLKMatrix4    matrix;

-(void)update:(NSTimeInterval)timeSinceLastUpdate;
-(void)drawWithShader:(GLuint)shader;

@end
