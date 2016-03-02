//
//  LectureDetailModel.h
//  study
//
//  Created by apples on 15/9/7.
//   copyright (c) 2015年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LectureDetailModel : NSObject

@property (nonatomic, copy) NSString *addtime;   //开始时间
@property (nonatomic, copy) NSString *content;   //内容
@property (nonatomic, copy) NSString *duration;  //时长
@property (nonatomic, copy) NSString *expriretime; //结束时间
@property (nonatomic, copy) NSString *grade;      //年级
@property (nonatomic, copy) NSString *subject;    //科目
@property (nonatomic, copy) NSString *lecturer;   //讲师
@property (nonatomic, copy) NSString *picurl;     //图片
@property (nonatomic, copy) NSString *price;      //价格
@property (nonatomic, copy) NSString *source;     //来源
@property (nonatomic, copy) NSString *url;        //路径
@property (nonatomic, copy) NSString *buyYOrN;    //购买次数
@property (nonatomic, copy) NSString *collectYOrN;//收藏次数

@end
