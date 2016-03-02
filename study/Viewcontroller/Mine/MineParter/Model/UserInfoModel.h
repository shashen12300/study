//
//  UserInfoModel.h
//  study
//
//  Created by mijibao on 16/1/28.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property (nonatomic, assign) NSInteger userId;//用户id
@property (nonatomic, copy) NSString *phone;//电话号码
@property (nonatomic, copy) NSString *nickname;//昵称
@property (nonatomic, copy) NSString *photo;//头像
@property (nonatomic, copy) NSString *picture;//背景图
@property (nonatomic, copy) NSString *type;//类型
@property (nonatomic, copy) NSString *gender;//性别
@property (nonatomic, copy) NSString *province;//省份
@property (nonatomic, copy) NSString *city;//城市
@property (nonatomic, copy) NSString *signature;//签名
@property (nonatomic, copy) NSString *age;//教龄
@property (nonatomic, copy) NSString *grade;//年级;
@property (nonatomic, copy) NSString *honors;//荣誉
@property (nonatomic, copy) NSString *subject;//擅长科目
@property (nonatomic, copy) NSString *photourl1;//动态图1
@property (nonatomic, copy) NSString *photourl2;//动态图2
@property (nonatomic, copy) NSString *photourl3;//动态图3
@property (nonatomic, copy) NSString *photourl4;//动态图4
@property (nonatomic, copy) NSString *video1;//教学视频图1
@property (nonatomic, copy) NSString *video2;//教学视频图2
@property (nonatomic, copy) NSString *video3;//教学视频图3
@property (nonatomic, copy) NSString *video4;//教学视频图4
@property (nonatomic, copy) NSString *rate;//答题率
@property (nonatomic, assign) NSInteger instantanswerCount;//答题数
@property (nonatomic, copy) NSString *isfriend;//是否为好友
@property (nonatomic, copy) NSString *isattention;//是否关注


@end
