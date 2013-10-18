//
//  OBJetUtils.m
//  scratchGL
//
//  Created by Anthony on 31/12/12.
//  Copyright (c) 2012 Anthony. All rights reserved.
//

#import "ADUtils.h"

@implementation ADUtils

@synthesize objetCache=_objetCache;
@synthesize textureCache=_textureCache;

static ADUtils *_sharedUtils = nil;

-(id)init
{
    if(self = [super init])
    {
        _objetCache = [NSMutableDictionary dictionary];
        _textureCache = [NSMutableDictionary dictionary];
    }
    return self;
}

+(ADUtils*)sharedUtils
{
    if(_sharedUtils == nil)
    {
        _sharedUtils = [[ADUtils alloc] init];
    }
    return _sharedUtils;
}

+(NSDictionary*)generateVertexArrayFromOBJFile:(NSString*)filename
{
    NSMutableDictionary *cache = [[ADUtils sharedUtils].objetCache objectForKey:filename];
    if(cache)
    {
        NSLog(@"cache detected for OBJFile: %@", filename);
        return cache;
    }
    
    BOOL withUV = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    NSError *error;
    NSString *data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if(!error)
    {
        NSMutableArray *vertex = [NSMutableArray array];
        NSMutableArray *uv = [NSMutableArray array];
        NSMutableArray *normal = [NSMutableArray array];
        NSMutableArray *face = [NSMutableArray array];
        
        NSArray *lines = [data componentsSeparatedByString:@"\n"];
        
        for (NSString *line in lines)
        {
            //NSLog(@"%@", line);//DEBUG
            
            NSArray *list = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(list.count > 1)
                list = [list filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
            
            NSString *type = [list objectAtIndex:0];
            
            if([type isEqualToString:@"v"])//vertex (X, Y, Z)
            {
                NSString *x = [list objectAtIndex:1];
                NSString *y = [list objectAtIndex:2];
                NSString *z = [list objectAtIndex:3];
                NSArray *v = [NSArray arrayWithObjects:x, y, z, nil];
                [vertex addObject:v];
            }
            if([type isEqualToString:@"vt"])//vertex texture (U, V)
            {
                NSString *u = [list objectAtIndex:1];
                NSString *v = [list objectAtIndex:2];
                NSArray *vt = [NSArray arrayWithObjects:u, v, nil];
                [uv addObject:vt];
            }
            if([type isEqualToString:@"vn"])//vertex normal (X, Y, Z)
            {
                NSString *x = [list objectAtIndex:1];
                NSString *y = [list objectAtIndex:2];
                NSString *z = [list objectAtIndex:3];
                NSArray *vn = [NSArray arrayWithObjects:x, y, z, nil];
                [normal addObject:vn];
            }
            if([type isEqualToString:@"f"])//faces (V1, V2, V3)
            {
                //       LIST 1        LIST 2        LIST 3
                // f iv1/ivt1/ivn1 iv2/ivt2/ivn2 iv3/ivt3/ivn3
                NSArray *v1List = [[list objectAtIndex:1] componentsSeparatedByString:@"/"];
                NSArray *v2List = [[list objectAtIndex:2] componentsSeparatedByString:@"/"];
                NSArray *v3List = [[list objectAtIndex:3] componentsSeparatedByString:@"/"];
                
                NSString *iv1 = [v1List objectAtIndex:0];
                NSString *ivt1 = [v1List objectAtIndex:1];
                NSString *ivn1 = [v1List objectAtIndex:2];
                
                NSString *iv2 = [v2List objectAtIndex:0];
                NSString *ivt2 = [v2List objectAtIndex:1];
                NSString *ivn2 = [v2List objectAtIndex:2];
                
                NSString *iv3 = [v3List objectAtIndex:0];
                NSString *ivt3 = [v3List objectAtIndex:1];
                NSString *ivn3 = [v3List objectAtIndex:2];
                
                NSArray *f = [NSArray arrayWithObjects:iv1, ivt1, ivn1, iv2, ivt2, ivn2, iv3, ivt3, ivn3, nil];
                [face addObject:f];
                
                //dans le cas de f v//vn
                if(uv.count == 0)
                    withUV = NO;
            }
        }
        
        int i = 0;
        int floatCount = (int)face.count * ((3 + 2 + 3) * 3);
        GLfloat *vertexData = (GLfloat*)malloc(sizeof(GLfloat)*floatCount);
        
        for (NSArray *a in face)
        {
            int iv1 = [[a objectAtIndex:0] intValue] - 1;
            int ivt1 = [[a objectAtIndex:1] intValue] - 1;
            int ivn1 = [[a objectAtIndex:2] intValue] - 1;
            
            int iv2 = [[a objectAtIndex:3] intValue] - 1;
            int ivt2 = [[a objectAtIndex:4] intValue] - 1;
            int ivn2 = [[a objectAtIndex:5] intValue] - 1;
            
            int iv3 = [[a objectAtIndex:6] intValue] - 1;
            int ivt3 = [[a objectAtIndex:7] intValue] - 1;
            int ivn3 = [[a objectAtIndex:8] intValue] - 1;
            
            NSArray *v1 = [vertex objectAtIndex:iv1];
            NSArray *vn1 = [normal objectAtIndex:ivn1];
            
            NSArray *v2 = [vertex objectAtIndex:iv2];
            NSArray *vn2 = [normal objectAtIndex:ivn2];
            
            NSArray *v3 = [vertex objectAtIndex:iv3];
            NSArray *vn3 = [normal objectAtIndex:ivn3];
            
            NSArray *vt1;
            NSArray *vt2;
            NSArray *vt3;
            if(withUV)
            {
                vt1 = [uv objectAtIndex:ivt1];
                vt2 = [uv objectAtIndex:ivt2];
                vt3 = [uv objectAtIndex:ivt3];
            }
            else
            {
                NSString *u = @"0";
                NSString *v = @"0";
                NSArray *tmp = [NSArray arrayWithObjects:u, v, nil];
                vt1 = tmp;
                vt2 = tmp;
                vt3 = tmp;
            }
            
            //v1
            vertexData[i++] = [[v1 objectAtIndex:0] floatValue];
            vertexData[i++] = [[v1 objectAtIndex:1] floatValue];
            vertexData[i++] = [[v1 objectAtIndex:2] floatValue];
            
            vertexData[i++] = [[vt1 objectAtIndex:0] floatValue];
            vertexData[i++] = [[vt1 objectAtIndex:1] floatValue];
            
            vertexData[i++] = [[vn1 objectAtIndex:0] floatValue];
            vertexData[i++] = [[vn1 objectAtIndex:1] floatValue];
            vertexData[i++] = [[vn1 objectAtIndex:2] floatValue];
            //v2
            vertexData[i++] = [[v2 objectAtIndex:0] floatValue];
            vertexData[i++] = [[v2 objectAtIndex:1] floatValue];
            vertexData[i++] = [[v2 objectAtIndex:2] floatValue];
            
            vertexData[i++] = [[vt2 objectAtIndex:0] floatValue];
            vertexData[i++] = [[vt2 objectAtIndex:1] floatValue];
            
            vertexData[i++] = [[vn2 objectAtIndex:0] floatValue];
            vertexData[i++] = [[vn2 objectAtIndex:1] floatValue];
            vertexData[i++] = [[vn2 objectAtIndex:2] floatValue];
            //v3
            vertexData[i++] = [[v3 objectAtIndex:0] floatValue];
            vertexData[i++] = [[v3 objectAtIndex:1] floatValue];
            vertexData[i++] = [[v3 objectAtIndex:2] floatValue];
            
            vertexData[i++] = [[vt3 objectAtIndex:0] floatValue];
            vertexData[i++] = [[vt3 objectAtIndex:1] floatValue];
            
            vertexData[i++] = [[vn3 objectAtIndex:0] floatValue];
            vertexData[i++] = [[vn3 objectAtIndex:1] floatValue];
            vertexData[i++] = [[vn3 objectAtIndex:2] floatValue];
        }
        
        NSLog(@"vertexData generated From OBJ file named: %@. (facecount=%lu, size=%d, floatCount=%d, sizeof(float)*floatCount=%ld)", filename, (unsigned long)face.count, i, floatCount, sizeof(float)*floatCount);
        NSMutableDictionary *dico = [NSMutableDictionary dictionary];
        
        GLuint vertexArray;
        GLuint vertexBuffer;
        
        glGenVertexArraysOES(1, &vertexArray);
        glBindVertexArrayOES(vertexArray);
        
        glGenBuffers(1, &vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat)*floatCount, vertexData, GL_STATIC_DRAW);
        
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        
        glBindVertexArrayOES(0);
        [dico setValue:[NSNumber numberWithUnsignedInt:vertexArray] forKey:@"vertexArray"];
        [dico setValue:[NSNumber numberWithUnsignedInt:vertexBuffer] forKey:@"vertexBuffer"];
        [dico setValue:[NSNumber numberWithLong:i] forKey:@"size"];
        
        [[ADUtils sharedUtils].objetCache setValue:dico forKey:filename];
        
        return dico;
    }
    else
    {
        NSLog(@"ERREUR generateVertexArrayFromOBJFile: %@", error.description);
    }
    return nil;
}

+(GLuint)getTextureNamed:(NSString*)name bottomLeft:(BOOL)bottomLeft
{
    GLuint texture;
    
    GLuint cache = [[[ADUtils sharedUtils].textureCache objectForKey:name] unsignedIntValue];
    if(cache)
    {
        NSLog(@"cache detected for texture name: %@", name);
        return cache;
    }
    
    UIImage *image = [UIImage imageNamed:name];
    NSError *error;
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:bottomLeft]
                                                        forKey:GLKTextureLoaderOriginBottomLeft];
    texture = [GLKTextureLoader textureWithCGImage:image.CGImage options:options error:&error].name;
    
    if(error)
        NSLog(@"Texture error : %@", error.description);
    
    [[ADUtils sharedUtils].textureCache setValue:[NSNumber numberWithUnsignedInt:texture] forKey:name];
    
    return texture;
}

+(GLuint)getTextureNamed:(NSString *)name
{
    return [self getTextureNamed:name bottomLeft:YES];
}

+(void)glGenTextureAndFramebuffer:(GLuint*)t f:(GLuint*)f w:(GLsizei)w h:(GLsizei)h
{
    glGenFramebuffers(1, f);
    glGenTextures(1, t);
    
    glBindFramebuffer(GL_FRAMEBUFFER, *f);
    
    glBindTexture(GL_TEXTURE_2D, *t);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, *t, 0);
    
    GLuint depthbuffer;
    glGenRenderbuffers(1, &depthbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthbuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, w, h);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthbuffer);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if(status != GL_FRAMEBUFFER_COMPLETE)
        NSLog(@"Framebuffer status: %x", (int)status);
}

+(void)glGenDepthTextureAndFramebuffer:(GLuint*)t f:(GLuint*)f w:(GLsizei)w h:(GLsizei)h
{
    glGenFramebuffers(1, f);
    glGenTextures(1, t);
    
    glBindFramebuffer(GL_FRAMEBUFFER, *f);
    
    glBindTexture(GL_TEXTURE_2D, *t);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT, w, h, 0, GL_DEPTH_COMPONENT, GL_UNSIGNED_INT, NULL);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, *t, 0);
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if(status != GL_FRAMEBUFFER_COMPLETE)
        NSLog(@"Framebuffer status: %x", (int)status);
}

@end
