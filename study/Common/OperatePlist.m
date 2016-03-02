//
//  OperatePlist.m
//  ComponentProject
//
//  Created by jzkj on 10/22/15.
//  Copyright © 2015 jzkj. All rights reserved.
//

#import "OperatePlist.h"

NSString *const SERVER_CONFIG_FILE = @"serverConfig";

@implementation OperatePlist
/**
 *  HTTP服务器地址
 */
+ (NSString *)HTTPServerAddress
{
    return [[self serverConfigInfo] objectForKey:@"HTTPServerAddress"];
}
/**
 *  HTTP服务器端口
 */
+ (NSString *)HTTPServerPort
{
    return [[self serverConfigInfo] objectForKey:@"HTTPServerPort"];
}
/**
 *  OpenFire服务器地址
 */
+ (NSString *)OpenFireServerAddress
{
    return [[self serverConfigInfo] objectForKey:@"OpenFireServerAddress"];
}
/**
 *  OpenFire服务器端口
 */
+ (NSString *)OpenFireServerPort
{
    return [[self serverConfigInfo] objectForKey:@"OpenFireServerPort"];
}

#pragma mark - Inner Method
/**
 *  得到"serverConfig.plist"的信息
 */
+ (NSDictionary *)serverConfigInfo
{
    NSDictionary *dict = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:SERVER_CONFIG_FILE ofType:@"plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return dict;
}

@end
