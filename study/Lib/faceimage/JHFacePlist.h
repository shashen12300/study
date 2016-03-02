//
//  JHFacePlist.h
//  jinherIU
//
//  Created by zhangshuaibing on 14-6-26.
//  Copyright (c) 2014年 bing. All rights reserved.
//

@interface JHFacePlist : NSObject {
    
}

//单例入口
+ (JHFacePlist *)sharedInstance;

//通过表情文件名找到表情代码
- (NSString *)getImageNameWithFileName:(NSString *)fileName;
//通过表情代码找到表情文件名
- (NSString *)getFileNameWithImageName:(NSString *)imageName;
//格式化发送的文本消息,把表情符号名更改为文件名
- (NSString *)formatMsgText:(NSString *)text;
//格式化发送的文本消息,把文件名更改为表情符号名
- (NSString *)formatMsgTextToImageName:(NSString *)text;

@end
