//
//  QuestionModel.h
//  study
//
//  Created by jzkj on 16/2/14.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject
@property (nonatomic, copy) NSString * Id;//问题id
@property (nonatomic, copy) NSString * phone;//用户手机号
@property (nonatomic, copy) NSString * photo;//头像
@property (nonatomic, copy) NSString * userId;//用户id
@property (nonatomic, copy) NSString * grade;//班级
@property (nonatomic, copy) NSString * subject;//科目
@property (nonatomic, copy) NSString * content;//内容
@property (nonatomic, copy) NSString * pictureurl;//图片url
@property (nonatomic, copy) NSString * smpictureurl;//图片缩略图
@property (nonatomic, copy) NSString * audiourl;//语音url
@property (nonatomic, copy) NSString * teacherId;//老师id
@property (nonatomic, copy) NSString * duration;//语音时长
@property (nonatomic, copy) NSString * Addtime;//提问时间
@property (nonatomic, copy) NSString * type;//问题类型
@property (nonatomic, copy) NSString * status;//问题状态

@end
