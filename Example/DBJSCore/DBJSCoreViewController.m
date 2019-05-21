//
//  DBJSCoreViewController.m
//  DBJSCore
//
//  Created by xujiebing on 05/13/2019.
//  Copyright (c) 2019 xujiebing. All rights reserved.
//

#import "DBJSCoreViewController.h"
#import "DBJSCoreManager.h"

@interface DBJSCoreViewController ()

@property (nonatomic, strong, readwrite) DBJSCoreManager *JSCoreManager;

@end

@implementation DBJSCoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.JSCoreManager.exceptionHandler = ^(NSString * _Nonnull code, NSString * _Nonnull exception) {
        NSLog(@"code: %@; exception: %@", code, exception);
    };
    NSString *path1 = [self loadJSFromBundle:@"test1.js"];
    NSString *path2 = [self loadJSFromBundle:@"test2.js"];
    NSString *path3 = [self loadJSFromBundle:@"test3.js"];
    NSString *path4 = [self loadJSFromBundle:@"test4.js"];
    NSArray *JSCodeArray = @[path1, path2, path3, path4];
    // 注册JS代码
    [self.JSCoreManager dbRegisterJSCodeWithJSFilePathArray:JSCodeArray];
    // 注册映射
    NSString *JSOCPath = [self loadJSFromBundle:@"JS-OCObject.json"];
    [self.JSCoreManager dbRegisterJSObjectAndOCObjectWithJsonPath:JSOCPath];
    // 注册JS对象
    NSString *JSObjPath = [self loadJSFromBundle:@"JavaScripObject.json"];
    [self.JSCoreManager dbRegisterJSObjectWithJsonPath:JSObjPath];
    // 调用方法
    [self.JSCoreManager dbCallWithFunctionName:@"function1" parameter:@[@"测试"]];
}

- (NSString *)loadJSFromBundle:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    return path;
}

- (DBJSCoreManager *)JSCoreManager {
    if (!_JSCoreManager) {
        _JSCoreManager = [[DBJSCoreManager alloc] init];
    }
    return _JSCoreManager;
}

@end
