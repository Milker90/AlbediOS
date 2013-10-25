//
//  ShaderUtils.h
//  3DEngine
//
//  Created by Anthony on 06/02/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADShaderTools : NSObject

@property (nonatomic, assign) GLuint shader;

+(ADShaderTools*)tools;

-(GLuint)getShaderNamed:(NSString*)name;
-(void)setDefaultShader:(GLuint)program;

+(GLuint)loadShaderNamed:(NSString*)name;

@end
