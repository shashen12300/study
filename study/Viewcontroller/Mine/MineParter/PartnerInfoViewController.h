//
//  PartnerInfoViewController.h
//  study
//
//  Created by mijibao on 16/1/21.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "BaseViewController.h"

@interface PartnerInfoViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger partnerId;
@property (nonatomic, assign) NSString *partnerType;

@end
