//
//  MessageModel.h
//  ennew
//
//  Created by mijibao on 15/6/12.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject{
    NSString *_id;
}

@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *attachType;
@property (nonatomic, assign) Boolean delay;
@property (nonatomic, assign) NSInteger delivery_status;
@property (nonatomic, copy) NSString *direction;
@property (nonatomic, copy) NSString *imageType;
@property (nonatomic, copy) NSString *familyId;
@property (nonatomic, copy) NSString *familyName;
@property (nonatomic, copy) NSString *familyPhoto;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *fileUrl;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *hasAttach;
@property (nonatomic, copy) NSString *iD;
@property (nonatomic, assign) NSInteger imageHeight;
@property (nonatomic, assign) NSInteger imageWidth;
@property (nonatomic, copy) NSString *isCalendar;
@property (nonatomic, copy) NSString *isGroup;
@property (nonatomic, copy) NSString *isShowTime;
@property (nonatomic, copy) NSString *listPosition;
@property (nonatomic, copy) NSString * receiveId;
@property (nonatomic, copy) NSString * receivePhone;
@property (nonatomic, copy) NSString * sendAddress;
@property (nonatomic, copy) NSString * sendName;
@property (nonatomic, copy) NSString * sendTime;
@property (nonatomic, copy) NSString * sender;
@property (nonatomic, copy) NSString * senderPhone;
@property (nonatomic, copy) NSString * senderPhoto;
@property (nonatomic, copy) NSString * textContent;
@property (nonatomic, copy) NSString * uploadProgress;
@property (nonatomic, copy) NSString * voiceLength;
@property (nonatomic, copy) NSString * location;
@property (nonatomic, copy) NSString * isStar;//问题id
@property (nonatomic, copy) NSString * chatphoto;//聊天对象头像
@end
