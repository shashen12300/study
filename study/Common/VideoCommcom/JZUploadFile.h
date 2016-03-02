//
//  ViewController.h
//  JZUploadFileDemo
//
//  Created by mijibao on 15/10/8.
//  Copyright (c) 2015年 songcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"

typedef NS_ENUM(NSInteger, UploadStatus) {
    UploadSuccess,  //成功
    UploadFailure   //失败
};
@protocol JZUploadFileDelegate <NSObject>

- (void)uploadFileStatus:(UploadStatus)status;  //文件上传状态
- (void)uploadFileUrl:(NSString *)url msgid:(NSString*)msgid;          //上传文件地址
- (void)uploadFileProsess:(CGFloat)prosess msgid:(NSString*)msgid;     //文件上传进度

@end

@interface JZUploadFile : NSObject<AsyncSocketDelegate>

@property (nonatomic,weak) id<JZUploadFileDelegate> delegate;
- (id)initHost:(NSString *)host port:(NSUInteger)port;          //设置IP和端口号
- (void)uploadFilePath:(NSString *)filePath fileName:(NSString *)fileName;   //设置上传文件的路径和文件名
- (void)startUpload;  //开始上传
- (void)pauseUpload;  //暂停上传
@end

