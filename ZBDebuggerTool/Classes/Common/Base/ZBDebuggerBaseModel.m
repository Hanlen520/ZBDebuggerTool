//
//  ZBDebuggerBaseModel.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerBaseModel.h"
#import <objc/runtime.h>

@implementation ZBDebuggerBaseModel

//解码归档数据来初始化对象
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]){
       NSArray *propertys = [self getPropertyNames];
        for (NSString  *property in propertys) {
            id value = [aDecoder decodeObjectForKey:property];
            [self setValue:value forKey:property];
        }
    }
    return self;
}

//对自定义的对象进行归档
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSArray *propertys = [self getPropertyNames];
    for (NSString *name in propertys) {
        id value = [self valueForKey:name];
        [aCoder encodeObject:value forKey:name];
    }
}

//赋值
- (id)copyWithZone:(NSZone *)zone
{
    id object = [[[self class] alloc] init];
    NSArray *propertys = [self getPropertyNames];
    for (NSString *name in propertys) {
        id value = [self valueForKey:name];
        [object setValue:value forKey:name];
    }
    return object;
}


#pragma mark - private
- (NSArray *)getPropertyNames {
    // Property count
    unsigned int count;
    // Get property list
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    // Get names
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        // objc_property_t
        objc_property_t property = properties[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        if (name.length) {
            [array addObject:name];
        }
    }
    return array;
}
@end
