//
//  DBJSCoreRegisterModel.h
//  DBJSCore
//
//  Created by 徐结兵 on 2019/5/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBJSCoreRegisterModel : NSObject

/**
 OC对象名
 */
@property (nonatomic, copy, readwrite) NSString *OCObject;

/**
 JS对象名
 */
@property (nonatomic, copy, readwrite) NSString *JSObject;

@end

NS_ASSUME_NONNULL_END
