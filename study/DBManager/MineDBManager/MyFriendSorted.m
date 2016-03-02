//
//  MyFriendSorted.m
//  study
//
//  Created by mijibao on 15/10/12.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import "MyFriendSorted.h"
#import "MinePartnerModel.h"
@implementation MyFriendSorted

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

//按首字母分类汇总
- (NSMutableDictionary *)classifyContacts:(NSMutableArray *)array
{
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    for (MinePartnerModel *model in array) {
        NSString *name = model.nickname;
        NSMutableArray *tmpArr = [[NSMutableArray alloc]init];
        if (name != nil && name.length) {
            NSString *firstLetter = [[JZCommon getChineseSpelling:name] substringToIndex:1].uppercaseString;
            int intFirst = [firstLetter intValue];
            if (intFirst == 0) {
                tmpArr = [resultDict objectForKey:firstLetter];
            }else{
                tmpArr = [resultDict objectForKey:@"#"];
            }
            if (tmpArr) {
                [tmpArr addObject:model];
            } else {
                NSMutableArray *newArr = [NSMutableArray arrayWithObjects:model, nil];
                if (intFirst == 0) {
                    [resultDict setObject:newArr forKey:firstLetter];
                }else{
                    [resultDict setObject:newArr forKey:@"#"];
                }
            }
        }else if ([name isEqualToString:@""]){
            tmpArr = [resultDict objectForKey:@"#"];
            if (tmpArr) {
                [tmpArr addObject:model];
            }else{
                NSMutableArray *array = [NSMutableArray arrayWithObjects:model, nil];
                [resultDict setObject:array forKey:@"#"];
            }
        }
    }
    return resultDict;
}

@end
