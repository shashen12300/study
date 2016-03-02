//
//  SharedObject.m
//  soul_ios
//
//  Created by jiaozl on 15/8/10.
//  Copyright (c) 2015年 soul. All rights reserved.
//

#import "SharedObject.h"
#import "GradeAndSubjectModel.h"
#import "UserInfoList.h"

@interface SharedObject()

@end

@implementation SharedObject

+ (id)sharedObject
{
    static SharedObject *__insQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __insQueue = [[SharedObject alloc] init];
        

    });
    
    return __insQueue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getGradeAndSubjectsList];
    }
    return self;
}

//获取年级学科表
- (void)getGradeAndSubjectsList{
    NSString *GradeAndSubjectPath = [[NSBundle mainBundle] pathForResource:@"GradeAndSubject" ofType:@"plist"];
    NSDictionary *GradeAndSubjectDic = [NSDictionary dictionaryWithContentsOfFile:GradeAndSubjectPath];
    
    NSArray *allGradeIDs = [[GradeAndSubjectDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result;
    }];
    
    _GradeAndSubjectList = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSString *gradeID in allGradeIDs) {
        NSDictionary *currentGradeAndSubjectDic = [GradeAndSubjectDic objectForKey:gradeID];
        GradeAndSubjectModel *aGradeAndeSubjectModel = [[GradeAndSubjectModel alloc] init];
        [aGradeAndeSubjectModel setValuesForKeysWithDictionary:currentGradeAndSubjectDic];
        [_GradeAndSubjectList addObject:aGradeAndeSubjectModel];
    }
}




@end
