//
//  DBJSCoreManager.m
//  DBJSCore
//
//  Created by 徐结兵 on 2019/5/15.
//

#import "DBJSCoreManager.h"
#import "DBJSCoreHeader.h"
#import "DBJSCoreConfig.h"
#import "DBJSCoreTool.h"

@interface DBJSCoreManager ()

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

- (void)dbRegisterJSObjectAndOCObjectWithJsonPath:(NSString *)path {
    if (DBStringIsEmpty(path)) {
        [self p_exceptionHandler:DBJSCoreErrorParameterNil exception:@"parameter is nil, function:dbRegisterJSObjectAndOCObjectWithJsonPath:"];
        return;
    }
    [self p_dbRegisterJSObjectAndOCObjectWithJsonPath:path];
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
    if (DBStringIsEmpty(functionName)) {
        [self p_exceptionHandler:DBJSCoreErrorParameterNil exception:@"parameter is nil, function:dbCallWithFunctionName:parameter:"];
        return nil;
    }
    return [self p_dbCallWithFunctionName:functionName parameter:parameter];
}

#pragma mark - 内部方法

- (void)p_init {
    kDBJSCoreWeakSelf
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSString *message = [NSString stringWithFormat:@"%@", exception];
        [weakSelf p_exceptionHandler:DBJSCoreErrorJSCoreException exception:message];
    };
}

// MARK:注册JS-OC对象映射
- (void)p_dbRegisterJSObjectAndOCObjectWithJsonPath:(NSString *)path {
    NSError *error;
    NSURL *url;
    if ([path hasPrefix:@"http://"] || [path hasPrefix:@"https://"]) {
        url = [NSURL URLWithString:path];
    } else {
        url = [NSURL fileURLWithPath:path];
    }
    NSString *JSOCObjJson = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSString *exception = [NSString stringWithFormat:@"path:%@, message:%@", path, error.localizedDescription];
        [self p_exceptionHandler:DBJSCoreErrorReadStringFail exception:exception];
        return;
    }
    NSArray *JSOCObjArray = [DBJSCoreTool jsonValueDecoded:JSOCObjJson];
    if (JSOCObjArray.count == 0) {
        NSString *exception = [NSString stringWithFormat:@"path:%@, message:%@", path, error.localizedDescription];
        [self p_exceptionHandler:DBJSCoreErrorJSOCObjException exception:exception];
        return;
    }
    
    kDBJSCoreWeakSelf
    [JSOCObjArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *OCObj = [dic objectForKey:@"OCObject"];
        NSString *JSObj = [dic objectForKey:@"JSObject"];;
        if (DBStringIsEmpty(OCObj) || DBStringIsEmpty(JSObj)) {
            NSString *exception = [NSString stringWithFormat:@"dic:%@, message:%@", dic, error.localizedDescription];
            [self p_exceptionHandler:DBJSCoreErrorJSOCObjValueException exception:exception];
            return;
        }
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
            NSString *exception = [NSString stringWithFormat:@"path:%@, message:%@", path, error.localizedDescription];
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
        NSString *exception = [NSString stringWithFormat:@"path:%@, message:%@", path, error.localizedDescription];
        [self p_exceptionHandler:DBJSCoreErrorReadStringFail exception:exception];
        return;
    }
    JSObjJson = [JSObjJson stringByReplacingOccurrencesOfString:@" " withString:@""];
    JSObjJson = [JSObjJson stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSArray *JSObjArray = [ISNIL(JSObjJson) componentsSeparatedByString:@","];
    kDBJSCoreWeakSelf
    [JSObjArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull functionStop) {
        if (DBStringIsEmpty(obj)) {
            return ;
        }
        obj = [@"var " stringByAppendingString:obj];
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
    if (!self.exceptionHandler) {
        return;
    }
    NSString *errorCode = [NSString stringWithFormat:@"%ld", code];
    exception = [@"DBJSCore Exception: " stringByAppendingString:exception];
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
