//
//  Lecture_saveModel.h
//  study
//
//  Created by mi jibao on 15/9/23.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lecture_saveModel : NSObject
@property (nonatomic,copy) NSString *lecrureid;  //课程的ID
@property (nonatomic,copy) NSString *lid;        //id
@property (nonatomic,copy) NSString *picurl;     //图片
@property (nonatomic,copy) NSString *duration;   //时长
@property (nonatomic,copy) NSString *title;      //课程标题
@property (nonatomic,copy) NSString *addTime;    //发布时间
@property (nonatomic,copy) NSString *stopTime;   //截止时间
@property (nonatomic,copy) NSString *grade;      //年级
@property (nonatomic,copy) NSString *subject;    //科目
@property (nonatomic)BOOL isSelect;              //是否选中

@end
