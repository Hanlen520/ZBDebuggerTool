//
//  ZBDebuggerNetworkModel.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerBaseModel.h"

@interface ZBDebuggerNetworkModel : ZBDebuggerBaseModel


#pragma mark - 请求
/**
 发起请求时间
 */
@property (nonatomic , copy) NSString *requestStartDate;
/**
 请求URL.
 */
@property (nonatomic , copy) NSURL *url;

/**
 请求method.
 */
@property (nonatomic , copy) NSString *method;

/**
 请求 mine type.
 */
@property (nonatomic , copy) NSString *mineType;

/**
 请求body.
 */
@property (nonatomic , copy) NSString *requestBody;

/**
 请求 header.
 */
@property (nonatomic , copy) NSDictionary <NSString *,NSString *>*headerFields;

/**
 请求使用时间.
 */
@property (nonatomic , copy) NSString *requestUseTime;

/**
 请求 error.
 */
@property (nonatomic , strong) NSError *error;

/**
 请求是否是图片
 */
@property (nonatomic , assign) BOOL isImage;


#pragma mark - 响应
/**
 响应 status code.
 */
@property (nonatomic , copy ) NSString *httpStatusCode;

/**
 响应data.
 */
@property (nonatomic , copy) NSData *responseData;


/**
 请求唯一标识
 */
@property (nonatomic, copy,readonly) NSString *identity;


@end
