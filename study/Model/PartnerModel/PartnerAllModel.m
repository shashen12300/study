//
//  PartnerAllModel.m
//  study
//
//  Created by yang on 15/9/25.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "PartnerAllModel.h"

@implementation PartnerAllModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}

@end


@implementation PartnerPartModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _feedId = [value integerValue];
    }
}



@end