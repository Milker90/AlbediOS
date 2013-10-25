//
//  Laby.h
//  FPS
//
//  Created by Anthony Pauriche on 21/02/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import "ADNode.h"

@interface ADObject : ADNode

@property (nonatomic, assign) float         shininess;
@property (nonatomic, assign) GLKVector3    diffuse;
@property (nonatomic, assign) GLuint        texture;
@property (nonatomic, assign) GLuint        textureNM;
@property (nonatomic, assign) GLuint        vertexArray;
@property (nonatomic, assign) GLuint        vertexBuffer;
@property (nonatomic, assign) GLsizei       size;
@property (nonatomic, strong) NSString      *name;
@property (nonatomic, assign) int           drawMode;
@property (nonatomic, assign) BOOL          emissive;

-(id)initWithName:(NSString*)name textureName:(NSString*)textureName tint:(GLKVector3)tint;
-(id)initWithName:(NSString*)name textureName:(NSString*)textureName;
-(id)initWithName:(NSString*)name color:(GLKVector3)color;

@end
