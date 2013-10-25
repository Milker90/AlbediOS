//
//  RenderToTexture.m
//
//  Created by Anthony
//

#import <GLKit/GLKit.h>
#import "RenderToTexture.h"
#import "ADUtils.h"
#import "ADShaderTools.h"

GLfloat square[18] =
{
    0.5f, 0.5f, 0.0f,
    -0.5f, 0.5f, 0.0f,
    0.5f, -0.5f, 0.0f,
    0.5f, -0.5f, 0.0f,
    -0.5f, 0.5f, 0.0f,
    -0.5f, -0.5f, 0.0f
};

@interface RenderToTexture ()
{
    GLuint      _vertexArray;
    GLuint      _shader;
    
    GLuint      _uO;
    GLuint      _uTexture;
    
    GLKMatrix4  _O;
    
    GLuint      _internalFramebuffer;
    GLuint      _internalTexture;
    GLuint      _currentFramebuffer;
    GLuint      _currentTexture;
    
    uint        _count;
    
    //ACTION
    //blur
    GLuint      _uActionBlurH;
    GLuint      _uActionBlurV;
    GLfloat     _uBlurSize;
    //radial blur
    GLuint      _uActionRadialBlur;
    //sepia
    GLuint      _uActionSepia;
}

@end

@implementation RenderToTexture

@synthesize started     = _started;
@synthesize size        = _size;
@synthesize framebuffer = _framebuffer;
@synthesize texture     = _texture;

static RenderToTexture *_renderer = nil;
+(RenderToTexture *)renderer
{
    if(_renderer == nil)
        _renderer = [[RenderToTexture alloc] init];
    return _renderer;
}

-(id)init
{
    if(self = [super init])
    {
        _started = NO;
        
        _shader = [[ADShaderTools tools] getShaderNamed:@"ShaderRenderToTexture"];
        
        glGenVertexArraysOES(1, &_vertexArray);
        glBindVertexArrayOES(_vertexArray);
        
        GLuint b;
        glGenBuffers(1, &b);
        glBindBuffer(GL_ARRAY_BUFFER, b);
        glBufferData(GL_ARRAY_BUFFER, sizeof(square), square, GL_STATIC_DRAW);        
        
        glEnableVertexAttribArray(glGetAttribLocation(_shader, "position"));
        glVertexAttribPointer(glGetAttribLocation(_shader, "position"), 3, GL_FLOAT, GL_FALSE, 12, 0);
        
        glBindVertexArrayOES(0);
        
        _O = GLKMatrix4MakeOrtho(-0.5, 0.5, -0.5, 0.5, -0.5, 0.5);
        _uO = glGetUniformLocation(_shader, "O");
        _uTexture = glGetUniformLocation(_shader, "texture");
        
        _count = 0;
        
        _size = CGSizeMake(0.0, 0.0);
        
        // ACTIONS uniforms
        //blur
        _uActionBlurH = glGetUniformLocation(_shader, "actionBlurH");
        _uActionBlurV = glGetUniformLocation(_shader, "actionBlurV");
        _uBlurSize = glGetUniformLocation(_shader, "blurSize");
        //radial blur
        _uActionRadialBlur = glGetUniformLocation(_shader, "actionRadialBlur");
        //sepia
        _uActionSepia = glGetUniformLocation(_shader, "actionSepia");
        
    }
    return self;
}

-(void)generateFBOWithSize:(CGSize)size scale:(float)scale
{
    if(_texture)
        glDeleteTextures(1, &_texture);
    if(_framebuffer)
        glDeleteFramebuffers(1, &_framebuffer);
    
    float s = [UIScreen mainScreen].scale;
    
    GLsizei w = scale * s * size.width;
    GLsizei h = scale * s * size.height;
    
    _size = CGSizeMake(w, h);
    
    glGenTextures(1, &_texture);
    glBindTexture(GL_TEXTURE_2D, _texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
    GLuint db;
    glGenRenderbuffers(1, &db);
    glBindRenderbuffer(GL_RENDERBUFFER, db);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, w, h);
    
    glGenFramebuffers(1, &_framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _texture, 0);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, db);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if(status != GL_FRAMEBUFFER_COMPLETE)
        NSLog(@"Framebuffer status: %x", (int)status);
    
    /*
    INTERNAL FBO FOR POST PROCESSING MANIPULATION
    */
    glGenTextures(1, &_internalTexture);
    glBindTexture(GL_TEXTURE_2D, _internalTexture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
    glGenRenderbuffers(1, &db);
    glBindRenderbuffer(GL_RENDERBUFFER, db);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, w, h);
    
    glGenFramebuffers(1, &_internalFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _internalFramebuffer);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _internalTexture, 0);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, db);
    
    status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if(status != GL_FRAMEBUFFER_COMPLETE)
        NSLog(@"Framebuffer status: %x", (int)status);
    
    NSLog(@"FBO(%d) with texture(%d) generated with size : %d %d", _framebuffer, _texture, w, h);
}

-(void)start
{
    _started = YES;
    _count = 0;
    [self bind];
}

-(void)render:(GLKView *)view
{
    [self swap];
    
    _started = NO;
    [view bindDrawable];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glUseProgram(_shader);
    [self noAction];
    
    [self draw];
}

-(void)bind
{
    [self swap];
    
    glBindFramebuffer(GL_FRAMEBUFFER, _currentFramebuffer);
    
    glViewport(0, 0, _size.width, _size.height);
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glUseProgram(_shader);
}

-(void)bindCurrent
{
    glBindFramebuffer(GL_FRAMEBUFFER, _currentFramebuffer);
    glViewport(0, 0, _size.width, _size.height);
}

-(void)draw
{
    glUniformMatrix4fv(_uO, 1, 0, _O.m);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _currentTexture);
    glUniform1i(_uTexture, 0);
    
    glBindVertexArrayOES(_vertexArray);
    glDrawArrays(GL_TRIANGLES, 0, 6);
    glBindVertexArrayOES(0);
}

-(void)blur:(float)offset
{
    [self bind];
    
    glUniform1f(_uBlurSize, (GLfloat)(1.0 / offset));
    
    [self noAction];
    glUniform1i(_uActionBlurH, YES);
    
    [self draw];
    
    [self bind];
    
    [self noAction];
    glUniform1i(_uActionBlurV, YES);
    
    [self draw];
}

-(void)sepia
{
    [self bind];
    
    [self noAction];
    glUniform1i(_uActionSepia, YES);
    
    [self draw];
}

-(void)radialBlur
{
    [self bind];
    
    [self noAction];
    glUniform1i(_uActionRadialBlur, YES);
    
    [self draw];
}

-(void)noAction
{
    glUniform1i(_uActionBlurH, NO);
    glUniform1i(_uActionBlurV, NO);
    glUniform1i(_uActionSepia, NO);
    glUniform1i(_uActionRadialBlur, NO);
}

-(void)swap
{
    if(_count++ % 2 == 0)
    {
        _currentFramebuffer = _framebuffer;
        _currentTexture = _internalTexture;
    }
    else
    {
        _currentFramebuffer = _internalFramebuffer;
        _currentTexture = _texture;
    }
}

-(GLuint)framebuffer
{
    return _currentFramebuffer;
}

@end
