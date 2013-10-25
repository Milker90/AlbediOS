//
//  Laby.m
//  FPS
//
//  Created by Anthony Pauriche on 21/02/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import "ADObject.h"

@interface ADObject ()
{    
    GLuint uNormalMatrix;
    GLuint uShininess;
    GLuint uDiffuseColor;
    GLuint uTextured;
    GLuint uTexturedNM;
    GLuint uTexture;
    GLuint uTextureNM;
}

@end

@implementation ADObject

@synthesize shininess       = _shininess;
@synthesize diffuse         = _diffuse;
@synthesize texture         = _texture;
@synthesize textureNM       = _textureNM;
@synthesize vertexArray     = _vertexArray;
@synthesize vertexBuffer    = _vertexBuffer;
@synthesize size            = _size;
@synthesize drawMode        = _drawMode;

-(id)init
{
    if(self = [super init])
    {
        _shininess = 5.0;
        _diffuse = GLKVector3Make(1.0, 1.0, 1.0);
        _texture = 0;
        _textureNM = 0;
        _vertexArray = 0;
        _vertexBuffer = 0;
        _size = 0;
        _drawMode = GL_TRIANGLES;
        
        uNormalMatrix = glGetUniformLocation([ADShaderTools tools].shader, "normalMatrix");
        uShininess = glGetUniformLocation([ADShaderTools tools].shader, "uShininess");
        uDiffuseColor = glGetUniformLocation([ADShaderTools tools].shader, "uDiffuseColor");
        uTextured = glGetUniformLocation([ADShaderTools tools].shader, "uTextured");
        uTexturedNM = glGetUniformLocation([ADShaderTools tools].shader, "uTexturedNM");
        uTexture = glGetUniformLocation([ADShaderTools tools].shader, "uTexture");
        uTextureNM = glGetUniformLocation([ADShaderTools tools].shader, "uTextureNM");
    }
    return self;
}


-(id)initWithName:(NSString*)name textureName:(NSString*)textureName tint:(GLKVector3)tint
{
    if(self = [self initWithName:name color:tint])
        _texture = [ADUtils getTextureNamed:textureName];
    return self;
}

-(id)initWithName:(NSString*)name textureName:(NSString*)textureName
{
    if(self = [self initWithName:name color:GLKVector3Make(1.0, 1.0, 1.0)])
        _texture = [ADUtils getTextureNamed:textureName];
    return self;
}

-(id)initWithName:(NSString*)name color:(GLKVector3)color
{
    if(self = [self init])
    {
        _diffuse = color;
        
        NSDictionary *dico = [ADUtils generateVertexArrayFromOBJFile:name];
        
        if(!dico)
            return nil;
        
        _size = [[dico objectForKey:@"size"] unsignedIntValue];
        _size /= 8;
        _vertexArray = [[dico objectForKey:@"vertexArray"] unsignedIntValue];
        _vertexBuffer = [[dico objectForKey:@"vertexBuffer"] unsignedIntValue];
        
        glBindVertexArrayOES(_vertexArray);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        
        GLuint shader = [ADShaderTools tools].shader;
        glEnableVertexAttribArray(glGetAttribLocation(shader, "position"));
        glVertexAttribPointer(glGetAttribLocation(shader, "position"), 3, GL_FLOAT, GL_FALSE, 32, 0);
        glEnableVertexAttribArray(glGetAttribLocation(shader, "normal"));
        glVertexAttribPointer(glGetAttribLocation(shader, "normal"), 3, GL_FLOAT, GL_FALSE, 32, (const void*)(20));
        glEnableVertexAttribArray(glGetAttribLocation(shader, "coords"));
        glVertexAttribPointer(glGetAttribLocation(shader, "coords"), 2, GL_FLOAT, GL_FALSE, 32, (const void*)(12));
        
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindVertexArrayOES(0);
    }
    return self;
}

-(void)draw
{
    [super draw];
    
    glUniformMatrix3fv(uNormalMatrix, 1, 0, GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(self.matrix), NULL).m);
    
    glUniform4fv(uDiffuseColor, 1, _diffuse.v);
    glUniform1f(uShininess, _shininess);
    
    glUniform1i(uTextured, _texture);
    glUniform1i(uTexturedNM, _textureNM);
    
    glBindVertexArrayOES(_vertexArray);
    if(_texture)
    {
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, _texture);
        glUniform1i(uTexture, 0);
    }
    if(_textureNM)
    {
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, _textureNM);
        glUniform1i(uTextureNM, 1);
    }
    glDrawArrays(_drawMode, 0, _size);
    if(_texture)
    {
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, 0);
    }
    if(_textureNM)
    {
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, 0);
    }
    glBindVertexArrayOES(0);
}

@end
