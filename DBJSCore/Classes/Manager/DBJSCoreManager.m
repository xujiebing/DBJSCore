//
//  DBJSCoreManager.m
//  DBJSCore
//
//  Created by 徐结兵 on 2019/5/15.
//

#import "DBJSCoreManager.h"
#import "DBJSCoreHeader.h"
#import "DBJSCoreConfig.h"

@interface DBJSCoreManager ()

@property (nonatomic, copy, readwrite) void(^exceptionHandler)(NSString *code, NSString *exception);
@property (nonatomic, strong, readwrite) JSContext *context;
@property (nonatomic, strong, readwrite) NSMutableArray *JSCodeArray;
@property (nonatomic, assign, readwrite) BOOL JSCodeRegister;;

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
    if (objArray.count == 0) {
        [self p_exceptionHandler:DBJSCoreErrorParameterNil exception:@"parameter is nil, function:dbRegisterOCObjectWithObjectArray:"];
        return;
    }
    [self p_dbRegisterOCObjectWithObjectArray:objArray];
}

- (void)dbRegisterJSCodeWithJSFilePathArray:(NSArray<NSString *> *)pathArray {
    if (!pathArray) {
        [self p_exceptionHandler:DBJSCoreErrorParameterNil exception:@"parameter is nil, function:dbRegisterJSCodeWithJSFilePathArray:"];
        return;
    }
    [self p_dbRegisterJSCodeWithJSFilePathArray:pathArray];
}

- (void)dbRegisterJSObjectWithJsonPath:(NSString *)path {
    if (!path) {
        [self p_exceptionHandler:DBJSCoreErrorParameterNil exception:@"parameter is nil, function:dbRegisterJSObjectWithJsonPath:"];
        return;
    }
    if (!self.JSCodeRegister) {
        [self p_exceptionHandler:DBJSCoreErrorJSCodeUnRegister exception:@"JSCode unRegister"];
        return;
    }
    [self p_dbRegisterJSObjectWithJsonPath:path];
}

- (id)dbCallWithFunctionName:(NSString *)functionName parameter:(NSArray *)parameter {
    if (functionName.length == 0) {
        [self p_exceptionHandler:DBJSCoreErrorParameterNil exception:@"parameter is nil, function:dbCallWithFunctionName:parameter:"];
        return nil;
    }
    return [self p_dbCallWithFunctionName:functionName parameter:parameter];
}

#pragma mark - 内部方法

- (void)p_init {
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        // TODO: add log. 将JavaScriptCore的异常转化为内部异常
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
- (void)p_dbRegisterJSCodeWithJSFilePathArray:(NSArray<NSString *> *)pathArray {
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
            NSString *exception = [NSString stringWithFormat:@"url:%@, message:%@", url, error.localizedDescription];
            [self p_exceptionHandler:DBJSCoreErrorReadStringFail exception:exception];
            return;
        }
        [weakSelf.JSCodeArray addObject:ISNIL(jscode)];
        weakSelf.JSCodeRegister = YES;
        [weakSelf.context evaluateScript:ISNIL(jscode)];
    }];
}

// MARK:注册JS对象
- (void)p_dbRegisterJSObjectWithJsonPath:(NSString *)path {
    NSError *error;
    NSURL *url;
    if ([path hasPrefix:@"http://"] || [path hasPrefix:@"https://"]) {
        url = [NSURL URLWithString:path];
    } else {
        url = [NSURL fileURLWithPath:path];
    }
    NSString *JSObjJson = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSString *exception = [NSString stringWithFormat:@"url:%@, message:%@", url, error.localizedDescription];
        [self p_exceptionHandler:DBJSCoreErrorReadStringFail exception:exception];
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
            NSString *exception = [NSString stringWithFormat:@"%@ has exist", objCode];
            [weakSelf p_exceptionHandler:DBJSCoreErrorJSObjDefineExist exception:exception];
            return;
        }
        [weakSelf.context evaluateScript:objCode];
    }];
}

// MARK:调用JS方法
- (id)p_dbCallWithFunctionName:(NSString *)functionName parameter:(NSArray *)parameter {
    JSValue *functionValue = self.context[functionName];
    JSValue *value = [functionValue callWithArguments:parameter];
    id obj = [value toObject];
    return obj;
}

- (void)p_exceptionHandler:(NSUInteger)code exception:(NSString *)exception {
    NSString *errorCode = [NSString stringWithFormat:@"%ld", code];
    self.exceptionHandler(errorCode, exception);
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
