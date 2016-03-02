//
//  RelayViewController.h
//  study
//
//  Created by jzkj on 16/2/3.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "BaseViewController.h"

@interface RelayViewController : BaseViewController
@property (nonatomic, copy) NSString *userId;//用户id
@property (nonatomic, copy) NSString *chatId;//聊天对象id
@property (nonatomic, copy) void(^deleteMessageBlock)();//删除消息回执
@end
