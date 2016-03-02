//
//  AppDelegate.h
//  study
//
//  Created by mijibao on 16/1/14.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "QQ.h"
//#import "WXManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
//当前聊天对象
@property (copy,nonatomic)NSString *chatuserid;
@property (strong, nonatomic) QQ *qq;


@end

