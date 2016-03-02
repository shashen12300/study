//
//  LectureModel.h
//  study
//
//  Created by apples on 15/8/31.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LectureModel : NSObject

@property (nonatomic, copy) NSString *lecrureid; //课程id
@property (nonatomic, copy) NSString *picurl;      //图片url
@property (nonatomic, copy) NSString *duration;    //时长
@property (nonatomic, copy) NSString *title;       //标题
@property (nonatomic, copy) NSString *addTime;     //发布时间
@property (nonatomic, copy) NSString *grade;       //年级
@property (nonatomic, copy) NSString *subject;     //科目
@property (nonatomic, copy) NSString *buycount;    //购买次数
@property (nonatomic, copy) NSString *clickcount;  //点击次数
@property (nonatomic, copy) NSString *collectcount;//收藏次数
@property (nonatomic, copy) NSString *content;     //内容简介

@end
