//
//  UIDevice+IdentifierAddition.m
//  JZDeviceIdentifier
//
//  Created by jzkj on 15/9/18.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "UIDevice+IdentifierAddition.h"
#import <sys/utsname.h>

@implementation UIDevice (IdentifierAddition)

- (NSString *)machineType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machineType = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([machineType isEqualToString:@"iPhone1,1"]) return @"100";
//        return @"iPhone 1G";
    if ([machineType isEqualToString:@"iPhone1,2"]) return @"101";
//        return @"iPhone 3G";
    if ([machineType isEqualToString:@"iPhone2,1"]) return @"102";
//        return @"iPhone 3GS";
    if ([machineType isEqualToString:@"iPhone3,1"]) return @"103";
//        return @"iPhone 4";
    if ([machineType isEqualToString:@"iPhone4,1"]) return @"104";
//        return @"iPhone 4S";
    if ([machineType isEqualToString:@"iPhone5,1"]) return @"105";
//        return @"iPhone 5(AT&T)";
    if ([machineType isEqualToString:@"iPhone5,2"]) return @"106";
//        return @"iPhone 5(GSM/CDMA)";
    if ([machineType isEqualToString:@"iPhone3,2"]) return @"107";
//        return @"Verizon iPhone 4";
    //iPod Touch
    if ([machineType isEqualToString:@"iPod1,1"])   return @"200";
//        return @"iPod Touch 1G";
    if ([machineType isEqualToString:@"iPod2,1"])   return @"201";
//        return @"iPod Touch 2G";
    if ([machineType isEqualToString:@"iPod3,1"])   return @"202";
//        return @"iPod Touch 3G";
    if ([machineType isEqualToString:@"iPod4,1"])   return @"203";
//        return @"iPod Touch 4G";
    if ([machineType isEqualToString:@"iPod5,1"])   return @"204";
//        return @"iPod Touch 5G";
    //iPad
    if ([machineType isEqualToString:@"iPad1,1"])   return @"300";
//        return @"iPad";
    if ([machineType isEqualToString:@"iPad2,1"])   return @"301";
//        return @"iPad 2 (WiFi)";
    if ([machineType isEqualToString:@"iPad2,2"])   return @"302";
//        return @"iPad 2 (GSM)";
    if ([machineType isEqualToString:@"iPad2,3"])   return @"303";
//        return @"iPad 2 (CDMA)";
    if ([machineType isEqualToString:@"iPad2,5"])   return @"304";
//        return @"iPad Mini (WiFi)";
    if ([machineType isEqualToString:@"iPad2,6"])   return @"305";
//        return @"iPad Mini (GSM)";
    if ([machineType isEqualToString:@"iPad2,7"])   return @"306";
//        return @"iPad Mini (CDMA)";
    if ([machineType isEqualToString:@"iPad3,1"])   return @"307";
//        return @"iPad 3 (WiFi)";
    if ([machineType isEqualToString:@"iPad3,2"])   return @"308";
//        return @"iPad 3 (GSM)";
    if ([machineType isEqualToString:@"iPad3,3"])   return @"309";
//        return @"iPad 3 (CDMA)";
    if ([machineType isEqualToString:@"iPad3,4"])   return @"310";
//        return @"iPad 4 (WiFi)";
    if ([machineType isEqualToString:@"iPad3,5"])   return @"311";
//        return @"iPad 4 (GSM)";
    if ([machineType isEqualToString:@"iPad3,6"])   return @"312";
//        return @"iPad 4 (CDMA)";
    //Simulator
    if ([machineType isEqualToString:@"i386"])  return @"400";
//        return @"Simulator";
    if ([machineType isEqualToString:@"x86_64"])    return @"401";
//        return @"Simulator";
    
//    return machineType;
    return @"1";
}

- (NSString *)ostype{
    UIDevice *device = [UIDevice currentDevice];
    NSString *os = [device systemVersion];
    NSArray *array = [os componentsSeparatedByString:@"."];
    NSString *ostype = @"iOS";
    if (array.count>0) {
        ostype = [NSString stringWithFormat:@"%@%@", ostype, [array objectAtIndex:0]];
    }
    return ostype;
}

@end
