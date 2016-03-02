//
//  CommentModel.m
//  study
//
//  Created by mijibao on 16/1/25.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

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
