//
//  PayTableViewCell.m
//  study
//
//  Created by mijibao on 16/1/28.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "PayTableViewCell.h"

@interface PayTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *payImageView;  //支付logo
@property (weak, nonatomic) IBOutlet UILabel *payContent;        //支付类型
@property (weak, nonatomic) IBOutlet UIButton *payStatusBtn;     //选择类型

@end
@implementation PayTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"KView" owner:self options:nil]objectAtIndex:4];
    }
    return self;
}

// setter
- (void)setPay:(NSString *)pay {
    _pay = pay;
    if ([pay isEqualToString:@"微信支付"]) {
        _payImageView.image = [UIImage imageNamed:@"weixin"];
    }else if ([pay isEqualToString:@"支付宝支付"]) {
        _payImageView.image = [UIImage imageNamed:@"zhifubao"];
    }else if ([pay isEqualToString:@"QQ钱包支付"]) {
        _payImageView.image = [UIImage imageNamed:@"qq"];
    }else if ([pay isEqualToString:@"余额支付"]) {
        _payImageView.image = [UIImage imageNamed:@"yue"];
    }
    _payContent.text = pay;

}

- (void)setSelect:(BOOL)select {
    _select = select;
    _payStatusBtn.selected = select;
}

@end
