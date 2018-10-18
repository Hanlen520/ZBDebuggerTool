//
//  ZBDebuggerCrashModel.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerCrashModel.h"
#import "ZBDebuggerConfig.h"

@implementation ZBDebuggerCrashModel
- (void)setCrashDate:(NSString *)crashDate
{
    if(![_crashDate isEqualToString:crashDate])
    {
        _crashDate = [crashDate copy];
        if (!_identity) {
            _identity = [crashDate stringByAppendingString:[ZBDebuggerConfig defaultDebuggerConfig].useIdentity];
        }
    }
}
@end
