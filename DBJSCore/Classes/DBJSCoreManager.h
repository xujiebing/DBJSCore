//
//  DBJSCoreManager.h
//  DBJSCore
//
//  Created by 徐结兵 on 2019/5/15.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBJSCoreManager : NSObject

/**
 异常回调
 */
@property (nonatomic, copy, readwrite) void(^exceptionHandler)(NSString *code, NSString *exception);

/**
 注册JS-OC对象映射

 @param path JS-OC对象映射文件的路径
 */
- (void)dbRegisterJSObjectAndOCObjectWithJsonPath:(NSString *)path;

/**
 注册JS代码

 @param pathArray JS文件地址数组
 */
- (void)dbRegisterJSCodeWithJSFilePathArray:(NSArray <NSString *>*)pathArray;

/**
 注册JS对象
 
 @param path JS方法集合文件的路径
 */
- (void)dbRegisterJSObjectWithJsonPath:(NSString *)path;

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
