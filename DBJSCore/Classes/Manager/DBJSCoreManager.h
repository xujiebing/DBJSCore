//
//  DBJSCoreManager.h
//  DBJSCore
//
//  Created by 徐结兵 on 2019/5/15.
//

#import <Foundation/Foundation.h>
#import "DBJSCoreRegisterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBJSCoreManager : NSObject

/**
 注册OC方法

 @param objArray 对象名数组
 */
- (void)dbRegisterOCFunctionWithObjectArray:(NSArray * <DBJSCoreRegisterModel *>)objArray;

/**
 注册JS方法

 @param jsonUrl JS方法集合文件的路径
 */
- (void)dbRegisterJSFunctionWithJsonPath:(NSURL *)jsonUrl;

/**
 调用JS方法

 @param functionName 方法名
 @param parameter 参数
 @return 返回值
 */
- (id)dbCallWithFunctionName:(NSString *)functionName
                   parameter:(NSArray *)parameter;

@end

NS_ASSUME_NONNULL_END
