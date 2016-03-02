//
//  GradeAndSubjectModel.m
//  study
//
//  Created by jiaozl on 15/8/31.
//  Copyright (c) 2015年 jiaozl. All rights reserved.
//

#import "GradeAndSubjectModel.h"

@implementation GradeAndSubjectModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.subjects = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

@end
