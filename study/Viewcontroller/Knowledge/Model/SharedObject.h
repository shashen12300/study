//
//  SharedObject.h
//  soul_ios
//  单例类
//  Created by jiaozl on 15/8/10.
//  Copyright (c) 2015年 soul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedObject : NSObject

@property (nonatomic, copy) NSString *identityRecognition;  //身份,用于判断是学生还是老师
@property (nonatomic, strong, readonly) NSMutableArray *GradeAndSubjectList;  //所有的年级和科目信息

+ (id)sharedObject;

@end
