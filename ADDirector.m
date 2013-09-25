//
//  Director.m
//  3DEngine
//
//  Created by Anthony on 06/02/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import "ADDirector.h"

@interface ADDirector ()
{
    GLuint      _SMtexture;
    GLuint      _SMframebuffer;
    CGSize      _sizeSM;
    
    GLKMatrix4  SMP;
    float       SMQuality;
    
    GLuint      uSMEnabled;
    GLuint      uSMP;
    GLuint      uSMLV;
    GLuint      uTextureSM;
}

@end

@implementation ADDirector

@synthesize glkView                 = _glkView;

@synthesize camera                  = _camera;
@synthesize world                   = _world;
@synthesize light                   = _light;

@synthesize particleSystemEnabled   = _particleSystemEnabled;

static ADDirector *_sharedDirector = nil;

+(ADDirector *)sharedDirector
{
    if(nil == _sharedDirector)
        _sharedDirector = [[ADDirector alloc] init];
    return _sharedDirector;
}

-(id)init
{
    if(self = [super init])
    {
        _glkView = nil;
        
        _camera = nil;
        _world = nil;
        _light = nil;
        
        _particleSystemEnabled = NO;
        
        self.clearColor = GLKVector3Make(0.0, 0.0, 0.0);
        
        SMQuality = 1.0;
        
        SMP = GLKMatrix4Identity;
    }
    return self;
}

-(void)initSceneWithView:(GLKView*)glkView light:(ADLight *)light camera:(ADCamera *)camera world:(ADNode *)world
{
    glEnable(GL_DEPTH_TEST);
    
    [[ADShaderTools tools] setDefaultShader:[[ADShaderTools tools] getShaderNamed:@"Shader"]];
    
    uSMEnabled = glGetUniformLocation([ADShaderTools tools].shader, "SMEnabled");
    uSMP = glGetUniformLocation([ADShaderTools tools].shader, "SMP");
    uSMLV = glGetUniformLocation([ADShaderTools tools].shader, "SMLV");
    uTextureSM = glGetUniformLocation([ADShaderTools tools].shader, "uTextureSM");
    
    [light configureUniform];
    [camera configureUniform];
    [world configureUniform];
    
    [ADDirector sharedDirector].glkView = glkView;
    [ADDirector sharedDirector].light = light;
    [ADDirector sharedDirector].camera = camera;
    [ADDirector sharedDirector].world = world;
}

-(void)update:(NSTimeInterval)delta
{
    [_light update:delta];
    [_camera update:delta];
    [_world update:delta];
    
    if(_particleSystemEnabled)
        [[RSManager sharedManager] update:delta];
}

-(void)draw
{
    glUseProgram([ADShaderTools tools].shader);
    [self drawWithParticles:YES];
}

-(void)drawWithParticles:(BOOL)p
{
    glClearColor(self.clearColor.x, self.clearColor.y, self.clearColor.z, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [_light draw];
    [_camera draw];
    [_world draw];
    
    if(p && _particleSystemEnabled)
        [[RSManager sharedManager] draw];
}

-(void)drawWithShadow
{
    glUseProgram([ADShaderTools tools].shader);
    if(!_SMframebuffer)
        return;
    
    float SMCoefTmp = 0.0;
    
    SMCoefTmp = SMQuality;
    glBindFramebuffer(GL_FRAMEBUFFER, _SMframebuffer);
    
    glViewport(0, 0, _sizeSM.width, _sizeSM.height);
    
    GLKMatrix4 LV = GLKMatrix4Identity;
    if(_light.type == kLightTypesDirectional)
        LV = GLKMatrix4MakeLookAt(_light.x + _light.directionalOffset.x, _light.y + _light.directionalOffset.y, _light.z + _light.directionalOffset.z, _light.directionalOffset.x, _light.directionalOffset.y, _light.directionalOffset.z, 1.0, 1.0, 1.0);
    if(_light.type == kLightTypesPoint)
        LV = GLKMatrix4MakeLookAt(_light.x, _light.y, _light.z, _light.directionalOffset.x, _light.directionalOffset.y, _light.directionalOffset.z, 1.0, 1.0, 1.0);
    
    glUniform1i(uSMEnabled, 1);
    glUniformMatrix4fv(uSMP, 1, 0, SMP.m);
    glUniformMatrix4fv(uSMLV, 1, 0, LV.m);
    [[ADDirector sharedDirector] drawWithParticles:NO];
    
    if([RenderToTexture renderer].started)
        [[RenderToTexture renderer] bindCurrent];
    else
        [_glkView bindDrawable];
    
    glActiveTexture(GL_TEXTURE4);
    glBindTexture(GL_TEXTURE_2D, _SMtexture);
    glUniform1i(uTextureSM, 4);
    glUniform1i(uSMEnabled, 0);    
    [self drawWithParticles:YES];
}

-(void)initShadowMapping:(CGSize)size projection:(GLKMatrix4)projection scale:(float)scale
{
    GLsizei w,h;
    float s = [UIScreen mainScreen].scale;
    SMQuality = scale;
    w = size.width * s * SMQuality;
    h = size.height * s * SMQuality;
    _sizeSM = CGSizeMake(w, h);
    [ADUtils glGenDepthTextureAndFramebuffer:&_SMtexture f:&_SMframebuffer w:w h:h];
    SMP = projection;
}

-(void)addEmitter:(RSEmitter *)emitter
{
    [[RSManager sharedManager] addEmitter:emitter];
}

@end
