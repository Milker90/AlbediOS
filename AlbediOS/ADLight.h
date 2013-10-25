//
//  Light.h
//  FunQuizz
//
//  Created by Anthony on 03/04/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import "ADNode.h"

enum kLightTypes {
    kLightTypesDirectional = 1,
    kLightTypesPoint = 2
    };

@interface ADLight : ADNode

@property (nonatomic, assign) int           type;
@property (nonatomic, assign) float         power;

@property (nonatomic, assign) GLKVector4    color;
@property (nonatomic, assign) GLKVector4    directionalOffset;

@end
