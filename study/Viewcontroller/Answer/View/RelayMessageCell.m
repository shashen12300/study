//
//  RelayMessageCell.m
//  study
//
//  Created by jzkj on 16/2/3.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "RelayMessageCell.h"
#import "AppDelegate.h"
#import "JHCacheManager.h"
#import "MyCustomView.h"
#import "RegexKitLite.h"
#import "AFNetworking.h"
//消息行上下边栏空留高度
#define kPaddingHeight 2.0f
#define kHeight 5.0f
#define imgW 35
#define space 13
#define maxChatWidth 200
#define padding 10
#define maximgWidth 113
#define maximgHeight 120
#define HEAD_SIZE 50.0f
#define TEXT_MAX_HEIGHT 500.0f
#define INSETS 8.0f
#define vedioimgWidth 110
#define vedioimgHeight 130


@interface RelayMessageCell (){
    UIImageView *_selectMessage;//选中图标
}

@end

@implementation RelayMessageCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutCellSubView];
    }
    return self;
}

- (void)layoutCellSubView{
    _selectMessage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 24, 24)];
    _selectMessage.image = [UIImage imageNamed:@"zhifu"];
    [self.contentView addSubview:_selectMessage];
    self.timeLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.timeLable.textColor=[UIColor whiteColor];
    self.timeLable.font=[UIFont boldSystemFontOfSize:12];
    self.timeLable.layer.cornerRadius = 5;
    self.timeLable.layer.masksToBounds = YES;
    self.timeLable.textAlignment = NSTextAlignmentCenter;
    [self.timeLable setBackgroundColor:[UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/225.0 alpha:1]];
    [self.contentView addSubview:self.timeLable];
    //头像
    self.headIcon=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imgW, imgW)];
    self.headIcon.image = [UIImage imageNamed:@"defaultChatIcon"];
    
    //头像点击事件
    UIButton * headIcoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.headIcon.frame.size.width, self.headIcon.frame.size.height)];
    [self.headIcon addSubview:headIcoBtn];
    
    //内容背景
    self.chatMsgBg = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.contentView addSubview:self.headIcon];
    [self.contentView addSubview:self.nameLable];
    [self.contentView addSubview:self.chatMsgBg];
    self.chatMsgBg.userInteractionEnabled = NO;
    //声音在背景图外显示时长
    _audioTimeLengthLabel=[[UILabel alloc]init];
    _audioTimeLengthLabel.backgroundColor = [UIColor clearColor];
    _audioTimeLengthLabel.font=[UIFont systemFontOfSize:14];
    [_audioTimeLengthLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.contentView addSubview:_audioTimeLengthLabel];

}
//改变图标
- (void)changeCellSelectState{
    if (self.msgDto.isSelect) {
        _selectMessage.image = [UIImage imageNamed:@"selectzhifu"];
    }else
        _selectMessage.image = [UIImage imageNamed:@"zhifu"];
}
-(void)initcellView{
    if(self.isShowTime){
        //消息时间
        NSString *timeStr=[JZCommon showTimeString:self.msgDto.sendtime];
        CGSize timeStrTextSize = [JZCommon getTextSize:timeStr textFont:12 textMaxWidth:125];
        self.timeLable.frame = CGRectMake((Main_Width-20-timeStrTextSize.width)/2, 5, timeStrTextSize.width+20, 25);
        self.timeLable.text=timeStr;
        _selectMessage.frame = CGRectMake(10, 30, 24, 24);
    }else{
        self.timeLable.frame = CGRectMake(0,0,0,0);
        _selectMessage.frame = CGRectMake(10, 0, 24, 24);
    }
    
    //名字
    NSString *username = @"haha";
    CGSize nameStrTextSize = [JZCommon getTextSize:username textFont:12 textMaxWidth:maxChatWidth];
    
    self.nameLable=[[UILabel alloc]initWithFrame:CGRectMake((Main_Width-20-nameStrTextSize.width)/2, 5, nameStrTextSize.width+20, 15)];
    self.nameLable.textAlignment = NSTextAlignmentLeft;
    self.nameLable.text=username;
    self.nameLable.backgroundColor = [UIColor clearColor];
    self.nameLable.textColor=UIColorFromRGB(0x7d90a4);
    self.nameLable.font=[UIFont systemFontOfSize:12];
    
    //内容视图
    [self.msgLabel removeFromSuperview];
    [self.conView removeFromSuperview];
    self.conView = [self chatContentView:self.msgDto];
    self.conView.userInteractionEnabled = YES;
    
    CGSize textSize = {self.conView.frame.size.width,self.conView.frame.size.height};
    
    CGFloat chatMsgBackWidth;
    CGFloat chatMsgBackHeight;
    //图片、视频、位置、名片
    if(self.msgDto.filetype==2 || self.msgDto.filetype==3 || self.msgDto.filetype == 6 || self.msgDto.filetype==4 || self.msgDto.filetype==5){
        //发送
        chatMsgBackHeight = textSize.height+kHeight>imgW?textSize.height+kHeight:imgW;
        chatMsgBackWidth = textSize.width+kHeight;
    }
    //其他
    else{
        chatMsgBackHeight = textSize.height+kHeight>imgW?textSize.height+kHeight:imgW;
        chatMsgBackWidth = textSize.width+padding*2+10;
    }
    //发送消息显示在右边
    if(self.msgDto.sendtype==0){
        [self.headIcon setFrame:CGRectMake(Main_Width-imgW-space, self.timeLable.frame.origin.y+self.timeLable.frame.size.height+5, imgW, imgW)];
        
        UIImage *rightimage=[UIImage imageNamed:@"chat_to_bg_normal"];
        rightimage = [rightimage stretchableImageWithLeftCapWidth:10 topCapHeight:30];
        [self.chatMsgBg setBackgroundImage:rightimage forState:UIControlStateNormal];

        [self.chatMsgBg setFrame:CGRectMake(self.headIcon.frame.origin.x-chatMsgBackWidth, self.headIcon.frame.origin.y, chatMsgBackWidth,chatMsgBackHeight )];
        
        self.avi=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.avi setHidesWhenStopped:YES];
        self.avi.frame=CGRectMake(self.chatMsgBg.frame.origin.x-40, self.chatMsgBg.frame.origin.y+(self.chatMsgBg.frame.size.height-20)/2, 20, 20);
        self.avi.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:self.avi];
        [self.avi startAnimating];
        
        if(_msgDto.success==3)
        {
            //断网显示红点
            Reachability *r = [Reachability reachabilityWithHostname:@"www.baidu.com"];
            if ([r currentReachabilityStatus] == NotReachable) {
                _msgDto.success=0;
            }
            //有网判断时间超过3分钟判定为失败
            else
            {
                NSDate *date=[JZCommon stringToDate:_msgDto.sendtime format:@"yyyy-MM-dd HH:mm:ss.SSS"];
                NSString * mm = [JZCommon dateToString:date format:@"mm"];
                NSString * HH = [JZCommon dateToString:date format:@"HH"];
                NSString * mm1 = [JZCommon dateToString:[NSDate date] format:@"mm"];
                NSString * HH1 = [JZCommon dateToString:[NSDate date] format:@"HH"];
                if (![HH1 isEqualToString:HH]) {
                    _msgDto.success = 0;
                }
                else if(([mm1 intValue]-[mm intValue])>3)
                {
                    _msgDto.success = 0;
                }
            }
        }
        //发送失败
        if(self.msgDto.success==0){
            self.successViewButton = nil;
            [self.avi stopAnimating];
            if (!self.successViewButton) {
                self.successViewButton=[[UIButton alloc]initWithFrame:CGRectMake(self.chatMsgBg.frame.origin.x-20, self.chatMsgBg.frame.origin.y+(self.chatMsgBg.frame.size.height-20)/2, 20, 20)];
                [self.successViewButton setBackgroundImage:[UIImage imageNamed:@"ic_send_fail.png"] forState:UIControlStateNormal];
                [self.contentView addSubview:self.successViewButton];
            }
            else {
                [self.successViewButton setFrame:CGRectMake(self.chatMsgBg.frame.origin.x-20, self.chatMsgBg.frame.origin.y+(self.chatMsgBg.frame.size.height-20)/2, 20, 20)];
                [self.successViewButton setBackgroundImage:[UIImage imageNamed:@"ic_send_fail.png"] forState:UIControlStateNormal];
            }
            if (self.msgDto.filetype == 1) {
                CGRect btnframe = self.successViewButton.frame;
                btnframe.origin.x -= 35;
                self.successViewButton.frame = btnframe;
            }
        }else if (self.msgDto.success==1)
        {
            [self.avi stopAnimating];
        }
        [self.nameLable setHidden:YES];
    }
    //接受消息在左边
    else{
        [self.headIcon setFrame:CGRectMake(35 + space, self.timeLable.frame.origin.y+self.timeLable.frame.size.height+5, imgW, imgW)];
        
        [self.nameLable setFrame:CGRectMake(self.headIcon.frame.origin.x+self.headIcon.frame.size.width+15, self.headIcon.frame.origin.y, maxChatWidth, 15)];
        if (!self.isShowName) {
            [self.nameLable setFrame:CGRectMake(self.headIcon.frame.origin.x+self.headIcon.frame.size.width+5, self.headIcon.frame.origin.y, maxChatWidth, 0)];
            [self.nameLable setHidden:YES];
        }
        UIImage *leftimage=[UIImage imageNamed:@"chat_from_bg_normal"];
        leftimage = [leftimage stretchableImageWithLeftCapWidth:10 topCapHeight:30];
        [self.chatMsgBg setBackgroundImage:leftimage forState:UIControlStateNormal];
        [self.chatMsgBg setFrame:CGRectMake(self.headIcon.frame.origin.x+self.headIcon.frame.size.width+5, self.headIcon.frame.origin.y+self.nameLable.frame.size.height+5, chatMsgBackWidth, chatMsgBackHeight)];
        if (!self.isShowName) {
            [self.chatMsgBg setFrame:CGRectMake(self.headIcon.frame.origin.x+self.headIcon.frame.size.width+5, self.headIcon.frame.origin.y, chatMsgBackWidth, chatMsgBackHeight)];
        }
        
    }
    [self.chatMsgBg addSubview:self.conView];
    _audioTimeLengthLabel.hidden = YES;
    //语音
    if (self.msgDto.filetype==1) {
        _audioTimeLengthLabel.hidden = NO;
        _audioTimeLengthLabel.text=self.msgDto.duration?[NSString stringWithFormat:@"%ld ''",(long)[self.msgDto.duration integerValue]]:@"未知";
        //接收
        if (self.msgDto.sendtype==1) {
            _audioTimeLengthLabel.frame = CGRectMake(self.chatMsgBg.frame.origin.x+self.chatMsgBg.frame.size.width+5, self.chatMsgBg.frame.origin.y+(self.chatMsgBg.frame.size.height-14)/2, 50, 14);
            _audioTimeLengthLabel.textAlignment = NSTextAlignmentLeft;
            [_audioTimeLengthLabel setHidden:NO];
            //如果消息未读则显示红点
            if ([@"0" isEqualToString:[NSString stringWithFormat:@"%@",self.msgDto.isread]])
            {
                if (!self.successViewButton) {
                    self.successViewButton=[[UIButton alloc]initWithFrame:CGRectMake(self.chatMsgBg.frame.origin.x+self.chatMsgBg.frame.size.width+35, self.chatMsgBg.frame.origin.y+(self.chatMsgBg.frame.size.height-10)/2, 10, 10)];
                    [self.successViewButton setBackgroundImage:[UIImage imageNamed:@"ic_weidu.9.png"] forState:UIControlStateNormal];
                    [self.contentView addSubview:self.successViewButton];
                }
                else {
                    [self.successViewButton setBackgroundImage:[UIImage imageNamed:@"ic_weidu.9.png"] forState:UIControlStateNormal];
                    [self.successViewButton setFrame:CGRectMake(self.chatMsgBg.frame.origin.x+self.chatMsgBg.frame.size.width+35, self.chatMsgBg.frame.origin.y+(self.chatMsgBg.frame.size.height-10)/2, 10, 10)];
                }
                [self.successViewButton setHidden:NO];
            }else {
                if (self.successViewButton) {
                    [self.successViewButton setHidden:YES];
                }
            }
        }
        //发送
        else {
            [_audioTimeLengthLabel setFrame:CGRectMake(self.chatMsgBg.frame.origin.x-55, self.chatMsgBg.frame.origin.y+(self.chatMsgBg.frame.size.height-14)/2, 50, 14)];
            _audioTimeLengthLabel.textAlignment = NSTextAlignmentRight;
            if(self.msgDto.success==0){
                [_audioTimeLengthLabel setHidden:NO];
            }
            else if (self.msgDto.success==3)
            {
                if (!self.avi) {
                    self.avi=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                }
                self.avi.frame=CGRectMake(self.chatMsgBg.frame.origin.x-40, self.chatMsgBg.frame.origin.y+(self.chatMsgBg.frame.size.height-20)/2, 20, 20);
                if (self.msgDto.filetype==1) {
                    self.avi.frame=CGRectMake(_audioTimeLengthLabel.frame.origin.x-5, self.chatMsgBg.frame.origin.y+(self.chatMsgBg.frame.size.height-20)/2, 20, 20);
                }
                self.avi.backgroundColor =[UIColor clearColor];
                //                [self.contentView addSubview:self.avi];
                [self.avi startAnimating];
            }
            else {
                [_audioTimeLengthLabel setHidden:NO];
            }
        }
    }
}
//隐藏红点
- (void)hideReddot {
    if (self.successViewButton) {
        [self.successViewButton setHidden:YES];
    }
}



- (AppDelegate *)appDelegate {
    
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

//消息内容
- (UIView *)chatContentView:(ChatMsgDTO *)msg {
    
    UIView *conView=[[UIView alloc]init];
    conView.userInteractionEnabled=YES;
    CGRect conframe;
    //语音
    if(msg.filetype==1){
        conframe=CGRectMake(padding+5, 3, 0, 0);
    }
    //图片视频、位置
    else if(msg.filetype==2||msg.filetype==3 || msg.filetype == 6 || msg.filetype==4 || msg.filetype==5){
        conframe=CGRectMake(0 , 0, 0, 0);
    }
    //其他
    else{
        conframe=CGRectMake(padding+5, kPaddingHeight+4, 0, 0);
        //发送
        if(msg.sendtype==0){
            conframe=CGRectMake(padding, kPaddingHeight+4, 0, 0);
        }
    }
    //文本消息
    if(msg.filetype==0){
        self.msgLabel=[MLEmojiLabel new];
        self.msgLabel.numberOfLines = 0;
        self.msgLabel.disableThreeCommon = YES;
        self.msgLabel.font = [UIFont systemFontOfSize:15];
        //        self.msgLabel.delegate = self;
        self.msgLabel.backgroundColor = [UIColor clearColor];
        self.msgLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.msgLabel.textColor = UIColorFromRGB(0x656564);
        
        self.msgLabel.isNeedAtAndPoundSign = YES;
        self.msgLabel.disableEmoji = NO;
        self.msgLabel.lineSpacing = 0.0f;
        self.msgLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        self.msgLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        self.msgLabel.customEmojiPlistName = @"expressionImage_custom.plist";
        
        [self.msgLabel setText:msg.content];
        CGSize textSize = [self heightForMessageContent:msg.content];
        [self.msgLabel setFrame:CGRectMake(conframe.origin.x , conframe.origin.y, textSize.width, textSize.height)];
        conframe.size.height = self.msgLabel.frame.size.height+5;
        conframe.size.width = textSize.width;
        [self bringSubviewToFront:conView];
        [self.chatMsgBg addSubview:self.msgLabel];
    }
    //语音
    else if (msg.filetype==1){
        self.soundImageView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 20, 25)];
        if(msg.sendtype==0){
            //发送 右
            self.soundImageView.image=[UIImage imageNamed:@"chat_right_voice3.png"];
            self.soundImageView.animationImages = [NSArray arrayWithObjects:
                                                   [UIImage imageNamed:@"chat_right_voice1.png"],
                                                   [UIImage imageNamed:@"chat_right_voice2.png"],
                                                   [UIImage imageNamed:@"chat_right_voice3.png"],nil];
            [self.soundImageView setAnimationDuration:1.0f];
            [self.soundImageView setAnimationRepeatCount:0];
            [self.soundImageView stopAnimating];
            
        }else{
            //接收 左
            self.soundImageView.image=[UIImage imageNamed:@"chat_left_voice3"];
            self.soundImageView.animationImages = [NSArray arrayWithObjects:
                                                   [UIImage imageNamed:@"chat_left_voice1"],[UIImage imageNamed:@"chat_left_voice2"],[UIImage imageNamed:@"chat_left_voice3"],nil];
            [self.soundImageView setAnimationDuration:1.0f];
            [self.soundImageView setAnimationRepeatCount:0];
            [self.soundImageView stopAnimating];
        }
        NSInteger voiceLength = [msg.duration integerValue];
        if (voiceLength > 60) {
            voiceLength = 60;
        }
        else if (voiceLength < 1)  {
            voiceLength = 1;
        }
        //发送
        if(msg.sendtype==0){
            conframe = CGRectMake(40.0+voiceLength*1.5-15, 3, 0, 0);
            self.soundImageView.frame = CGRectMake(8, 2, 20, 25);
        }
        conframe.size.width=40.0+voiceLength*1.5;
        conframe.size.height=25;
        
        [conView addSubview:self.soundImageView];
    }
    //图片
    else if (msg.filetype==2){
        //开始显示默认图片
        if (msg.sendtype == 0) {
            self.imgView=[[HJChatImageView alloc] initWithImageStyle:HJChatImageStyleRight Frame:CGRectMake(0, 0, 5, 5)];
        }else{
            self.imgView=[[HJChatImageView alloc] initWithImageStyle:HJChatImageStyleLeft Frame:CGRectMake(0, 0, 5, 5)];
        }
        
        self.imgView.image = [UIImage imageNamed:@"image_damage"];
        self.imgView.image = [UIImage imageWithContentsOfFile:msg.localpath];
        UIImage * cacheImg = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[JZCommon getFileDownloadPath:msg.url]];
        if (!cacheImg) {
            SDWebImageManager * manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString: [JZCommon getFileDownloadPath:msg.url]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (error) {
                    NSLog(@"图像下载失败");
                    return ;
                }
                
                self.imgView.image = image;
                //长图处理
                if (image.size.width>image.size.height*4||image.size.height>image.size.width*4)
                {
                    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
                    self.imgView.layer.masksToBounds = YES;
                }
//                if ([self.delegate respondsToSelector:@selector(reloadImageInLoadSuccess)]) {
//                    [self.delegate reloadImageInLoadSuccess];
//                }
            }];
        }else {
            self.imgView.image = cacheImg;
        }
        CGSize maxzSize = {maximgWidth,maximgHeight};
        CGSize imgSize = {self.imgView.image.size.width,self.imgView.image.size.height};
        imgSize=[JZCommon imgScaleSize:imgSize :maxzSize];
        CGRect imgFrame=CGRectZero;
        if(msg.sendtype == 0){
            imgFrame = CGRectMake(0, 0, imgSize.width + 5, imgSize.height);
        }
        else{
            imgFrame = CGRectMake(0, 0, imgSize.width +5, imgSize.height);
        }
        [self.imgView setFrame:imgFrame];
        [self.imgView setup];
        conframe.size.width = imgSize.width;
        conframe.size.height = imgSize.height - 5;
        [conView addSubview:self.imgView];
        self.imgView.userInteractionEnabled = YES;
    }
    //视频
    else if(msg.filetype==3){
        _videoImageView=[[HJChatImageView alloc] initWithImageStyle:HJChatImageStyleRight Frame:CGRectMake(0, 0, vedioimgWidth, vedioimgHeight)];
        if (msg.sendtype == 0) {
            self.imgView=[[HJChatImageView alloc] initWithImageStyle:HJChatImageStyleRight Frame:CGRectMake(0, 0, vedioimgWidth, vedioimgHeight + 5)];
        }else{
            self.imgView=[[HJChatImageView alloc] initWithImageStyle:HJChatImageStyleLeft Frame:CGRectMake(0, 0, vedioimgWidth, vedioimgHeight + 5)];
        }
        [conView addSubview:self.imgView];
        self.imgView.userInteractionEnabled = YES;
        _videoImageView.layer.masksToBounds = YES;
        _videoImageView.layer.cornerRadius = 4.0;
        
        conframe.size.width=vedioimgWidth - 5;
        conframe.size.height=vedioimgHeight;
        [conView addSubview:self.videoImageView];
        NSString *imageurl = [msg.url stringByReplacingOccurrencesOfString:@".mp4" withString:@".jpg"];
        SDWebImageManager * manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString: [JZCommon getFileDownloadPath:imageurl]] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (error) {
                NSLog(@"图像下载失败");
                return ;
            }
            self.imgView.image = image;
        }];
//        if(msg.sendtype==0){
            //发送视频
            _playImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"video_play_btn"]];
            CGFloat x=(_videoImageView.frame.size.width-30)/2;
            CGFloat y=(_videoImageView.frame.size.height-30)/2;
            _playImageView.frame=CGRectMake(x, y, 30, 30);
            [conView addSubview:_playImageView];
//        }
//        else if (msg.sendtype==1){
//            CGFloat x=(_videoImageView.frame.size.width-60)/2+10;
//            CGFloat y=(_videoImageView.frame.size.height-60)/2-5;
//            //            if([JZCommon isBlankString:msg.progress]){
//            _DownLoadButton=[MyCustomView creatButtonFrame:CGRectMake(x, y, 60, 60) title:nil Type:UIButtonTypeRoundedRect target:nil action:nil tag:100];
//            [_DownLoadButton setBackgroundImage:[UIImage imageNamed:@"video_download_btn"] forState:UIControlStateNormal];
//        }
    }
    [conView setFrame:conframe];
    
    return conView;
}


#pragma mark - height

//计算内容高度
- (CGSize)heightForMessageContent:(NSString*)messageContent{
    MLEmojiLabel *msgLabel=[MLEmojiLabel new];
    msgLabel.numberOfLines = 0;
    msgLabel.disableThreeCommon = YES;
    msgLabel.font = [UIFont systemFontOfSize:15];
    msgLabel.isNeedAtAndPoundSign = YES;
    msgLabel.disableEmoji = NO;
    msgLabel.lineSpacing = 0.0f;
    msgLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    msgLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    msgLabel.customEmojiPlistName = @"expressionImage_custom.plist";
    [msgLabel setText:messageContent];
    return [msgLabel preferredSizeWithMaxWidth:200];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
