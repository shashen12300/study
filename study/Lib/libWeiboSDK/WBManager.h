//
//  WBManager.h
//  study
//
//  Created by mijibao on 16/2/23.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

@interface WBManager : NSObject<WeiboSDKDelegate>

@property (copy, nonatomic) NSString *accessToken;
@property (copy, nonatomic) NSString *loginSinaId;
@property (copy, nonatomic) NSString *refreshToken;
//微博登陆
- (void)sinaLogin;
//微博登陆结果
- (void)getWeiboLoginResult:(WBBaseResponse *)response;

@end
