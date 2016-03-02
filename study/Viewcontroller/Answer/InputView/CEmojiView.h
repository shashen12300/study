//
//  CEmojiView.h
//  study
//
//  Created by jzkj on 15/10/14.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmojiViewDelegate <NSObject>
// 拼接表情字符
- (void)appendEmojiString:(NSString *)string;
// 表情删除按钮
- (void)deleteEmojiString;
@end

@interface CEmojiView : UIView <UIScrollViewDelegate>

//表情数组
@property (nonatomic, strong) NSMutableArray *faceArray;
//图片数组
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, weak) id <EmojiViewDelegate> delegate;

@end
