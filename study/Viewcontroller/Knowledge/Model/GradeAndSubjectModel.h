//
//  GradeAndSubjectModel.h
//  study
//
//  Created by jiaozl on 15/8/31.
//  Copyright (c) 2015年 jiaozl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GradeAndSubjectModel : NSObject

@property (nonatomic, copy) NSString *gradeId;  //id
@property (nonatomic, copy) NSString *grade;    //年级拼音
@property (nonatomic, copy) NSString *gradeStr;  //年级
@property (nonatomic, strong) NSMutableArray *subjects;  // 存放课程信息

@end
