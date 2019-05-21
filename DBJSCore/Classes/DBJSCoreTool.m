//
//  DBJSCoreTool.m
//  DBJSCore
//
//  Created by 徐结兵 on 2019/5/21.
//

#import "DBJSCoreTool.h"

@implementation DBJSCoreTool

+ (id)jsonValueDecoded:(NSString *)json {
    if (json.length == 0) {
        return nil;
    }
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id value = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        NSLog(@"jsonValueDecoded error:%@", error);
        return nil;
    }
    return value;
}


@end
