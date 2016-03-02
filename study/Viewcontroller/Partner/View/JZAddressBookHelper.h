//
//  JZAddressBookCore+Classify.h
//  JZAddressBook
//  通讯录分组
//  Created by jzkj on 15/9/15.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JZAddressBookHelper : NSObject

/**
 *  把contacts中的JZAddressBookContacts对象，根据首字母分组
 */
- (NSDictionary *)classifyContacts:(NSArray *)contacts;

@end
