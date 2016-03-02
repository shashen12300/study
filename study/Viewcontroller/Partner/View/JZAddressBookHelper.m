//
//  JZAddressBookCore+Classify.m
//  JZAddressBook
//
//  Created by jzkj on 15/9/15.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "JZAddressBookHelper.h"
#import "PinYin4Objc.h"
#import "PartnerFriendIndoModel.h"

@implementation JZAddressBookHelper

//得到name的首字母
- (NSString *)getFirstLetter:(NSString *)name
{
    NSMutableString *str = [NSMutableString stringWithString:name];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    
    NSString *firstLetter = [str substringToIndex:1].capitalizedString;
    NSRange uppercaseRange = [firstLetter rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet] options:NSLiteralSearch];
    if (uppercaseRange.location == NSNotFound) {
        return @"#";
    } else {
        return firstLetter.uppercaseString;
    }
    return firstLetter;
}

/**
 *  把contacts中的JZAddressBookContacts对象，根据首字母分组
 */
- (NSDictionary *)classifyContacts:(NSArray *)contacts
{
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    for (PartnerFriendIndoModel *model in contacts) {
        NSString *name = model.nickname;
        if (name != nil && name.length) {
            NSString *firstLetter = [self getFirstLetter:name];
            NSMutableArray *tmpArr = [resultDict objectForKey:firstLetter];
            if (tmpArr != nil) {
                [tmpArr addObject:model];
            } else {
                NSMutableArray *newArr = [NSMutableArray arrayWithObjects:model, nil];
                [resultDict setObject:newArr forKey:firstLetter];
            }
        }
    }
    return resultDict;
}

@end
