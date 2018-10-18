//
//  ZBDebuggerAppInfoHelper.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDebuggerAppInfoHelper.h"
#import "ZBDeviceInfo.h"
#import <mach/mach_time.h>
#import <malloc/malloc.h>
#import <mach/mach_init.h>
#import <mach-o/arch.h>
#import <mach/mach_host.h>
#import <mach/mach.h>
#import "ZBDebuggerUntil.h"

static uint64_t loadTime;
static mach_timebase_info_data_t timebaseInfo;
static uint64_t applicationRespondedTime = -1;

static NSTimeInterval startLoadTime;
static uint64_t startLoadDate;
static inline NSTimeInterval MachTimeToSeconds(uint64_t machTime) {
    return ((machTime / 1e9) * timebaseInfo.numer) / timebaseInfo.denom;
}

static ZBDebuggerAppInfoHelper *_instance = nil;

@interface ZBDebuggerAppInfoHelper()

//cpu fps  memory 数据
@property (nonatomic, assign)  CGFloat fps;
@property (nonatomic, assign)  CGFloat cpu;
@property (nonatomic, assign)  unsigned long long usedMemory;
@property (nonatomic, assign)  unsigned long long freeMemory;
@property (nonatomic, assign)  unsigned long long totalMemory;
@property (nonatomic, assign)  NSUInteger fpsCount;
@property (nonatomic, assign)  NSTimeInterval fpsLastTime;
@property (nonatomic, strong)  NSString *launchDateTime;


//工具
@property (nonatomic , strong) NSTimer *memoryTimer;
@property (nonatomic , strong) CADisplayLink *fpslink;

@end

@implementation ZBDebuggerAppInfoHelper
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

+ (void)load
{
    //记录开始时间
    startLoadDate = [[NSDate date] timeIntervalSince1970];
    [self preloadData];
    
    
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.fps = 60;
    }
    return self;
}

//开始监听
- (void)startMonitoring
{
    [self stopfpsLink];
    [self stopMemoryTimer];
    [self startfpsLink];
    [self startMemoryTimer];
}

//停止监听
- (void)stopMonitoring
{
    [self stopfpsLink];
    [self stopMemoryTimer];
}
/**
 获取APPinfo 信息
 */
- (NSArray <NSDictionary *> *)getAppInfos;
{
    
    
    NSMutableArray  *infoArray = [NSMutableArray array];
    
    NSDictionary *infoSystemDict = [NSBundle mainBundle].infoDictionary;
    
    //APP名称
    NSString *appName = infoSystemDict[@"CFBundleDisplayName"] ?:  infoSystemDict[@"CFBundleName"]?:@"Unknown";
    
    //APP的bundleID
    NSString *bundleID = infoSystemDict[@"CFBundleIdentifier"] ?:@"Unknown";
    
    //app版本
    NSString *appversion = [NSString stringWithFormat:@"%@(%@)",infoSystemDict[@"CFBundleShortVersionString"]?:@"Unknown",infoSystemDict[@"CFBundleVersion"]?:@"Unknown"];
    
    //启动时间
    NSString *appLaunchTime =  [NSString stringWithFormat:@"%.2f s",startLoadTime];
    
    NSDictionary *appNameMDict = @{
                                   @"name":@"APP名称",
                                   @"value":appName,
                                   };
    [infoArray addObject:appNameMDict];
    
    NSDictionary *bandleIdDict = @{
                                   @"name":@"APP的唯一BundleID",
                                   @"value":bundleID,
                                   };
    [infoArray addObject:bandleIdDict];
    
    NSDictionary *appversionDict = @{
                                     @"name":@"APP版本号",
                                     @"value":appversion,
                                     };
    [infoArray addObject:appversionDict];
    
    NSDictionary *appLaunchTimeDict = @{
                                        @"name":@"APP启动时间",
                                        @"value":appLaunchTime,
                                        };
    [infoArray addObject:appLaunchTimeDict];
    
    
    NSDictionary *cpuDict = @{
                              @"name":@"CPU使用情况",
                               @"value":[NSString stringWithFormat:@"%0.2lf%%",self.cpu],
                              };
    [infoArray addObject:cpuDict];
    
    NSDictionary *fpsDict = @{
                              @"name":@"屏幕刷新率",
                              @"value":[NSString stringWithFormat:@"%0.2lf FPS",self.fps],
                              };
    [infoArray addObject:fpsDict];
    
    NSDictionary *useMDict = @{
                              @"name":@"APP使用内存",
                               @"value":[NSString stringWithFormat:@"%@",[NSByteCountFormatter stringFromByteCount:self.usedMemory countStyle:NSByteCountFormatterCountStyleMemory]],
                              };
    [infoArray addObject:useMDict];
    
    NSDictionary *freeMDict = @{
                               @"name":@"APP空闲内存",
                               @"value":[NSString stringWithFormat:@"%@",[NSByteCountFormatter stringFromByteCount:self.freeMemory countStyle:NSByteCountFormatterCountStyleMemory]],
                               };
    [infoArray addObject:freeMDict];
    
    NSDictionary *totalMDict = @{
                                @"name":@"APP总占用内存",
                                @"value":[NSString stringWithFormat:@"%@",[NSByteCountFormatter stringFromByteCount:self.totalMemory countStyle:NSByteCountFormatterCountStyleMemory]],
                                };
    [infoArray addObject:totalMDict];
    
    
    
    NSDictionary *platFormTimeDict = @{
                                        @"name":@"设备类型",
                                        @"value":[ZBDeviceInfo getDevicePlatform],
                                        };
    [infoArray addObject:platFormTimeDict];
    
    NSDictionary *getDeviceNameDict = @{
                                       @"name":@"设备名称",
                                       @"value":[ZBDeviceInfo getDeviceName],
                                       };
    [infoArray addObject:getDeviceNameDict];
    
    NSDictionary *ystemVersionDict = @{
                                        @"name":@"设备系统版本",
                                         @"value":[ZBDeviceInfo getDeviceSystemVersion],
                                        };
    [infoArray addObject:ystemVersionDict];
    
    NSDictionary *cpuTypeDict = @{
                                       @"name":@"设备CPU类型",
                                       @"value":[ZBDeviceInfo getDeviceCPUType],
                                       };
    [infoArray addObject:cpuTypeDict];
    
    NSDictionary *BatteryDict = @{
                                  @"name":@"设备电量使用情况",
                                  @"value":[ZBDeviceInfo getDeviceBattery],
                                  };
    [infoArray addObject:BatteryDict];
    
    NSDictionary *LanguageDict = @{
                                  @"name":@"设备当前使用语言",
                                   @"value":[ZBDeviceInfo getDeviceLanguage],
                                  };
    [infoArray addObject:LanguageDict];
    
    NSDictionary *DiskDict = @{
                                   @"name":@"存储使用情况",
                                   @"value":[ZBDeviceInfo getDeviceDisk],
                                   };
    [infoArray addObject:DiskDict];
    
    NSDictionary *NetworkStateDict = @{
                               @"name":@"设备网络状态",
                                @"value":[ZBDeviceInfo getDeviceNetworkState],
                               };
    [infoArray addObject:NetworkStateDict];
    
    NSDictionary *UUIDDict = @{
                               @"name":@"UUID",
                               @"value":[ZBDeviceInfo getDeviceUUID],
                              };
    [infoArray addObject:UUIDDict];
    
    NSDictionary *ipDict = @{
                               @"name":@"IP地址",
                               @"value":[ZBDeviceInfo getDeviceIPAddress],
                               };
    [infoArray addObject:ipDict];
    
    NSDictionary *macDict = @{
                             @"name":@"MAC地址",
                             @"value":[ZBDeviceInfo getDeviceMACAddress],
                             };
    [infoArray addObject:macDict];

  
    
    return infoArray;
   
}
/**
 获取APP启动时间
 */
- (NSString *)appLaunchDateTime
{
    if (!_launchDateTime) {
        _launchDateTime = [[ZBDebuggerUntil sharedDebuggerUntil] stringFromDate:[NSDate dateWithTimeIntervalSince1970:startLoadDate]];
        if (_launchDateTime == nil) {
            _launchDateTime = @"";
        }
    }
    return _launchDateTime;
}

#pragma mark - 定时器事件
- (void)startMemoryTimer
{
    self.memoryTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(memoryTimerEventAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.memoryTimer forMode:NSRunLoopCommonModes];
    
}
- (void)stopMemoryTimer
{
    if(self.memoryTimer){
        [self.memoryTimer invalidate];
        self.memoryTimer = nil;
    }
    
}
- (void)memoryTimerEventAction:(NSTimer *)timer
{
    struct mstats stat = mstats();
    self.usedMemory = stat.bytes_used;
    self.freeMemory = stat.bytes_free;
    self.totalMemory = stat.bytes_total;
    self.cpu = [self getCpuUsage];
    
    if ([[NSThread currentThread] isMainThread]) {
          [self postAppInfoDidUpdateAppInfosNotification];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postAppInfoDidUpdateAppInfosNotification];
        });
    }
}
- (void)postAppInfoDidUpdateAppInfosNotification {
    
    //app信息
    NSDictionary *appinfo = @{
                              ZBAppInfoHelperCPUKey:@(self.cpu),
                              ZBAppInfoHelperFPSKey:@(self.fps),
                              ZBAppInfoHelperUsedMemoryKey:@(self.usedMemory),
                              ZBAppInfoHelperFreeMemoryKey:@(self.freeMemory),
                              ZBAppInfoHelperTotalMemoryKey:@(self.totalMemory),
                              
                              };
    [[NSNotificationCenter defaultCenter] postNotificationName:ZBAppDidUpdateAppInfosNotificationName object:nil userInfo:appinfo];
}


#pragma mark - fps
- (void)startfpsLink
{
    self.fpslink = [CADisplayLink displayLinkWithTarget:self selector:@selector(fpsDisplayLinkEventAction:)];
    [self.fpslink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopfpsLink
{
    if(self.fpslink){
        [self.fpslink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [self.fpslink invalidate];
        self.fpslink = nil;
    }
}
- (void)fpsDisplayLinkEventAction:(CADisplayLink *)link
{
    if (self.fpsLastTime == 0) {
        self.fpsLastTime = link.timestamp;
        return;
    }
    self.fpsCount++;
    NSTimeInterval delta = link.timestamp - self.fpsLastTime;
    if (delta < 1) return;
    self.fpsLastTime = link.timestamp;
    self.fps = self.fpsCount / delta;
    self.fpsCount = 0;
}

#pragma mark - private
+ (void)preloadData
{
    //CPU的时钟周期数ticks
    loadTime = mach_absolute_time();
    mach_timebase_info(&timebaseInfo);
    
    @autoreleasepool {
        __block id<NSObject> observerblock;
        observerblock = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification
                        object:nil
                         queue:nil
                    usingBlock:^(NSNotification *note) {
                                                                          
                    [[NSNotificationCenter defaultCenter] removeObserver:observerblock];
                                                                          
                    dispatch_async(dispatch_get_main_queue(), ^{
                    //计算启动时间
                    applicationRespondedTime = mach_absolute_time();
                    startLoadTime = MachTimeToSeconds(applicationRespondedTime - loadTime);
                   });
                                                                          
            }];
    }
}

#pragma mark - 获取cpu 使用情况
- (CGFloat)getCpuUsage
{
    kern_return_t           kr;
    thread_array_t          thread_list;
    mach_msg_type_number_t  thread_count;
    thread_info_data_t      thinfo;
    mach_msg_type_number_t  thread_info_count;
    thread_basic_info_t     basic_info_th;
    
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    float cpu_usage = 0;
    
    for (int i = 0; i < thread_count; i++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[i], THREAD_BASIC_INFO,(thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE))
        {
            cpu_usage += basic_info_th->cpu_usage;
        }
    }
    
    cpu_usage = cpu_usage / (float)TH_USAGE_SCALE * 100.0;
    
    vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    return cpu_usage;
}



@end

//APP使用CPU
NSString * const ZBAppInfoHelperCPUKey = @"ZBAppInfoHelperCPUKey";
//APP使用内存
NSString * const ZBAppInfoHelperUsedMemoryKey = @"ZBAppInfoHelperUsedMemoryKey";
//APP使用空余内存
NSString * const ZBAppInfoHelperFreeMemoryKey = @"ZBAppInfoHelperFreeMemoryKey";
//APP总消耗内存
NSString * const ZBAppInfoHelperTotalMemoryKey = @"ZBAppInfoHelperTotalMemoryKey";
//APP的FPS
NSString * const ZBAppInfoHelperFPSKey = @"ZBAppInfoHelperFPSKey";
//APP名字
NSString * const ZBAppInfoHelperAPPNameKey = @"ZBAppInfoHelperAPPNameKey";
//APP版本
NSString * const ZBAppInfoHelperAPPVersionKey = @"ZBAppInfoHelperAPPVersionKey";
//APP启动时间
NSString * const ZBAppInfoHelperAPPStartTimeKey = @"ZBAppInfoHelperAPPStartTimeKey";
//APP的bundleID
NSString * const ZBAppInfoHelperAPPBundleIDKey = @"ZBAppInfoHelperAPPBundleIDKey";

//手机信息
//手机型号
NSString * const ZBAppInfoHelperPhoneTypeKey = @"ZBAppInfoHelperPhoneTypeKey";
//手机系统
NSString * const ZBAppInfoHelperPhoneSystemKey = @"ZBAppInfoHelperPhoneSystemKey";
//手机名称
NSString * const ZBAppInfoHelperPhoneNameKey = @"ZBAppInfoHelperPhoneNameKey";
//手机CPU类型
NSString * const ZBAppInfoHelperPhoneCPUTypeKey = @"ZBAppInfoHelperPhoneCPUTypeKey";
//手机电量
NSString * const ZBAppInfoHelperPhoneBatteryKey = @"ZBAppInfoHelperPhoneBatteryKey";
//手机语言
NSString * const ZBAppInfoHelperPhoneLangueKey = @"ZBAppInfoHelperPhoneLangueKey";
//手机容量
NSString * const ZBAppInfoHelperPhoneDiskKey = @"ZBAppInfoHelperPhoneDiskKey";
//手机网络状态
NSString * const ZBAppInfoHelperPhoneNetworkStateKey = @"ZBAppInfoHelperPhoneNetworkStateKey";
//手机UUID
NSString * const ZBAppInfoHelperPhoneUUIDKey = @"ZBAppInfoHelperPhoneUUIDKey";
//手机IP地址
NSString * const ZBAppInfoHelperPhoneIPAddressKey = @"ZBAppInfoHelperPhoneIPAddressKey";
//手机MAC地址
NSString * const ZBAppInfoHelperPhoneMacAddressKey = @"ZBAppInfoHelperPhoneMacAddressKey";
