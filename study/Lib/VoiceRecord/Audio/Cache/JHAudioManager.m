//
//  JHAudioManager.m
//  jinherIU
//
//  Created by zhangshuaibing on 14-6-11.
//  Copyright (c) 2014年 bing. All rights reserved.
//

#import "JHAudioManager.h"
#import "JHCacheManager.h"
#import "ASIHTTPRequest.h"
//#import "AlbumChatDTO.h"
//#import "LCVoiceHud.h"
//#import "ASIHTTPRequest.h"
//#import "ChatMsgListManage.h"
////#import "MsgListTableViewCell.h"
//#import "AlbumCommViewController.h"
#import "SysConfig.h"
#import "ChatMsgDTO.h"
#import "VoiceConverter.h"
#import "RecordingView.h"
@interface JHAudioManager () {
    BOOL recording;
    BOOL _playing;
    
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
    NSURL *pathURL;
    NSTimer *peakTimer;
    NSTimeInterval _timeLen;
    //    LCVoiceHud * voiceHud_;
    
    NSString *_lastPlayerFileid;
    NSTimeInterval _lastPlayerTime;
    id _target;
}
//更新说话时长，并设置最大说话时长
- (void)updatePeak:(NSTimer*)timer;

@end

static JHAudioManager *_instance;
@implementation JHAudioManager
@synthesize tableView           = _tableView;
@synthesize msgList             = _msgList;
@synthesize msgIndex            = _msgIndex;
@synthesize soundViewDic        = _soundViewDic;

//单例入口
+ (JHAudioManager *)sharedInstance
{
    @synchronized(self) {
        if (!_instance) {
            _instance = [[JHAudioManager alloc]init];
        }
    }
    return _instance;
}
//init
- (id)init {
    self = [super init];
    if (self) {
        _playing = NO;
    }
    return self;
}
//录音开始
- (void)recordStart:(NSString *)userid target:(id)target  {
    @try {
        _target = target;
        if ([self isGreatAudioLimit]) {
            if(recording)
                return;
            NSLog(@"9999999");
            [audioPlayer pause];
            recording=YES;
            //audio设置属性
            NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithFloat:8000],AVSampleRateKey,
                                    [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                                    [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                    [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                    [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                    [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                    nil];
            
            [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            
            NSDate *now = [NSDate date];
            NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
            [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
            NSString *fileName = [NSString stringWithFormat:@"rec_%@_%@.wav",userid,[dateFormater stringFromDate:now]];
            NSString *fullPath = [[[JHCacheManager sharedInstance] getUserPathWithUserid:userid fileType:JHUserFilePathTypeAudio] stringByAppendingPathComponent:fileName];
            NSURL *url = [NSURL fileURLWithPath:fullPath];
            pathURL = url;
            NSLog(@"333333333333=%@",pathURL);
            
            NSError *error;
            audioRecorder = [[AVAudioRecorder alloc] initWithURL:pathURL settings:settings error:&error];
            audioRecorder.delegate = target;
            
            [audioRecorder prepareToRecord];
            [audioRecorder setMeteringEnabled:YES];
            [audioRecorder peakPowerForChannel:0];
            [audioRecorder record];
            //            [self showVoiceHudOrHide:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"NSException:%@",[exception reason]);
    }
    
}
//更新说话时长，并设置最大说话时长
//- (void)updatePeak:(NSTimer*)timer
//{
//    @try {
//        _timeLen = audioRecorder.currentTime;
//        if (_timeLen > 50 && _timeLen <= 60) {
//            [self showVoiceHudOrHide:NO];
//            [SVProgressHUD showProgress:1 status:[NSString stringWithFormat:@"还可以说%d秒",(60-(int)_timeLen)]];
//
//        }
//        if(_timeLen>=60) {
//            [SVProgressHUD dismiss];
//            if (_target && [_target isKindOfClass:[AlbumCommViewController class]]) {
//                AlbumCommViewController *acvc = (AlbumCommViewController *)_target;
//                [acvc sendVideoMsg];
//            }
//            else {
//                [self recordStop];
//            }
//        }
//
//
//        if (voiceHud_)
//        {
//            /*  发送updateMeters消息来刷新平均和峰值功率。
//             *  此计数是以对数刻度计量的，-160表示完全安静，
//             *  0表示最大输入值
//             */
//
//            if (audioRecorder) {
//                [audioRecorder updateMeters];
//            }
//
//            float peakPower = [audioRecorder averagePowerForChannel:0];
//            double alpha = 0.05;
//            double peakPowerForChannel = pow(10, (alpha * peakPower));
//            [voiceHud_ setProgress:peakPowerForChannel];
//        }
//    }
//    @catch (NSException *exception) {
//        NSLog(@"NSException:%@",[exception reason]);
//    }
//}
//返回录音数据data
- (NSMutableDictionary *)recordStop {
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc]init];
//    [SVProgressHUD dismiss];
    NSLog(@"掉没");
    
    @try {
        //         [self showVoiceHudOrHide:NO];
        if(!recording) {
            return nil;
        }
        recording = NO;
        
        //        [peakTimer invalidate];
        //        peakTimer = nil;
        
        //    [self offRecordBtns];
        //录音时长
        _timeLen = audioRecorder.currentTime;
        NSLog(@"8888=%f",_timeLen);
        [audioRecorder stop];
        NSString *threeGPPath = [VoiceConverter wavToAmr:pathURL.path];
        NSData *recordData = [NSData dataWithContentsOfFile:threeGPPath];
        
        //            [[ChatCacheFileUtil sharedInstance] deleteWithContentPath:pathURL.path];
        //            [[ChatCacheFileUtil sharedInstance] deleteWithContentPath:amrPath];
        NSString *recordName = [[threeGPPath lastPathComponent] copy];
        
        NSLog(@"6666666=%@",recordName);
        
        if (_timeLen<1) {
//            [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
//            [SVProgressHUD showImage:[UIImage imageNamed:@"Immediate_record_too_short"] status:@"语音时间过短"];
            NSLog(@"guoguogio");
            return nil;
        }
        
        [infoDic setObject:[NSString stringWithFormat:@"%d",(int)_timeLen] forKey:@"recordTime"];
        [infoDic setObject:recordName forKey:@"recordName"];
        [infoDic setObject:recordData forKey:@"recordData"];
        [infoDic setObject:threeGPPath forKey:@"localPath"];
    }
    @catch (NSException *exception) {
        NSLog(@"NSException:%@",[exception reason]);
    }
    return infoDic;
}
//取消录音
- (void)recordCancel
{
    //    [self showVoiceHudOrHide:NO];
    @try {
        if(!recording)
            return;
        [audioRecorder stop];
        [peakTimer invalidate];
        peakTimer = nil;
        recording = NO;
    }
    @catch (NSException *exception) {
        NSLog(@"NSException:%@",[exception reason]);
    }
}
//
#pragma mark - Helper Function

//-(void) showVoiceHudOrHide:(BOOL)yesOrNo{
//    @try {
//
//        if (voiceHud_) {
//            [voiceHud_ hide];
//            voiceHud_ = nil;
//        }
//
//        if (yesOrNo) {
//
//            voiceHud_ = [[LCVoiceHud alloc] init];
//            [voiceHud_ show];
//
//        }else{
//
//        }
//    }
//    @catch (NSException *exception) {
//        NSLog(@"NSException:%@",[exception reason]);
//    }
//}

#pragma mark - 语音播放
-(void)initPlayer{
    //初始化播放器的时候如下设置
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(sessionCategory),
                            &sessionCategory);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    //默认情况下听筒播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    [audioSession setActive:YES error:nil];
    audioSession = nil;
}


//播放
-(void)recordPlay:(NSString *)resourceUrl{
    if (!_playing) {
        _playing = YES;
    }
    @try {
        NSArray *urlItemList = [resourceUrl componentsSeparatedByString:@"/"];
        __block NSString *aduioName = [NSString stringWithFormat:@"%@",[urlItemList lastObject]];
        
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *fileHeadPath = [NSString stringWithFormat:@"%@/%@/%@/%@",[documentPaths objectAtIndex:0],@"Files",[UserInfoList loginUserId],@"audio"];
        
        NSString *audioPath = [fileHeadPath stringByAppendingPathComponent:aduioName];
        
        
        //判断本地路径是否存在
        NSFileManager *filesManager = [NSFileManager defaultManager];
        BOOL isDir = NO;
        BOOL existed = [filesManager fileExistsAtPath:audioPath isDirectory:&isDir];
        if (existed == NO && [resourceUrl length])//链接地址
        {
            NSString *serverURL = [NSString stringWithFormat:@"%@",resourceUrl];
            //如果不存在
            __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:serverURL]];
            [request setValidatesSecureCertificate:NO];
            [request setRequestMethod:@"GET"];
            [request setCompletionBlock:^{
                NSData *recordData = [request responseData];
                
                //判断是否存在
                NSFileManager *filesManager = [NSFileManager defaultManager];
                BOOL isDir = NO;
                BOOL existed = [filesManager fileExistsAtPath:audioPath isDirectory:&isDir];
                if (!(isDir == YES && existed == YES) ) {
                    [filesManager createDirectoryAtPath:fileHeadPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                [recordData writeToFile:audioPath atomically:YES];
                
                NSString *wavPath = [VoiceConverter amrToWav:audioPath];
                NSLog(@"---recordData:%@---:%@",audioPath,wavPath);
                
                [audioPlayer stop];
                NSError *error=nil;
                //  [self initPlayer];
                audioPlayer = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:wavPath] error:&error];
                if (error) {
                    error=nil;
                }
                
                [audioPlayer setVolume:1];
                [audioPlayer prepareToPlay];
                [audioPlayer setDelegate:self];
                [audioPlayer play];
                
                
            }];
            [request startAsynchronous];
            
        }
        else {
            
            NSLog(@"----:%@",audioPath);
            _lastPlayerTime = 0;
            
            NSString *wavPath = [VoiceConverter amrToWav:audioPath];
            NSError *error=nil;
            [audioPlayer stop];
            
            //[self initPlayer];
            audioPlayer = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:wavPath] error:&error];
            
            //    [[ChatCacheFileUtil sharedInstance] deleteWithContentPath:wavPath];
            if (error) {
                error=nil;
            }
            [audioPlayer setVolume:1];
            [audioPlayer prepareToPlay];
            [audioPlayer setDelegate:self];
            [audioPlayer play];
            
            [[UIDevice currentDevice] setProximityMonitoringEnabled:YES]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
        }
    }
    @catch (NSException *exception) {
        NSLog(@"NSException:%@",[exception reason]);
    }
}
//
//处理监听触发事件
//-(void)sensorStateChange:(NSNotificationCenter *)notification;
//{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    //听筒模式
//    if ([defaults integerForKey:[SysConfig IsSoundPlay]] ==1) {
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//        
//    }
//    
//    else
//    {
//        
//        //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
//        if ([[UIDevice currentDevice] proximityState] == YES)
//        {
//            NSLog(@"Device is close to user");
//            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//            
//        }
//        //使用扬声器播放
//        else
//        {
//            NSLog(@"Device is not close to user");
//            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//        }
//    }
//    
//    
//}
//
////播放结束回调方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //    if (!_playing) {
    //        return;
    //    }
    //    _playing = NO;
    if (!_playing) {
        return;
    }
    _playing = NO;
    
    @try {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
        for (int i = _msgIndex+1; i < [_msgList count]; i++) {
            ChatMsgDTO *msgDto=[_msgList objectAtIndex:i];
            //            //如果是发送方消息则跳过
            //            if (0 == msgDto.sendtype) {
            //                continue;
            //            }
            //如果是语音消息进入，非语音跳过
            if (1 == msgDto.filetype) {
                //如果下条消息为未读消息，则播放
                if ([@"0" isEqualToString:[NSString stringWithFormat:@"%@",msgDto.isread]]){
                    _msgIndex = i;
                    [self audioPlayWithIndex:_msgIndex];
                    NSLog(@"hou:%lu",(unsigned long)_msgIndex);
                    break;
                }
                else
                    return;
            }
            else
                continue;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"NSException:%@",[exception reason]);
    }
    
}
//播放中改变听筒
- (void)changeMode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (_playing) {
        //听筒模式
        if ([defaults integerForKey:[SysConfig IsSoundPlay]] ==1) {

            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];

        }
        else
        {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

        }

    }
}
//
////点击播放（带联播逻辑）
//- (void)audioPlayWithTableView:(UITableView *)tableView msgList:(NSMutableArray *)msgList msgIndex:(NSUInteger)msgIndex soundImgViewDic:(NSMutableDictionary *)soundImgViewDic
//{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    //听筒模式
//    if ([defaults integerForKey:[SysConfig IsSoundPlay]] ==1) {
//
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//
//    }
//    else
//    {
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//
//    }
//
//    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
//
//    //添加监听
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(sensorStateChange:)
//                                                 name:@"UIDeviceProximityStateDidChangeNotification"
//                                               object:nil];
//
//    if (_playing) {
//        [audioPlayer stop];
//        _playing = NO;
//    }
//
//    _tableView          = tableView;
//    _msgList            = msgList;
//    _msgIndex           = msgIndex;
//    _soundViewDic       = soundImgViewDic;
//
//    if (_tableView && _msgList && _soundViewDic && _msgList >= 0) {
//        [self audioPlayWithIndex:_msgIndex];
//    }
//}
//
////停止播放

- (void)audioStop
{
    [audioPlayer stop];
    for (ChatMsgDTO *msgDto in _msgList) {
        UIImageView *soundImgView=(UIImageView *)[_soundViewDic objectForKey:msgDto.msgid];
        [soundImgView stopAnimating];
    }
}
-(void)pausePlaying {
    
    if ([audioPlayer isPlaying]) {
        [audioPlayer pause];
    }
    
}
- (void)play {
    
    [audioPlayer play];
}
//
- (BOOL)isStopPlaying
{
    if (![audioPlayer isPlaying]) {
        return YES;
    }else{
        return NO;
    }
}
//
////按照index播放
- (void)audioPlayWithIndex:(NSUInteger)index
{
    @try {
        ChatMsgDTO *msgDto=(ChatMsgDTO *)[_msgList objectAtIndex:index];
        if ([JZCommon isExistFile:msgDto.localpath]) {
            [self recordPlay:msgDto.localpath];
        } else
            [self recordPlay:msgDto.url];
        //img播放效果
        UIImageView *soundImgView=(UIImageView *)[_soundViewDic objectForKey:msgDto.msgid];
        if ([msgDto.duration integerValue] > 0) {
            soundImgView.animationRepeatCount = [msgDto.duration integerValue];
            [soundImgView startAnimating];
        }
        //        //如果标记为未读，则更改状态为已读
        //        if ([@"0" isEqualToString:[NSString stringWithFormat:@"%@",msgDto.isread]]) {
        //            msgDto.isread = @"1";
        //            [[ChatMsgListManage shareInstance]saveSendMsgRead:msgDto];
        //            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        //            MsgListTableViewCell *cell = (MsgListTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        //            [cell hideReddot];
        //        }
    }
    @catch (NSException *exception) {
        NSLog(@"NSException:%@",[exception reason]);
    }
}
//
////是否获取了录音权限
- (BOOL)isGreatAudioLimit
{
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    __block BOOL isGreat = YES;
    
    if ([avSession respondsToSelector:@selector(requestRecordPermission:)]) {
        
        [avSession requestRecordPermission:^(BOOL available) {
            
            if (available) {
                //completionHandler
                isGreat = YES;
            }
            else
            {
                isGreat = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"无法录音" message:@"请在“设置-隐私-麦克风”选项中允许访问你的麦克风" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                });
            }
        }];
        
    }
    return isGreat;
}
//
//
////播放聊天语音
- (void)recordPlayChatMessage:(ChatMsgDTO *)msg
{
    if (!_playing) {
        _playing = YES;
    }
    @try {
        //    NSString *fileName = msg.name;
        NSString *fileID = msg.msgid;
        NSString *fullPath = [NSString stringWithFormat:@"%@",msg.localpath];

        //判断本地路径是否存在
        NSFileManager *filesManager = [NSFileManager defaultManager];
        BOOL isDir = NO;
        BOOL existed = [filesManager fileExistsAtPath:fullPath isDirectory:&isDir];
        if (existed == NO && [msg.url length])
        {
            NSString *serverURL = [NSString stringWithFormat:@"%@",[JZCommon getFileDownloadPath:msg.url]];

            NSArray *urlItemList = [serverURL componentsSeparatedByString:@"/"];
            __block NSString *aduioName = [NSString stringWithFormat:@"%@",[urlItemList lastObject]];
            //如果不存在
            __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:serverURL]];
            [request setValidatesSecureCertificate:NO];
            [request setRequestMethod:@"GET"];
            [request setCompletionBlock:^{
                NSData *recordData = [request responseData];

                NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *fileHeadPath = [NSString stringWithFormat:@"%@/%@/%@/%@",[documentPaths objectAtIndex:0],@"Files",msg.touid,@"audio"];
                //判断是否存在
                NSFileManager *filesManager = [NSFileManager defaultManager];
                BOOL isDir = NO;
                BOOL existed = [filesManager fileExistsAtPath:fullPath isDirectory:&isDir];
                if (!(isDir == YES && existed == YES) ) {
                    [filesManager createDirectoryAtPath:fileHeadPath withIntermediateDirectories:YES attributes:nil error:nil];
                }

                NSString *audioPath = [fileHeadPath stringByAppendingPathComponent:aduioName];

                [recordData writeToFile:audioPath atomically:YES];

                NSString *wavPath = [VoiceConverter amrToWav:audioPath];
                NSLog(@"---recordData:%@---:%@",audioPath,wavPath);
                msg.localpath = audioPath;
//                [[ChatMsgListManage shareInstance]saveSendMsgLocalpath:msg];


                [audioPlayer stop];
                NSError *error=nil;
                //  [self initPlayer];
                audioPlayer = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:wavPath] error:&error];
                _Cancelblock();
                //    [[ChatCacheFileUtil sharedInstance] deleteWithContentPath:wavPath];
                if (error) {
                    error=nil;
                }


                [audioPlayer setVolume:1];
                [audioPlayer prepareToPlay];
                [audioPlayer setDelegate:self];
                [audioPlayer play];


            }];
            [request startAsynchronous];

        }
        else {

            NSLog(@"----:%@",fullPath);//msg.本地地址；//[[[JHCacheManager sharedInstance] userDocPath] stringByAppendingPathComponent:fileName];
            //如果当前消息
            if([_lastPlayerFileid isEqualToString:fileID]){
                if([audioPlayer isPlaying]){
                    //            _lastPlayerTime = audioPlayer.currentTime;
                    [audioPlayer pause];
                }
                else
                    [audioPlayer play];
                return;
            }

            _lastPlayerFileid = [fileID copy];
            _lastPlayerTime = 0;
            //    [msg.fileData writeToFile:fullPath atomically:YES];

            NSString *wavPath = [VoiceConverter amrToWav:fullPath];
            NSError *error=nil;
            [audioPlayer stop];
            _Cancelblock();
            //[self initPlayer];
            audioPlayer = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:wavPath] error:&error];

            //    [[ChatCacheFileUtil sharedInstance] deleteWithContentPath:wavPath];
            if (error) {
                error=nil;
            }
            [audioPlayer setVolume:1];
            [audioPlayer prepareToPlay];
            [audioPlayer setDelegate:self];
            [audioPlayer play];

            [[UIDevice currentDevice] setProximityMonitoringEnabled:YES]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
        }
    }
    @catch (NSException *exception) {
        NSLog(@"NSException:%@",[exception reason]);
    }
}


@end
