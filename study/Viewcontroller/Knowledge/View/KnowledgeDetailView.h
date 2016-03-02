//
//  KnowledgeDetailView.h
//  study
//
//  Created by mijibao on 16/1/21.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CEmojiView.h"
@protocol KnowledgeDetailViewDelegate <NSObject>

@end
@interface KnowledgeDetailView : UIView

@property (nonatomic, copy) NSString *titleName;//视频的名字
@property (nonatomic, copy) NSString *lecrureid; //id
@property (nonatomic, weak) id<KnowledgeDetailViewDelegate>delegate;

@end
