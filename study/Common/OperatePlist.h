//
//  OperatePlist.h
//  ComponentProject
//
//  Created by jzkj on 10/22/15.
//  Copyright © 2015 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperatePlist : NSObject
/**
 *  HTTP服务器地址
 */
+ (NSString *)HTTPServerAddress;
/**
 *  HTTP服务器端口
 */
+ (NSString *)HTTPServerPort;
/**
 *  OpenFire服务器地址
 */
+ (NSString *)OpenFireServerAddress;
/**
 *  OpenFire服务器端口
 */
+ (NSString *)OpenFireServerPort;
@end
