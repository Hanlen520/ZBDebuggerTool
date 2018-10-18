//
//  ZBDebuggerSandboxModel.h
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerBaseModel.h"

@interface ZBDebuggerSandboxModel : ZBDebuggerBaseModel

/**
 初始化模型

 @param attributes 文件描述
 @param filePath 路径
 @return 模型
 */
- (instancetype)initWithAttributes:(NSDictionary *)attributes filePath:(NSString *)filePath;


/**
 文件路径
 */
@property (nonatomic, strong, readonly)  NSString *filePath;
/**
 文件名称
 */
@property (nonatomic, strong, readonly)  NSString *fileName;
/**
 文件类型
 */
@property (nonatomic, strong, readonly)  NSString *fileType;
/**
 文件大小
 */
@property (nonatomic, assign, readonly)  unsigned long long fileSize;
/**
 所有文件大小包括子文件
 */
@property (nonatomic , assign) unsigned long long totalFileSize;

/**
 文件创建时间
 */
@property (strong , nonatomic , readonly) NSDate *fileCreateDate;

/**
 文件修改时间
 */
@property (strong , nonatomic , readonly) NSDate *fileModificationDate;

/**
 是否是根目录
 */
@property (nonatomic, assign , readonly) BOOL isHomeDirectory;

/**
 是否是目录文件
 */
@property (nonatomic, assign, readonly)  BOOL  isDirectory;

/**
 是否隐藏文件
 */
@property (nonatomic, assign, readonly)  BOOL  isHidden;


#pragma mark - 自定义
@property (nonatomic, strong)  NSMutableArray <ZBDebuggerSandboxModel *> *subModels;

//文件类型描述
@property (nonatomic, strong, readonly)  NSString *fileTypeDesc;


/**
  文件大小字符串
 */
- (NSString *)fileSizeString;

/**
 文件夹大小,包括子文件夹
 */
- (NSString *)totalFileSizeString;

/**
 文件是否可以被浏览
 */
- (BOOL)isCanBePreview;
@end
