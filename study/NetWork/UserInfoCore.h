//
//  UserInfoCore.h
//  study
//
//  Created by mijibao on 16/1/15.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserInfoCoreDelegate <NSObject>

- (void)passChangeResult:(NSString *)result;

@end

@interface UserInfoCore : NSObject
@property (nonatomic, weak) id<UserInfoCoreDelegate>delegate;

/**
 *  个人信息修改
 *
 *  @param userId  用户id
 *  @param infomation    修改后的信息
 *  @param infoKey 修改信息，网络请求的参数键值
 *  @param saveKey 修改信息保存到本地的键值
 *
 */
- (void)changeUserInfomationWithUserId:(NSString *)userId
                         newInfomation:(NSString *)infomation
                               infoKey:(NSString *)infokey
                               saveKey:(NSString *)saveKey;

/**
 *  用户手机号修改
 *
 *  @param oldPhone  用户旧手机号
 *  @param newPhone  用户新手机号
 *
 */

- (void)changeUserTelephone:(NSString *)oldPhone andNewPhone:(NSString *)newPhone;

/**
 *  用户地区修改
 *
 *  @param userId    用户Id
 *  @param province  省份
 *  @param city      城市
 *
 */
- (void)changeUserLocationWithUserId:(NSString *)userId
                        withProvince:(NSString *)province
                             andCity:(NSString *)city;

@end
