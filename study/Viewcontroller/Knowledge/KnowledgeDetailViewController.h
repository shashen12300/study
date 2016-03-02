//
//  KnowledgeDetailViewController.h
//  study
//
//  Created by mijibao on 16/1/21.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,ChatToolViewState) {
    ChatToolViewStateShowFace,
    ChatToolViewStateShowShare,
    ChatToolViewStateShowNone,
};

@interface KnowledgeDetailViewController : BaseViewController

@property (nonatomic, copy) NSString *titleName; //视频的名字
@property (nonatomic, copy) NSString *lecrureid; //id

@end
