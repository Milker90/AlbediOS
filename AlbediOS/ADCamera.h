//
//  Camera.h
//  3DEngine
//
//  Created by Anthony on 06/02/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADShaderTools.h"
#import "ADNode.h"

@interface ADCamera : ADNode

@property (nonatomic, assign) GLKMatrix4 projection;

@property (nonatomic, assign) BOOL needInvert;

@end
