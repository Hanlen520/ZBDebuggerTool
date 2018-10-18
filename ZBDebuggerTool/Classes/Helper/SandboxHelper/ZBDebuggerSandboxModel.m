//
//  ZBDebuggerSandboxModel.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerSandboxModel.h"
#import <QuickLook/QuickLook.h>

@implementation ZBDebuggerSandboxModel
/**
 初始化模型
 
 @param attributes 文件描述
 @param filePath 路径
 @return 模型
 */
- (instancetype)initWithAttributes:(NSDictionary *)attributes filePath:(NSString *)filePath
{
    if(self = [super init])
    {
        _filePath = filePath;
        _fileName =  [filePath lastPathComponent];
        _fileType = attributes[NSFileType];
        _fileSize = [attributes[NSFileSize] unsignedLongLongValue];
        _totalFileSize = _fileSize;
        _fileCreateDate = attributes[NSFileCreationDate];
        _fileModificationDate = attributes[NSFileModificationDate];
        _isDirectory = [_fileType isEqualToString:NSFileTypeDirectory];
        _isHidden = [attributes[NSFileExtensionHidden] boolValue];
        _isHomeDirectory = [filePath isEqualToString:NSHomeDirectory()];
        
    }
    return self;
}
/**
 文件大小字符串
 */
- (NSString *)fileSizeString
{
    return [NSByteCountFormatter stringFromByteCount:self.fileSize countStyle:NSByteCountFormatterCountStyleFile];
}

/**
 文件夹大小,包括子文件夹
 */
- (NSString *)totalFileSizeString
{
    return [NSByteCountFormatter stringFromByteCount:self.totalFileSize countStyle:NSByteCountFormatterCountStyleFile];
}


- (NSString *)fileTypeDesc
{
    NSString *fileTypeDesc = @"文件夹";
    if(self.isDirectory){
        fileTypeDesc = @"文件夹";
    }else{
        NSString *extension = self.filePath.pathExtension.lowercaseString;
        if([extension isEqualToString:@"docx"]){
            fileTypeDesc = @"doc文档";
        }else if([extension isEqualToString:@"jpeg"]||[extension isEqualToString:@"jpg"]||[extension isEqualToString:@"png"]){
            fileTypeDesc = @"图片";
        }else if([extension isEqualToString:@"mp4"]||[extension isEqualToString:@"m4v"]||[extension isEqualToString:@"MOV"]){
            fileTypeDesc = @"视频";
        }else if([extension isEqualToString:@"db"]||[extension isEqualToString:@"sqlite"]){
            fileTypeDesc = @"数据库";
        }else if([extension isEqualToString:@"PDF"]){
            fileTypeDesc = @"PDF文档";
        }else if([extension isEqualToString:@"xlsx"]){
            fileTypeDesc = @"xlsx文档";
        }else if([extension isEqualToString:@"rar"]||[extension isEqualToString:@"zip"]){
            fileTypeDesc = @"压缩包";
        }else if([extension isEqualToString:@"plist"]){
            fileTypeDesc = @"plist文件";
        }else{
            fileTypeDesc = @"未知类型";
        }
        
    }
    
    return fileTypeDesc;
}

/**
 文件是否可以被浏览
 */
- (BOOL)isCanBePreview
{
    BOOL ispreview = NO;
    ispreview = [QLPreviewController canPreviewItem:[NSURL fileURLWithPath:self.filePath]];
    return ispreview;
}
#pragma mark - Lazy load
- (NSMutableArray<ZBDebuggerSandboxModel *> *)subModels {
    if (!_subModels) {
        _subModels = [[NSMutableArray alloc] init];
    }
    return _subModels;
}
@end
