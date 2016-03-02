//
//  SecondCommentButton.h
//  study
//
//  Created by mijibao on 16/2/18.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondCommentModel.h"
@interface SecondCommentButton : UIButton

@property (nonatomic, strong) SecondCommentModel *message; //消息
@property (nonatomic, assign) CGFloat cellHeight;   //cell高度

@end
