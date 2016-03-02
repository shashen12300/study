//
//  commentHeaderView.h
//  study
//
//  Created by mijibao on 16/1/25.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LectureDetailModel.h"

@interface CommentHeaderView : UIView

@property (nonatomic, copy) NSString *titleName;//视频的名字
@property (nonatomic, copy) NSString *lecrureid;    //课程id
@property (nonatomic, strong) LectureDetailModel *detailModel;  //model

@end
