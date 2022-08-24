#ifndef FOUNDATION_EXPORT
    #if defined(__cplusplus)
        #include <iostream>
        #define FOUNDATION_EXPORT extern "C"
    #else
        #define FOUNDATION_EXPORT extern
    #endif
#endif

#import "secp256k1.h"
