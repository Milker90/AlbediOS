//
//  Node.h
//  3DEngine
//
//  Created by Anthony on 06/02/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "ADShaderTools.h"
#import "ADUtils.h"

enum kRotationMode {
    kRotationModeEuler,
    kRotationModeQuaternion
};

@interface ADNode : NSObject

@property (nonatomic, assign) BOOL              dynamic;

@property (nonatomic, assign) ADNode            *parent;

@property (nonatomic, assign) GLfloat           x;
@property (nonatomic, assign) GLfloat           y;
@property (nonatomic, assign) GLfloat           z;
@property (nonatomic, assign) int               rotationMode;
@property (nonatomic, assign) GLKQuaternion     rotation;
@property (nonatomic, assign) GLfloat           rotationX;
@property (nonatomic, assign) GLfloat           rotationY;
@property (nonatomic, assign) GLfloat           rotationZ;
@property (nonatomic, assign) GLfloat           scaleX;
@property (nonatomic, assign) GLfloat           scaleY;
@property (nonatomic, assign) GLfloat           scaleZ;
@property (nonatomic, assign) GLfloat           scale;

@property (nonatomic, strong) NSString          *name;

@property (nonatomic, assign) GLKVector4        position;

@property (nonatomic, assign) GLKMatrix4        matrix;

@property (nonatomic, strong) NSMutableArray    *children;

-(void)update:(NSTimeInterval)delta;
-(void)draw;

-(void)addNode:(ADNode*)node;
-(void)removeNode:(ADNode*)node;

-(void)computeMatrix;

-(void)moveForward:(float)speed;

-(void)configureUniform;

+(ADNode*)node;

@end
