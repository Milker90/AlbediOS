//
//  Node.m
//  3DEngine
//
//  Created by Anthony on 06/02/13.
//  Copyright (c) 2013 Anthony. All rights reserved.
//
//  Un node peux être en mode dynamic ou non
//  Le mode dynamic permet de modifier la position du node uniquement à l'aide de valeurs (x, y, z, rotationX, etc...)
//  car la matrice est ensuite généré pour chaque update (ce qui est légèrement gourmand en ressource).
//
//  En désactivant le mode dynamic, on récupère la main et on peux modifier la position, l'orientation, etc.. manuellement à l'aide de matrix.
//
//  Désactiver le mode dynamic est aussi très utile lorsque l'on souhaite avoir des objets statiques dans l'espace. Il suffit de créer l'objet, de le
//  positionner dans l'espace à l'aide des valeurs (x, y, z, rotationX, etc...) et finalement d'appeler la méthode computeMatrix qui va se charger de générer la matrice de l'objet une fois pour toute.

#import "ADNode.h"

@interface ADNode ()
{
    NSMutableArray *_destroy;
    GLuint uM;
}

@end

@implementation ADNode

@synthesize dynamic         = _dynamic;

@synthesize parent          = _parent;

@synthesize x               = _x;
@synthesize y               = _y;
@synthesize z               = _z;
@synthesize rotationMode    = _rotationMode;
@synthesize rotation        = _rotation;
@synthesize rotationX       = _rotationX;
@synthesize rotationY       = _rotationY;
@synthesize rotationZ       = _rotationZ;
@synthesize scaleX          = _scaleX;
@synthesize scaleY          = _scaleY;
@synthesize scaleZ          = _scaleZ;

@synthesize matrix          = _matrix;

@synthesize children        = _children;

-(id)init
{
    if(self = [super init])
    {
        _parent = nil;
        
        _dynamic = YES;
        
        _x = 0.0;
        _y = 0.0;
        _z = 0.0;
        _rotationMode = kRotationModeEuler;
        _rotation = GLKQuaternionIdentity;
        _rotationX = 0.0;
        _rotationY = 0.0;
        _rotationZ = 0.0;
        _scaleX = 1.0;
        _scaleY = 1.0;
        _scaleZ = 1.0;
        
        _matrix = GLKMatrix4Identity;
        
        _children = [NSMutableArray array];
        _destroy = [NSMutableArray array];
        
        [self configureUniform];
    }
    return self;
}

-(void)addNode:(ADNode*)node
{
    if(node != nil)
    {
        node.parent = self;
        [_children addObject:node];
    }
}

-(void)removeNode:(ADNode*)node
{
    [_destroy addObject:node];
}

-(void)update:(NSTimeInterval)delta
{
    if(_destroy.count > 0)
    {
        [_children removeObjectsInArray:_destroy];
        [_destroy removeAllObjects];
    }
    
    if(_dynamic)
        [self computeMatrix];
    
    for (ADNode *node in _children)
        [node update:delta];
}

-(void)draw
{
    for (ADNode *node in _children)
        [node draw];
    
    glUniformMatrix4fv(uM, 1, 0, self.matrix.m);
}

-(GLKMatrix4)matrix
{
    GLKMatrix4 m = _matrix;
 
    if(_parent)
        m = GLKMatrix4Multiply(_parent.matrix, m);
    
    return m;
}

-(void)computeMatrix
{
    GLKMatrix4 m = GLKMatrix4Identity;
    
    m = GLKMatrix4Multiply(GLKMatrix4MakeScale(_scaleX, _scaleY, _scaleZ), m);
    
    if(_rotationMode == kRotationModeEuler)
    {
        m = GLKMatrix4Multiply(GLKMatrix4MakeRotation(GLKMathDegreesToRadians(_rotationX), 1.0, 0.0, 0.0), m);
        m = GLKMatrix4Multiply(GLKMatrix4MakeRotation(GLKMathDegreesToRadians(_rotationZ), 0.0, 0.0, 1.0), m);
        m = GLKMatrix4Multiply(GLKMatrix4MakeRotation(GLKMathDegreesToRadians(_rotationY), 0.0, 1.0, 0.0), m);
    }
    if(_rotationMode == kRotationModeQuaternion)
    {
        m = GLKMatrix4Multiply(GLKMatrix4MakeWithQuaternion(_rotation), m);
    }
    
    m = GLKMatrix4Multiply(GLKMatrix4MakeTranslation(_x, _y, _z), m);
    
    _matrix = m;
}

-(void)moveForward:(float)speed
{
    //on calcul l'avancé sur l'axe des Z en fonction de l'inclinaison
    _z -= cosf(GLKMathDegreesToRadians(_rotationY)) * cosf(GLKMathDegreesToRadians(_rotationX)) * speed;
    
    //on calcul l'avancé sur l'axe des X en fonction de l'inclinaison
    _x -= sinf(GLKMathDegreesToRadians(_rotationY)) * cosf(GLKMathDegreesToRadians(_rotationX)) * speed;
    
    //on calcul l'avancé sur l'axe des Y en fonction de l'inclinaison
    _y -= sinf(GLKMathDegreesToRadians(-_rotationX)) * speed;
}

-(void)setPosition:(GLKVector4)position
{
    _x = position.x;
    _y = position.y;
    _z = position.z;
}

-(GLKVector4)position
{
    return GLKVector4Make(_x, _y, _z, 1.0);
}

-(void)setScale:(GLfloat)scale
{
    _scaleX = _scaleY = _scaleZ = scale;
}

-(void)configureUniform
{
    uM = glGetUniformLocation([ADShaderTools tools].shader, "M");
}

@end
