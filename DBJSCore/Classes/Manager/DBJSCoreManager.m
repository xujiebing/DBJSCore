//
//  DBJSCoreManager.m
//  DBJSCore
//
//  Created by 徐结兵 on 2019/5/15.
//

#import "DBJSCoreManager.h"

@interface DBJSCoreManager ()

@property (nonatomic, copy, readwrite) void(^exceptionHandler)(NSString *code, NSString *exception);
@property (nonatomic, strong, readwrite) JSContext *context;

@end

@implementation DBJSCoreManager

#pragma mark - 公共方法

- (instancetype)init {
    self = [super init];
    if (self) {
        [self p_init];
    }
    return self;
}

- (void)dbRegisterOCFunctionWithObjectArray:(NSArray<DBJSCoreRegisterModel *> *)objArray {
    [self p_dbRegisterOCFunctionWithObjectArray:objArray];
}

- (void)dbRegisterJSFunctionWithJsonPath:(NSURL *)jsonUrl {
    [self p_dbRegisterJSFunctionWithJsonPath:jsonUrl];
}

- (void)dbRegisterJSCodeWithJSFilePathArray:(NSArray *)pathArray {
    [self p_dbRegisterJSCodeWithJSFilePathArray:pathArray];
}

- (id)dbCallWithFunctionName:(NSString *)functionName parameter:(NSArray *)parameter {
    return [self p_dbCallWithFunctionName:functionName parameter:parameter];
}

#pragma mark - 内部方法

- (void)p_init {
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        // 将javascriptcore的异常转化为内部异常
    };
}

// MARK:注册OC方法
- (void)p_dbRegisterOCFunctionWithObjectArray:(NSArray<DBJSCoreRegisterModel *> *)objArray {
    
}

// MARK:注册JS方法
- (void)p_dbRegisterJSFunctionWithJsonPath:(NSURL *)jsonUrl {
    
}

// MARK:注册JS代码
- (void)p_dbRegisterJSCodeWithJSFilePathArray:(NSArray *)pathArray {
    
}

// MARK:调用JS方法
- (id)p_dbCallWithFunctionName:(NSString *)functionName parameter:(NSArray *)parameter {
    return nil;
}

#pragma mark - 懒加载方法

- (JSContext *)context {
    if (!_context) {
        _context = [[JSContext alloc] init];
    }
    return _context;
}

@end
