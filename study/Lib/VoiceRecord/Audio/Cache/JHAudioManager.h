//
//  JHAudioManager.h
//  jinherIU
//  录音管理文件
//  Created by zhangshuaibing on 14-6-11.
//  Copyright (c) 2014年 bing. All rights reserved.
//

@class ChatMsgDTO;
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface JHAudioManager : NSObject <AVAudioPlayerDelegate> {
    UITableView         *_tableView;        //播放界面的tableview
    NSMutableArray      *_msgList;          //播放页的消息数组
    NSMutableDictionary *_soundViewDic;     //声音图片view数组
    NSUInteger          _msgIndex;          //当前播放的index
}
@property (strong, nonatomic) UITableView           *tableView;
@property (strong, nonatomic) NSMutableArray        *msgList;
@property (strong, nonatomic) NSMutableDictionary   *soundViewDic;
@property (assign, nonatomic) NSUInteger            msgIndex;
@property (nonatomic, copy) void(^Cancelblock)() ;//暂定或播放完成

//单例入口
+ (JHAudioManager *)sharedInstance;
//是否获取了录音权限
- (BOOL)isGreatAudioLimit;
//录音开始
- (void)recordStart:(NSString *)userid target:(id)target;
//返回录音数据data
- (NSMutableDictionary *)recordStop;
//取消录音
- (void)recordCancel;
//播放
-(void)recordPlay:(NSString *)resourceUrl;
//点击播放（带联播逻辑）
- (void)audioPlayWithTableView:(UITableView *)tableView msgList:(NSMutableArray *)msgList msgIndex:(NSUInteger)msgIndex soundImgViewDic:(NSMutableDictionary *)soundImgViewDic;
//离开页面语音播放停止
- (void)audioStop;
//播放中改变听筒
- (void)changeMode;
//是否停止播放
- (BOOL)isStopPlaying;
- (void)pausePlaying;
- (void)play;
// 播放聊天语音
- (void)recordPlayChatMessage:(ChatMsgDTO *)msg;
@end
