//
//  LectureLeafModel.m
//  study
//
//  Created by mijibao on 16/2/16.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "LectureLeafModel.h"

@implementation LectureLeafModel

+ (instancetype)insLeafWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
