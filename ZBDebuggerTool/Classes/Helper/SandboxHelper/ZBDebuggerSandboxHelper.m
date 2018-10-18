//
//  ZBDebuggerSandboxHelper.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerSandboxHelper.h"

static ZBDebuggerSandboxHelper *_instance = nil;
@implementation ZBDebuggerSandboxHelper
/**
 单例helper工具
 
 @return 单例对象
 */
+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance= [[self alloc]init];
    });
    return _instance;
}

/**
 获取所有沙盒文件数据
 */
- (ZBDebuggerSandboxModel *)getCurrentSandboxHomeDirectory
{
    NSString *homePath = NSHomeDirectory();
    ZBDebuggerSandboxModel *model = [self getSandboxFileWithPath:homePath];
    return model;
}



#pragma mark - praite
- (ZBDebuggerSandboxModel *)getSandboxFileWithPath:(NSString *)path
{
    if(path.length ==0) return nil;
    BOOL isDirectory = NO;
    
    //1.检测文件是否存在
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    if(!isExist){
        return nil;
    }
    
    //2.文件描述
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    
    ZBDebuggerSandboxModel *sandboxModel = [[ZBDebuggerSandboxModel alloc]initWithAttributes:attributes filePath:path];
    if(sandboxModel.isDirectory){
        
        // 获取子路径
        NSArray *subFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        for (NSString *subPath in subFiles) {
            ZBDebuggerSandboxModel *subModel = [self getSandboxFileWithPath:[path stringByAppendingPathComponent:subPath]];
            if (subModel) {
                sandboxModel.totalFileSize += subModel.totalFileSize;
                [sandboxModel.subModels addObject:subModel];
            }
        }
    }
    [self sortSubModels:sandboxModel];
    return sandboxModel;
}

- (void)sortSubModels:(ZBDebuggerSandboxModel *)model {
    for (ZBDebuggerSandboxModel *mod in model.subModels) {
        if (mod.subModels.count) {
            [self sortSubModels:mod];
        }
    }
    [model.subModels sortUsingComparator:^NSComparisonResult(ZBDebuggerSandboxModel *obj1, ZBDebuggerSandboxModel *obj2) {
        if (obj2.isDirectory != obj1.isDirectory) {
            return obj2.isDirectory;
        }
        return [obj2.fileCreateDate compare:obj1.fileCreateDate];
    }];
}

@end
