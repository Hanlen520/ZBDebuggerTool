//
//  ZBDebuggerURLProtocol.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//NSURLProtocol可以拦截监听每一个URL Loading System中发出request请求，记住是URL Loading System中那些类发出的请求，也支持AFNetwoking，UIWebView发出的request， NSURLProtocol 是虚拟父类，拦截必须子类实现方法

#import <Foundation/Foundation.h>

@interface ZBDebuggerURLProtocol : NSURLProtocol

@end
