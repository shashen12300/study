//
//  LectureRootGroupModel.m
//  study
//
//  Created by mijibao on 16/2/16.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "LectureRootGroupModel.h"

#define kContentFont [UIFont systemFontOfSize:13] //内容字体

@implementation LectureRootGroupModel

+ (instancetype)cellLeafWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dict];
        NSDictionary *attributes = @{NSFontAttributeName:kContentFont};
        CGSize contentSize = [dict[@"name"] boundingRectWithSize:CGSizeMake(283, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    }
    return self;
}

@end
