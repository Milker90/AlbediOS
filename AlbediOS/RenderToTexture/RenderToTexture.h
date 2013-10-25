//
//  RenderToTexture.h
//
//  Created by Anthony
//

#import <Foundation/Foundation.h>

@interface RenderToTexture : NSObject

@property (nonatomic, assign) BOOL      started;
@property (nonatomic, assign) CGSize    size;
@property (nonatomic, assign) GLuint    framebuffer;
@property (nonatomic, assign) GLuint    texture;

+(RenderToTexture*)renderer;

-(void)generateFBOWithSize:(CGSize)size scale:(float)scale;
-(void)start;
-(void)render:(GLKView*)view;

-(void)bindCurrent;

//actions
-(void)blur:(float)offset;
-(void)radialBlur;
-(void)sepia;

@end
