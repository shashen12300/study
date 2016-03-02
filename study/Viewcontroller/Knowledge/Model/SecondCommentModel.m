//
//  SecondCommentModel.m
//  study
//
//  Created by mijibao on 16/2/17.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "SecondCommentModel.h"

@implementation SecondCommentModel

+ (instancetype)commentWithDict:(NSDictionary *)dict;
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
