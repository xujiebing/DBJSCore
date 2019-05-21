//
//  DBJSCoreHeader.h
//  DBJSCore
//
//  Created by 徐结兵 on 2019/5/15.
//

#ifndef DBJSCoreHeader_h
#define DBJSCoreHeader_h

#define kDBJSCoreWeakSelf __weak __typeof(self)weakSelf = self;
#define ISNIL(x) ((x) == nil ? @"" : (x))
#define DBStringIsEmpty(string) ((string.length) == 0 ? YES : NO)


#endif /* DBJSCoreHeader_h */
