//
//  OBJetUtils.h
//  scratchGL
//
//  Created by Anthony on 31/12/12.
//  Copyright (c) 2012 Anthony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface ADUtils : NSObject

@property (nonatomic, strong) NSMutableDictionary *objetCache;
@property (nonatomic, strong) NSMutableDictionary *textureCache;

+(ADUtils*)sharedUtils;
+(NSDictionary*)generateVertexArrayFromOBJFile:(NSString*)filename;
+(GLuint)getTextureNamed:(NSString*)name;
+(GLuint)getTextureNamed:(NSString*)name bottomLeft:(BOOL)bottomLeft;
+(void)glGenTextureAndFramebuffer:(GLuint*)t f:(GLuint*)f w:(GLsizei)w h:(GLsizei)h;
+(void)glGenDepthTextureAndFramebuffer:(GLuint*)t f:(GLuint*)f w:(GLsizei)w h:(GLsizei)h;

@end
