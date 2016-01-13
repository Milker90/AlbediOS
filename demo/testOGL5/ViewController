//
//  ViewController.m
//  testOGL5
//
//  Created by Anthony on 24/09/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//

#import "ViewController.h"
#import "ADDirector.h"

@interface ViewController ()
{
    ADSphere *lightNode;
    
    GLKVector3 _anchor_position;
    GLKVector3 _current_position;
    
    GLKQuaternion _quatStart;
    GLKQuaternion _quat;
    
    NSMutableArray *array;
    
    ADNode *objects;
}

@property (strong, nonatomic) EAGLContext *context;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadAssets];
    [self setupGL];
}

- (void)dealloc
{
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
}

-(void)loadAssets
{
    [ADUtils loadTextureNamed:@"t.png"];
    [ADUtils loadTextureNamed:@"tnm.png"];
    [ADUtils loadTextureNamed:@"nm.png"];
    [ADUtils loadTextureNamed:@"nm2.png"];
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    _quat = GLKQuaternionMake(0, 0, 0, 1);
    _quatStart = GLKQuaternionMake(0, 0, 0, 1);
    
    float aspect = fabsf(self.view.bounds.size.width/self.view.bounds.size.height);
    
    ADNode *world = [ADNode node];
    
    ADLight *light = [[ADLight alloc] init];
    light.type = kLightTypesPoint;
    light.power = 700.0;
    
    ADCamera *camera = [[ADCamera alloc] init];
    camera.projection = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1, 200.0);
    camera.dynamic = NO;
    
    [ADDirector sharedDirector].clearColor = GLKVector3Make(0.1, 0.1, 0.1);
    [[ADDirector sharedDirector] initSceneWithView:(GLKView*)self.view light:light camera:camera world:world];
    [[ADDirector sharedDirector] initShadowMapping:self.view.frame.size projection:GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 1.5, 200.0) scale:1.0];
    
    array = [NSMutableArray array];
    objects = [ADNode node];
    [world addNode:objects];
    
    ADPlane *ground = [[ADPlane alloc] initWithQuality:20];
    ground.y = -5.0;
    ground.scale = 200.0;
    ground.texture = [ADUtils getTextureNamed:@"t.png" bottomLeft:YES];
    ground.textureNM = [ADUtils getTextureNamed:@"tnm.png" bottomLeft:YES];
    ground.rotationX = -90.0;
    ground.shininess = 200.0;
    [world addNode:ground];
    
    for (uint i = 0; i < 20; i++)
    {
        ADObject *o = [[ADObject alloc] initWithName:@"lmp005.obj" color:GLKVector3Make(1.0, 0.0, 0.0)];
        o.shininess = 150.0;
        o.diffuse = GLKVector3Make(0.0, (50 + arc4random() % 200) / 255.0, (50 + arc4random() % 150) / 255.0);
        o.scale = 0.01;
        float range = 10.0;
        o.position = GLKVector4Make(-range + ((arc4random() % 10) / 10.0) * range * 2, -4 + ((arc4random() % 10) / 10.0) * range * 2, -range + ((arc4random() % 10) / 10.0) * range * 2, 1.0);
        if(arc4random() % 10 > 5)
        {
            [objects addNode:o];
            o.rotationX = arc4random() % 180;
            o.rotationY = arc4random() % 180;
            o.rotationZ = arc4random() % 180;
        }
        else
        {
            o.rotationX = -90.0;
            [world addNode:o];
            o.y = -5.0;
        }
    }
    
    ADNode *nodePlateauVase = [ADNode node];
    nodePlateauVase.name = @"nodePlateauVase";
    [objects addNode:nodePlateauVase];
    
    ADCube *cube = [[ADCube alloc] init];
    cube.diffuse = GLKVector3Make(0.0, (50 + arc4random() % 250) / 255.0, (50 + arc4random() % 250) / 255.0);
    //cube.textureNM = [ADUtils getTextureNamed:@"nm2.png"];
    cube.scaleX = 3.0;
    cube.scaleZ = 3.0;
    cube.scaleY = 0.2;
    [nodePlateauVase addNode:cube];
    
    ADObject *o = [[ADObject alloc] initWithName:@"lmp005.obj" color:GLKVector3Make(1.0, 0.0, 0.0)];
    o.scale = 0.015;
    o.diffuse = GLKVector3Make(0.0, (50 + arc4random() % 250) / 255.0, (50 + arc4random() % 250) / 255.0);
    o.y = 0.25;
    o.rotationX = -90.0;
    [nodePlateauVase addNode:o];
    
    lightNode = [[ADSphere alloc] initWithRadius:0.25 quality:20];
    lightNode.diffuse = GLKVector3Make(1.0, 0.7, 0.0);
    lightNode.emissive = YES;
    [world addNode:lightNode];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    [[ADDirector sharedDirector] update:self.timeSinceLastUpdate];
    
    for (ADObject *o in objects.children) {
        if([o.name isEqualToString:@"nodePlateauVase"])
        {
            o.rotationX = cos(self.timeSinceFirstResume/1.4)*15.0;
            o.rotationY += 45.0 * self.timeSinceLastUpdate;
            o.rotationZ = cos(self.timeSinceFirstResume)*10.0;
        }
        else
        {
            o.rotationX += 45.0 * self.timeSinceLastUpdate;
            o.rotationY += 45.0 * self.timeSinceLastUpdate;
            o.rotationZ += 45.0 * self.timeSinceLastUpdate;
        }
    }
    
    objects.x = cos(self.timeSinceFirstResume)*4.0;
    
    GLKMatrix4 rotation = GLKMatrix4MakeWithQuaternion(_quat);
    [ADDirector sharedDirector].camera.matrix = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(0.0, 0.0, -14.0), rotation);
    
    lightNode.position = GLKVector4Make(cosf(self.timeSinceFirstResume/1.5) * 12.0, 7.5 + cosf(self.timeSinceFirstResume/1.3) * 3.0, cosf(self.timeSinceFirstResume) * 12.0, 1.0);
    [ADDirector sharedDirector].light.position = lightNode.position;
}

- (void)computeIncremental {
    
    GLKVector3 axis = GLKVector3CrossProduct(_anchor_position, _current_position);
    float dot = GLKVector3DotProduct(_anchor_position, _current_position);
    float angle = acosf(dot);
    
    GLKQuaternion Q_rot = GLKQuaternionMakeWithAngleAndVector3Axis(angle * 2, axis);
    Q_rot = GLKQuaternionNormalize(Q_rot);
    
    // TODO: Do something with Q_rot...
    _quat = GLKQuaternionMultiply(Q_rot, _quatStart);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    _anchor_position = GLKVector3Make(location.x, location.y, 0);
    _anchor_position = [self projectOntoSurface:_anchor_position];
    
    _current_position = _anchor_position;
    _quatStart = _quat;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
    
    // Add to bottom of touchesMoved
    _current_position = GLKVector3Make(location.x, location.y, 0);
    _current_position = [self projectOntoSurface:_current_position];
    
    [self computeIncremental];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [[ADDirector sharedDirector] drawWithShadow];
}

- (GLKVector3) projectOntoSurface:(GLKVector3) touchPoint
{
    float radius = self.view.bounds.size.width/3;
    GLKVector3 center = GLKVector3Make(self.view.bounds.size.width/2, self.view.bounds.size.height/2, 0);
    GLKVector3 P = GLKVector3Subtract(touchPoint, center);
    
    // Flip the y-axis because pixel coords increase toward the bottom.
    P = GLKVector3Make(P.x, P.y * -1, P.z);
    
    float radius2 = radius * radius;
    float length2 = P.x*P.x + P.y*P.y;
    
    if (length2 <= radius2)
        P.z = sqrt(radius2 - length2);
    else
    {
        P.x *= radius / sqrt(length2);
        P.y *= radius / sqrt(length2);
        P.z = 0;
    }
    
    return GLKVector3Normalize(P);
}

@end