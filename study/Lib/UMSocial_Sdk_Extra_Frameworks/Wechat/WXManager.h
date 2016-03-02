//
//  WXManager.h
//  study
//
//  Created by mijibao on 16/2/22.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface WXManager : NSObject<WXApiDelegate>

- (void)wxLogin;
- (void)getWeiXinCodeFinishedWithResp:(BaseResp *)resp;

@end
