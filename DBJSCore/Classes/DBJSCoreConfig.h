//
//  DBJSCoreConfig.h
//  DBJSCore
//
//  Created by 徐结兵 on 2019/5/21.
//

#ifndef DBJSCoreConfig_h
#define DBJSCoreConfig_h

typedef enum : NSUInteger {
    DBJSCoreErrorParameterNil,              // 参数为空
    DBJSCoreErrorJSCodeUnRegister,          // JS代码未注册
    DBJSCoreErrorReadStringFail,            // 根据路径读取字符串失败
    DBJSCoreErrorJSObjDefineExist,          // JS对象重复定义
    DBJSCoreErrorJSOCObjException,          // JS-OC对象映射文件异常
    DBJSCoreErrorJSOCObjValueException,     // JS-OC映射文件中字典数据异常
} DBJSCoreErrorCode;

#endif /* DBJSCoreConfig_h */
