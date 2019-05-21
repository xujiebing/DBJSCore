//
//  DBJSCoreExports.h
//  DBJSCore_Example
//
//  Created by 徐结兵 on 2019/5/22.
//  Copyright © 2019 xujiebing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DBJSCoreExports <NSObject, JSExport>

+ (void)log:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
