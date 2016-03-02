//
//  UploadFileCore.h
//  ennew
//  文件上传类
//  Created by mijibao on 15/6/5.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMsgDTO.h"

@protocol UploadDelegate <NSObject>
@optional
/**
 *  消息上传失败代理
 *
 *  @param msgID     消息id
 *  @param isSuccess 失败标志
 */
- (void)refreshMessageWithID:(NSString *)msgID isSuccess:(BOOL)isSuccess;
- (void)uploadResult:(NSString *)result withType:(NSInteger)type;
- (void)uploadResultByArray:(NSArray *)returnPath;
@end

@interface UploadFileCore : NSOperation

@property (nonatomic,assign) NSInteger fileType;
/**
 *  上传消息附件
 *
 *  @param message 聊天消息
 */
- (void)uplaodChatMessage:(ChatMsgDTO *)message;
- (void)uploadFile:(NSData *)data;
- (void)uploadFile:(NSData *)data fileType:(NSString *)filetype;
/*
 *  @param dataArray 元素类型为NSData
 *  @param isAudio 如果dataArray最后一个元素是音频数据，isAuio传YES
 */
- (void)uploadFileArray:(NSArray *)dataArray lastIsAudio:(BOOL)isAudio;

@property (weak,nonatomic) id<UploadDelegate> delegate;

@end


