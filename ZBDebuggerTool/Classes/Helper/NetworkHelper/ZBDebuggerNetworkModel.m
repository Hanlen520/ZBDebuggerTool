//
//  ZBDebuggerNetworkModel.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerNetworkModel.h"
#import "ZBDebuggerConfig.h"

@implementation ZBDebuggerNetworkModel
- (void)setRequestStartDate:(NSString *)requestStartDate
{
    if(![_requestStartDate isEqualToString:requestStartDate])
    {
        _requestStartDate = [requestStartDate copy];
        if (!_identity) {
            _identity = [requestStartDate stringByAppendingString:[ZBDebuggerConfig defaultDebuggerConfig].useIdentity];
        }
    }
}
@end
