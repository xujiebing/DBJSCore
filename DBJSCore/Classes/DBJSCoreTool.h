//
//  DBJSCoreTool.h
//  DBJSCore
//
//  Created by 徐结兵 on 2019/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBJSCoreTool : NSObject

/**
 json转对象

 @param json json字符串
 @return 对象
 */
+ (id)jsonValueDecoded:(NSString *)json;

@end

NS_ASSUME_NONNULL_END
