#define RAND                    -1 + (((arc4random()%11)/10.0)*2.0)

#define RAND_BETWEEN(a, b)      a + ((((arc4random()%11)/10.0)*b) - a)

#define RAND_VEC4(w)            GLKVector4Make(RAND,RAND,RAND, w)

#define RAND_VEC4_COEF(w, x)    GLKVector4MultiplyScalar(RAND_VEC4(w), x)