#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "DBJSCoreConfig.h"
#import "DBJSCoreHeader.h"
#import "DBJSCoreManager.h"
#import "DBJSCoreTool.h"

FOUNDATION_EXPORT double DBJSCoreVersionNumber;
FOUNDATION_EXPORT const unsigned char DBJSCoreVersionString[];

