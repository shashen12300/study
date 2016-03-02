//
//  QuestionModel.m
//  study
//
//  Created by jzkj on 16/2/14.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        self.Id = [NSString stringWithFormat:@"%@",value];
        return;
    }if ([key isEqualToString:@"userId"]) {
        self.userId = [NSString stringWithFormat:@"%@",value];
        return;
    }
    if ([key isEqualToString:@"phone"]) {
        self.phone = [NSString stringWithFormat:@"%@",value];
        return;
    }
    if ([key isEqualToString:@"status"]) {
        self.status = [NSString stringWithFormat:@"%@",value];
        return;
    }
    if ([key isEqualToString:@"teacherId"]) {
        self.teacherId = [NSString stringWithFormat:@"%@",value];
        return;
    }
    [super setValue:value forKey:key];
//    if ([key isEqualToString:@"Id"]) {
//        self.Id = [NSString stringWithFormat:@"%@",value];
//    }
    
}
@end
