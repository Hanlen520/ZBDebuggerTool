//
//  ZBDebuggerSQLManger.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerSQLManger.h"
#import "ZBDebuggerToolMacros.h"
#import "FMDB.h"
#import "ZBDebuggerAppInfoHelper.h"
#import "ZBDebuggerNetworkModel.h"
#import "ZBDebuggerCrashModel.h"

static ZBDebuggerSQLManger *_instance = nil;

//创建表的table SQL
static NSString *const kCreateCrashModelTableSQL = @"CREATE TABLE IF NOT EXISTS CrashModelTable(ObjectData BLOB NOT NULL,Identity TEXT NOT NULL,LaunchDate TEXT NOT NULL);";

static NSString *const kCreateNetworkModelTableSQL = @"CREATE TABLE IF NOT EXISTS NetworkModelTable(ObjectData BLOB NOT NULL,Identity TEXT NOT NULL,LaunchDate TEXT NOT NULL);";

//表名
static NSString *const kCrashModelTable = @"CrashModelTable";
static NSString *const kNetworkModelLabel = @"NetworkModelTable";

// Column Name
static NSString *const kObjectDataColumn = @"ObjectData";
static NSString *const kIdentityColumn = @"Identity";
static NSString *const kLaunchDateColumn = @"launchDate";

@interface ZBDebuggerSQLManger()

@property (strong , nonatomic) FMDatabaseQueue * dbQueue;

@end
@implementation ZBDebuggerSQLManger
/**
 初始化数据库
 
 @return 操作数据库实例
 */
+ (instancetype)sharedSQLManger
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZBDebuggerSQLManger alloc] init];
        [_instance initinalSQLManger];
    });
    return _instance;
}
#pragma mark - 网络请求数据保存
/**
 保存网络请求模型
 
 @param model 模型
 @return 保存结果
 */
- (BOOL)saveNetworkModel:(ZBDebuggerNetworkModel *)model
{
    if(model == nil) return NO;
    NSString *launchDate = [[ZBDebuggerAppInfoHelper shareHelper] appLaunchDateTime];
    if (launchDate.length == 0) {
        return NO;
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    if (data.length == 0) {
        ZBDebuggerLog(@"ZBDebuggerSQLManger 网络模型归档数据 data is  nil");
        return NO;
    }
    __block NSArray *arguments = @[data,launchDate,model.identity];
    __block BOOL ret = NO;
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSError *error;
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@,%@,%@) VALUES (?,?,?);",kNetworkModelLabel,kObjectDataColumn,kLaunchDateColumn,kIdentityColumn];
        ret = [db executeUpdate:sql values:arguments error:&error];
        if (!ret) {
            ZBDebuggerLog(@"ZBDebuggerSQLMange 保存网络API失败,Error = %@",error.localizedDescription);
        }
    }];
    return ret;
}

/**
 获取所有网络请求模型
 */
- (NSArray<ZBDebuggerNetworkModel *> *)getAllNetworkModels
{
    NSString *launchDateTime = [[ZBDebuggerAppInfoHelper shareHelper] appLaunchDateTime];
    if (launchDateTime.length == 0) {
        return @[];
    }
    __block NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSError *error;
        FMResultSet *set = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",kNetworkModelLabel,kLaunchDateColumn] values:@[launchDateTime] error:&error];
        while ([set next]) {
            NSData *data = [set objectForColumn:kObjectDataColumn];
            ZBDebuggerNetworkModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (model) {
                [modelArray insertObject:model atIndex:0];
            }
        }
    }];
    return modelArray;
}



/**
 移除所有请求模型
 */
- (BOOL)removeAllNetworkModels
{
    NSArray *models = [self getAllNetworkModels];
    BOOL ret = YES;
    for (ZBDebuggerNetworkModel *model in models) {
        ret = ret && [self removeNetworkModel:model];
    }
    if(ret){
        ZBDebuggerLog(@"ZBDebuggerSQLMange 删除API列表 成功");
    }
    return ret;
}

/**
 移除网络请求模型
 */
- (BOOL)removeNetworkModel:(ZBDebuggerNetworkModel *)model
{
    __block BOOL ret = NO;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSError *error;
        ret = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",kNetworkModelLabel,kIdentityColumn] values:@[model.identity] error:&error];
        if (!ret) {
            ZBDebuggerLog(@"ZBDebuggerSQLMange 删除网络模型 失败");
        }
    }];
    return ret;
}
#pragma mark - crash数据保存

/**
 保存crash模型
 
 @param model 模型
 @return 保存结果
 */
- (BOOL)saveCrashModel:(ZBDebuggerCrashModel *)model
{
    if(model == nil) return NO;
    NSString *launchDate = [[ZBDebuggerAppInfoHelper shareHelper] appLaunchDateTime];
    if (launchDate.length == 0) {
        return NO;
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    if (data.length == 0) {
        ZBDebuggerLog(@"ZBDebuggerSQLManger crash data归档数据 data is  nil");
        return NO;
    }
    __block NSArray *arguments = @[data,launchDate,model.identity];
    __block BOOL ret = NO;
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSError *error;
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@,%@,%@) VALUES (?,?,?);",kCrashModelTable,kObjectDataColumn,kLaunchDateColumn,kIdentityColumn];
        ret = [db executeUpdate:sql values:arguments error:&error];
        if (!ret) {
            ZBDebuggerLog(@"ZBDebuggerSQLMange 保存crash 失败,Error = %@",error.localizedDescription);
        }else{
            ZBDebuggerLog(@"ZBDebuggerSQLMange 保存crash 成功");
        }
    }];
    return ret;
}

/**
 获取所有崩溃数据模型
 */
- (NSArray<ZBDebuggerCrashModel *> *)getAllCrashModels
{
    
    __block NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *set = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ ",kCrashModelTable]];
        while ([set next]) {
            NSData *data = [set objectForColumn:kObjectDataColumn];
            ZBDebuggerCrashModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (model) {
                [modelArray insertObject:model atIndex:0];
            }
        }
    }];
    return modelArray;
}

/**
 移除所有crash模型
 */
- (BOOL)removeAllCrashModels
{
    NSArray *models = [self getAllCrashModels];
    BOOL ret = YES;
    for (ZBDebuggerCrashModel *model in models) {
        ret = ret && [self removeCrashModel:model];
    }
    if(ret){
      ZBDebuggerLog(@"ZBDebuggerSQLMange 删除crash列表 成功");
    }
    return ret;
}


/**
 移除crash模型
 */
- (BOOL)removeCrashModel:(ZBDebuggerCrashModel *)model
{
    __block BOOL ret = NO;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSError *error;
        ret = [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",kCrashModelTable,kIdentityColumn] values:@[model.identity] error:&error];
        if (!ret) {
            ZBDebuggerLog(@"ZBDebuggerSQLMange 删除crash 失败");
        }
    }];
    return ret;
}









#pragma mark - private
- (void)initinalSQLManger
{
    BOOL  success = [self initialDBbase];
    NSAssert(success, @"数据库初始化失败");
    
}

//初始化数据库
- (BOOL)initialDBbase
{
    //1.文件夹路径
    BOOL createSuccess = NO;
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    docPath = [docPath stringByAppendingPathComponent:@"ZBDebuggerTool"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:docPath]){
        NSError *error = nil;
         BOOL  success =  [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:&error];
        if(error || !success){
            ZBDebuggerLog(@"ZBDebuggerSQLManger 创建文件失败 原因：%@",error.description);
        }
        NSAssert(!error, error.description);
    }
    
    //2.文件路径
    NSString *filePath= [docPath stringByAppendingPathComponent:@"ZBDebuggerTool.db"];
    
    //3.初始化数据库
    self.dbQueue = [self dbQueueWithPath:filePath];
    
    //4.创建表
    __block BOOL crashRet = NO;
    __block BOOL networkRet = NO;
    [self.dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        
        //初始化崩溃表
        crashRet = [db executeUpdate:kCreateCrashModelTableSQL];
        if (!crashRet) {
            ZBDebuggerLog(@"ZBDebuggerSQLManger 创建 crash收集表 失败");
        }
        //初始化网络表
        networkRet = [db executeUpdate:kCreateNetworkModelTableSQL];
        if (!networkRet) {
            ZBDebuggerLog(@"ZBDebuggerSQLManger 创建 网络API收集表 失败");
        }
    }];
    
    createSuccess = crashRet & networkRet;
    return createSuccess;
}

#pragma lazy
- (FMDatabaseQueue *)dbQueueWithPath:(NSString *)path
{
    if(_dbQueue == nil){
        _dbQueue  = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    return _dbQueue;
}
@end
