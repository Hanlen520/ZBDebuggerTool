//
//  ZBDeviceInfo.m
//  ZBDebuggerTool
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZBDeviceInfo.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <mach-o/arch.h>
// 下面是获取mac地址需要导入的头文件
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

// 下面是获取ip需要的头文件
#include <ifaddrs.h>


#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <arpa/inet.h>


@implementation ZBDeviceInfo
/**
 获取设备名称
 */
+ (NSString *)getDeviceName
{
    NSString *name = [UIDevice currentDevice].name;
    return name?: @"Unknown";;
}
/**
 获取设备系统版本
 */
+ (NSString *)getDeviceSystemVersion
{
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    return systemVersion?: @"Unknown";
}
/**
 获取设备类型
 */
+ (NSString *)getDevicePlatform
{
    NSString *platform = [self phonePlatformString];
    return platform;
}
/**
 获取设备语言
 */
+ (NSString *)getDeviceLanguage
{
    return [NSLocale preferredLanguages].firstObject ?: @"Unknown";
}
/**
 获取设备电量
 */
+ (NSString *)getDeviceBattery
{
    NSString *battery = [UIDevice currentDevice].batteryLevel != -1 ? [NSString stringWithFormat:@"%ld%%",(long)([UIDevice currentDevice].batteryLevel * 100)] : @"Unknown";
    return battery;
}
/**
 获取设备CPU类型
 */
+ (NSString *)getDeviceCPUType
{
    NSString *cputype = [self cpuTypeString];
    return cputype;
}
/**
 获取设备Disk
 */
+ (NSString *)getDeviceDisk
{
    NSString *disk = [NSString stringWithFormat:@" %@/%@/%@",
                       [NSByteCountFormatter stringFromByteCount:[self getUsedDiskSpace] countStyle:NSByteCountFormatterCountStyleFile],
                      [NSByteCountFormatter stringFromByteCount:[self getFreeDiskSpace] countStyle:NSByteCountFormatterCountStyleFile],
                      [NSByteCountFormatter stringFromByteCount:[self getTotalDiskSpace] countStyle:NSByteCountFormatterCountStyleFile]
                      ];
    return disk;
}
/**
 获取设备网络状态
 */
+ (NSString *)getDeviceNetworkState
{
    NSString *state = [self networkingStatesFromStatusbar];
    return state;
}
/**
 获取设备IP地址
 */
+ (NSString *)getDeviceIPAddress
{
    NSString *ipAddress = [self getDeviceCurrentIPAddresses];
    return ipAddress?:@"Unknown";
}
/**
 获取设备MAC地址
 */
+ (NSString *)getDeviceMACAddress
{
    NSString *macAddress = [self getMacAddress];
    return macAddress ?: @"Unknown";
}
/**
 获取设备的UUID
 */
+ (NSString *)getDeviceUUID
{
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return uuid;
}


#pragma mark -获取磁盘的空间
// 获取磁盘总空间
+ (int64_t)getTotalDiskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}
// 获取未使用的磁盘空间
+ (int64_t)getFreeDiskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}
// 获取已使用的磁盘空间
+ (int64_t)getUsedDiskSpace {
    int64_t totalDisk = [self getTotalDiskSpace];
    int64_t freeDisk = [self getFreeDiskSpace];
    if (totalDisk < 0 || freeDisk < 0) return -1;
    int64_t usedDisk = totalDisk - freeDisk;
    if (usedDisk < 0) usedDisk = -1;
    return usedDisk;
}


#pragma mark -CPU型号
+ (NSString *)cpuTypeString
{
   NSString *cpuSubtypeString = [NSString stringWithUTF8String:NXGetLocalArchInfo()->description];
    cpuSubtypeString = cpuSubtypeString ?:@"Unknown";
   return cpuSubtypeString;
}


#pragma mark - 网络状态
+ (NSString *)networkingStatesFromStatusbar {
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *children = nil;
    if ([[app valueForKeyPath:@"_statusBar"] isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")]) {
        children = [[[[app valueForKeyPath:@"_statusBar"] valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    } else {
        children = [[[app valueForKeyPath:@"_statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    }
    
    NSInteger type = 0;
    for (id child in children) {
        if ([child isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    
    NSString *stateString = @"WiFi";
    
    switch (type) {
        case 0:
            stateString = @"无网络";
            break;
        case 1:
            stateString = @"2G";
            break;
        case 2:
            stateString = @"3G";
            break;
        case 3:
            stateString = @"4G";
            break;
        case 4:
            stateString = @"LTE";
            break;
        case 5:
            stateString = @"WiFi";
            break;
        default:
            stateString = @"Unknown";
            break;
    }
    
    return stateString;
}

#pragma mark - 获取MAC地址
+ (NSString *)getMacAddress {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return [outstring uppercaseString];
}
#pragma mark - 获取IP地址
+ (NSString *)getDeviceCurrentIPAddresses {
    
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE = 4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    
    close(sockfd);
    NSString *deviceIP = @"";
    
    for (int i=0; i < ips.count; i++) {
        if (ips.count > 0) {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
    return deviceIP;
}



#pragma mark - 手机型号
+ (NSString *)phonePlatform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}
+ (NSString *)phonePlatformString
{
    NSString *platform = [self phonePlatform];
    if ([platform hasPrefix:@"iPhone"]) {
        if ([platform isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
        if ([platform isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
        if ([platform isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
        if ([platform isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
        if ([platform isEqualToString:@"iPhone10,6"])    return @"iPhone X";
        if ([platform isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
        if ([platform isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
        if ([platform isEqualToString:@"iPhone10,3"])    return @"iPhone X";
        if ([platform isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
        if ([platform isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
        if ([platform isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
        if ([platform isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
        if ([platform isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
        if ([platform isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
        if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
        if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
        if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
        if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
        if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
        if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
        if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
        if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
        if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
        if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
        if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
        if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
        if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
        if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
        if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
        if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
        if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
        if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
        
    } else if ([platform hasPrefix:@"iPad"]) {
        
        if ([platform isEqualToString:@"iPad7,1"])    return @"iPad Pro 12.9";
        if ([platform isEqualToString:@"iPad7,2"])    return @"iPad Pro 12.9";
        if ([platform isEqualToString:@"iPad7,3"])    return @"iPad Pro 10.5";
        if ([platform isEqualToString:@"iPad7,4"])    return @"iPad Pro 10.5";
        if ([platform isEqualToString:@"iPad6,8"])    return @"iPad Pro";
        if ([platform isEqualToString:@"iPad6,7"])    return @"iPad Pro";
        if ([platform isEqualToString:@"iPad6,4"])    return @"iPad Pro";
        if ([platform isEqualToString:@"iPad6,3"])    return @"iPad Pro";
        if ([platform isEqualToString:@"iPad5,4"])    return @"iPad Air2";
        if ([platform isEqualToString:@"iPad5,3"])    return @"iPad Air2";
        if ([platform isEqualToString:@"iPad5,2"])    return @"iPad Mini4";
        if ([platform isEqualToString:@"iPad5,1"])    return @"iPad Mini4";
        if ([platform isEqualToString:@"iPad4,9"])    return @"iPad Mini3";
        if ([platform isEqualToString:@"iPad4,8"])    return @"iPad Mini3";
        if ([platform isEqualToString:@"iPad4,7"])    return @"iPad Mini3";
        if ([platform isEqualToString:@"iPad4,6"])    return @"iPad Mini2";
        if ([platform isEqualToString:@"iPad4,5"])    return @"iPad Mini2";
        if ([platform isEqualToString:@"iPad4,4"])    return @"iPad Mini2";
        if ([platform isEqualToString:@"iPad4,3"])    return @"iPad Air";
        if ([platform isEqualToString:@"iPad4,2"])    return @"iPad Air";
        if ([platform isEqualToString:@"iPad4,1"])    return @"iPad Air";
        if ([platform isEqualToString:@"iPad3,6"])    return @"iPad 4";
        if ([platform isEqualToString:@"iPad3,5"])    return @"iPad 4";
        if ([platform isEqualToString:@"iPad3,4"])    return @"iPad 4";
        if ([platform isEqualToString:@"iPad3,3"])    return @"iPad 3";
        if ([platform isEqualToString:@"iPad3,2"])    return @"iPad 3";
        if ([platform isEqualToString:@"iPad3,1"])    return @"iPad 3";
        if ([platform isEqualToString:@"iPad2,7"])    return @"iPad Mini";
        if ([platform isEqualToString:@"iPad2,6"])    return @"iPad Mini";
        if ([platform isEqualToString:@"iPad2,5"])    return @"iPad Mini";
        if ([platform isEqualToString:@"iPad2,4"])    return @"iPad 2";
        if ([platform isEqualToString:@"iPad2,3"])    return @"iPad 2";
        if ([platform isEqualToString:@"iPad2,2"])    return @"iPad 2";
        if ([platform isEqualToString:@"iPad2,1"])    return @"iPad 2";
        if ([platform isEqualToString:@"iPad1,1"])    return @"iPad 1";
        
    } else if ([platform hasPrefix:@"iPod"]) {
        if ([platform isEqualToString:@"iPod7,1"])    return @"iPod 6";
        if ([platform isEqualToString:@"iPod5,1"])    return @"iPod 5";
        if ([platform isEqualToString:@"iPod4,1"])    return @"iPod 4";
        if ([platform isEqualToString:@"iPod3,1"])    return @"iPod 3";
        if ([platform isEqualToString:@"iPod2,1"])    return @"iPod 2";
        if ([platform isEqualToString:@"iPod1,1"])    return @"iPod 1";
    } else {
        if ([platform isEqualToString:@"i386"])       return @"simulator";
        if ([platform isEqualToString:@"x86_64"])     return @"simulator";
    }
    return @"unknown";
}
@end


