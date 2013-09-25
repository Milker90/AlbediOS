//
//  Director.h
//  3DEngine
//
//  Created by Anthony on 06/02/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "ADUtils.h"
#import "ADShaderTools.h"
#import "ADCamera.h"
#import "ADNode.h"
#import "ADObject.h"
#import "ADLight.h"
#import "ADUtils.h"
#import "RSManager.h"
#import "RenderToTexture.h"

#import "ADCube.h"
#import "ADSphere.h"
#import "ADPlane.h"

@interface ADDirector : NSObject

@property (nonatomic, strong) GLKView       *glkView;

@property (nonatomic, strong) ADCamera      *camera;
@property (nonatomic, strong) ADNode        *world;
@property (nonatomic, strong) ADLight       *light;

@property (nonatomic, assign) BOOL          debugSM;

@property (nonatomic, assign) GLKVector3    clearColor;

@property (nonatomic, assign) BOOL          particleSystemEnabled;

+(ADDirector*)sharedDirector;

-(void)update:(NSTimeInterval)delta;
-(void)draw;

//init a scene
-(void)initSceneWithView:(GLKView*)glkView light:(ADLight *)light camera:(ADCamera *)camera world:(ADNode *)world;

//particles
-(void)addEmitter:(RSEmitter*)emitter;

//shadow mapping
-(void)drawWithShadow;
-(void)initShadowMapping:(CGSize)size projection:(GLKMatrix4)projection scale:(float)scale;

@end
