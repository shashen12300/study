//
//  PayTableViewCell.h
//  study
//
//  Created by mijibao on 16/1/28.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *pay;   //支付类型
@property (nonatomic, assign) BOOL select;     //是否选中

@end
