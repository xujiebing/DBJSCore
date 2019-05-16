//
//  DBJSCoreManager.m
//  DBJSCore
//
//  Created by 徐结兵 on 2019/5/15.
//

#import "DBJSCoreManager.h"
#import "DBJSCoreHeader.h"

@interface DBJSCoreManager ()

@property (nonatomic, copy, readwrite) void(^exceptionHandler)(NSString *code, NSString *exception);
@property (nonatomic, strong, readwrite) JSContext *context;
@property (nonatomic, strong, readwrite) NSMutableArray *JSCodeArray;
@property (nonatomic, assign, readwrite) BOOL JSObjectRegister;;

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

- (void)dbRegisterOCObjectWithObjectArray:(NSArray<DBJSCoreRegisterModel *> *)objArray {
    [self p_dbRegisterOCObjectWithObjectArray:objArray];
}

- (void)dbRegisterJSCodeWithJSFilePathArray:(NSArray *)pathArray {
    [self p_dbRegisterJSCodeWithJSFilePathArray:pathArray];
}

- (void)dbRegisterJSObjectWithJsonPath:(NSString *)path {
    [self p_dbRegisterJSObjectWithJsonPath:path];
}

- (id)dbCallWithFunctionName:(NSString *)functionName parameter:(NSArray *)parameter {
    return [self p_dbCallWithFunctionName:functionName parameter:parameter];
}

#pragma mark - 内部方法

- (void)p_init {
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        // 将JavaScriptCore的异常转化为内部异常
    };
}

// MARK:注册OC对象
- (void)p_dbRegisterOCObjectWithObjectArray:(NSArray<DBJSCoreRegisterModel *> *)objArray {
    kDBJSCoreWeakSelf
    [objArray enumerateObjectsUsingBlock:^(DBJSCoreRegisterModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *OCObj = model.OCObject;
        NSString *JSObj = model.JSObject;
        weakSelf.context[ISNIL(JSObj)] = NSClassFromString(ISNIL(OCObj));
    }];
}

// MARK:注册JS代码
- (void)p_dbRegisterJSCodeWithJSFilePathArray:(NSArray *)pathArray {
    if (!pathArray) {
        // TODO: add log
        return;
    }
    kDBJSCoreWeakSelf
    [pathArray enumerateObjectsUsingBlock:^(NSString  *_Nonnull path, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *jscode;
        NSError *error;
        NSURL *url;
        if ([path hasPrefix:@"http://"] || [path hasPrefix:@"https://"]) {
            url = [NSURL URLWithString:path];
        } else {
            url = [NSURL fileURLWithPath:path];
        }
        jscode = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            // TODO: add log
            return;
        }
        [weakSelf.JSCodeArray addObject:ISNIL(jscode)];
        weakSelf.JSObjectRegister = YES;
        [weakSelf.context evaluateScript:ISNIL(jscode)];
    }];
}

// MARK:注册JS对象
- (void)p_dbRegisterJSObjectWithJsonPath:(NSString *)path {
    if (!path) {
        // TODO: add log
        return;
    }
    if (!self.JSObjectRegister) {
        // TODO: add log
        return;
    }
    NSError *error;
    NSURL *url;
    if ([path hasPrefix:@"http://"] || [path hasPrefix:@"https://"]) {
        url = [NSURL URLWithString:path];
    } else {
        url = [NSURL fileURLWithPath:path];
    }
    NSString *JSObjJson = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        // TODO: add log
        return;
    }
    NSArray *JSObjArray = [ISNIL(JSObjJson) componentsSeparatedByString:@","];
    kDBJSCoreWeakSelf
    [JSObjArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull functionStop) {
        if (obj.length == 0) {
            return ;
        }
        NSString *objCode = [obj stringByAppendingString:@"=this"];
        __block BOOL exist = NO;
        [weakSelf.JSCodeArray enumerateObjectsUsingBlock:^(NSString * _Nonnull JSCode, NSUInteger idx, BOOL * _Nonnull JSCodeStop) {
            if ([JSCode containsString:objCode]) {
                exist = YES;
                *JSCodeStop = YES;
                return ;
            }
        }];
        if (exist) {
            // TODO: add log. JS代码中包含对象的定义，需要提醒集成方
            return;
        }
        [weakSelf.context evaluateScript:objCode];
    }];
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

- (NSMutableArray *)JSCodeArray {
    if (!_JSCodeArray) {
        _JSCodeArray = [[NSMutableArray alloc] init];
    }
    return _JSCodeArray;
}

@end
