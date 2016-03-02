//
//  MinePartnerModel.h
//  study
//
//  Created by mijibao on 16/1/21.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MinePartnerModel : NSObject

@property (nonatomic, assign) NSInteger userId;//用户id
@property (nonatomic, copy) NSString *nickname;//昵称
@property (nonatomic, copy) NSString *phone;//手机号码
@property (nonatomic, copy) NSString *photo;//头像
@property (nonatomic, copy) NSString *type;//身份

@end
