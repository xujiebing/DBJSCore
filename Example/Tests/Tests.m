//
//  DBJSCoreTests.m
//  DBJSCoreTests
//
//  Created by xujiebing on 05/13/2019.
//  Copyright (c) 2019 xujiebing. All rights reserved.
//

@import XCTest;

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testUrl {
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"Log.js" ofType:nil];
    NSArray *pathArray = @[path1,@"http://ww.baidu", @"https://www.baidu.com"];
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
//            *stop = YES;
            return;
        }
        NSLog(@"");
    }];
}

- (void)testJS {
    NSString *JSObjJson = @"shjahda,dhjahdak,djkoejkdoa,xnajshb";
    NSArray *JSObjArray = [JSObjJson componentsSeparatedByString:@","];
    NSArray *JSCodeArray = @[@"dceasdf3wfdw dhjahdak = this;dhnahdwela", @"gfshfcehsafcbjhnsabfchjsfbha", @"dhfiuaswfgaseifgseif"];
    [JSObjArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull functionStop) {
        if (obj.length == 0) {
            return ;
        }
        NSString *objCode = [obj stringByAppendingString:@"=this"];
        __block BOOL exist = NO;
        [JSCodeArray enumerateObjectsUsingBlock:^(NSString * _Nonnull JSCode, NSUInteger idx, BOOL * _Nonnull JSCodeStop) {
            JSCode = [JSCode stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([JSCode containsString:objCode]) {
                exist = YES;
                *JSCodeStop = YES;
                return ;
            }
        }];
        if (!exist) {
            return;
        }
        // TODO: add log. JS代码中包含对象的定义，需要提醒集成方
        NSLog(@"");
    }];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end

