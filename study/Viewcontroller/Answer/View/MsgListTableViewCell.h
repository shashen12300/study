//
//  MsgListTableViewCell.h
//  jinherIU
//  消息列表单元格视图
//  Created by mijibao on 14-6-16.
//  Copyright (c) 2014年 Beyondsoft. All rights reserved.

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "ChatMsgDTO.h"
#import "XMPPManager.h"
#import "HJChatImageView.h"
#import "JZUploadFile.h"
//#import "JHContentLabel.h"
//#import "LASIImageView.h"
//#import "ContactsView.h"
//#import "IconDownload.h"
//#import "NSAttributedString+Attributes.h"
//#import "MarkupParser.h"
//#import "OHAttributedLabel.h"
//#import "CustomMethod.h"

@class OHAttributedLabel;
@class MsgListTableViewCell;

@protocol MsgListTableViewCellDelegate <NSObject>
//刷新图片
- (void)reloadImageInLoadSuccess;
//显示大图
- (void)showImageInMsgListTableViewCell:(MsgListTableViewCell *)cell;
//显示用户信息
- (void)pushToUserInfoView:(NSString *)userid;
//播放视频
- (void)playVideoInMsgListTableViewCell:(MsgListTableViewCell *)cell;
//下载视频
- (void)DownLoadVideoInMsgListTableViewCell:(MsgListTableViewCell *)cell;
//播放语音
// 播放语音
- (void)playVoiceMessage:(MsgListTableViewCell *)cell;
@end

@interface MsgListTableViewCell : UITableViewCell<SDWebImageManagerDelegate> {
    
    BOOL singleLine;
}

-(void)initcellView;

@property(strong, nonatomic)UIImageView *headIcon;//头像
@property(strong, nonatomic)UILabel *timeLable;//时间
@property(strong, nonatomic)UILabel *nameLable;//名字
@property(strong, nonatomic)UIButton *chatMsgBg;//地图
@property(strong, nonatomic)UIView *conView;//内容视图
@property(strong, nonatomic)MLEmojiLabel *msgLabel;//内容
@property(strong, nonatomic)HJChatImageView *imgView;//图
@property(strong, nonatomic)UIImageView *soundImageView;//语音
@property(strong, nonatomic)HJChatImageView *videoImageView;//视频图
@property(strong, nonatomic)UIButton *successViewButton;//失败标点
@property(assign, nonatomic)id<MsgListTableViewCellDelegate> delegate;//代理
@property(strong, nonatomic)ChatMsgDTO *msgDto;//消息
@property(strong, nonatomic)UIImageView *playImageView;//播放图
@property(strong, nonatomic)UIButton *DownLoadButton;//下载BTN
@property(strong, nonatomic)UITapGestureRecognizer *downloadTap;//手势
@property(strong, nonatomic)UILabel *audioTimeLengthLabel;//显示声音时间
@property(strong, nonatomic)UILabel *locationLabel;
@property(nonatomic)BOOL paushToother;
@property(nonatomic, strong)UIActivityIndicatorView *avi;//转圈等待
@property(nonatomic)BOOL isShowName;
@property(nonatomic)BOOL isShowTime;
@property(strong, nonatomic)NSDictionary *emojiDic;//表情字典
@property(assign) BOOL isSuccess;
@property (nonatomic, strong) JZUploadFile *uploadFile;//上传视频
//列表高度
- (CGSize)heightForMessageContent:(NSString*)messageContent;
//隐藏红点
- (void)hideReddot;


@end
