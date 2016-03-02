//
//  RelayMessageCell.h
//  study
//
//  Created by jzkj on 16/2/3.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "ChatMsgDTO.h"
#import "XMPPManager.h"
#import "HJChatImageView.h"
#import "JZUploadFile.h"

@interface RelayMessageCell : UITableViewCell

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
//修改选中状态
- (void)changeCellSelectState;

@end
