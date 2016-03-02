//
//  UploadFileCore.m
//  ennew
//  文件上传类
//  Created by mijibao on 15/6/5.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "UploadFileCore.h"
#import "JZCommon.h"
#import "XMPPManager.h"
#import "ChatMsgListManage.h"

@implementation UploadFileCore
@synthesize fileType;

// 拼接字符串
static NSString *boundaryStr = @"--";   // 分隔字符串
static NSString *randomIDStr;           // 本次上传标示字符串
static NSString *uploadID;              // 上传(php)脚本中，接收文件字段

- (instancetype)init
{
    self = [super init];
    if (self) {
        randomIDStr = @"itcast";
        uploadID = @"uploadFile";
    }
    return self;
}

#pragma mark - 私有方法
- (NSString *)topStringWithMimeType:(NSString *)mimeType uploadFile:(NSString *)uploadFile
{
    NSMutableString *strM = [NSMutableString string];
    
    [strM appendFormat:@"%@%@\n", boundaryStr, randomIDStr];
    [strM appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\n", uploadID, uploadFile];
    [strM appendFormat:@"Content-Type: %@\n\n", mimeType];
    
    NSLog(@"%@", strM);
    return [strM copy];
}

- (NSString *)bottomString
{
    NSMutableString *strM = [NSMutableString string];
    
    [strM appendFormat:@"%@%@\n", boundaryStr, randomIDStr];
    [strM appendString:@"Content-Disposition: form-data; name=\"submit\"\n\n"];
    [strM appendString:@"Submit\n"];
    [strM appendFormat:@"%@%@--\n", boundaryStr, randomIDStr];
    
    NSLog(@"%@", strM);
    return [strM copy];
}

#pragma mark - 上传文件

- (void)uploadFile:(NSData *)data{
    [self uploadFile:data fileType:@"image"];
}

- (void)uploadFile:(NSData *)data fileType:(NSString *)filetype
{
    // 1> 数据体
    NSString *topStr = [self topStringWithMimeType:@"image/png" uploadFile:@"头像1.png"];
    if ([filetype isEqualToString:@"audio"]) {
        topStr = [self topStringWithMimeType:@"audio/amr" uploadFile:@"1.amr"];
    }else if ([filetype isEqualToString:@"video"]) {
        topStr = [self topStringWithMimeType:@"video/mp4" uploadFile:@"1.mp4"];
    }
    NSString *bottomStr = [self bottomString];
    NSMutableData *dataM = [NSMutableData data];
    [dataM appendData:[topStr dataUsingEncoding:NSUTF8StringEncoding]];
    [dataM appendData:data];
    [dataM appendData:[bottomStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURL *url=[NSURL URLWithString:[JZCommon fileUploadPath]];
    // 1. Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10.0f];
    
    // dataM出了作用域就会被释放,因此不用copy
    request.HTTPBody = dataM;
    
    // 2> 设置Request的头属性
    request.HTTPMethod = @"POST";
    
    // 3> 设置Content-Length
    NSString *strLength = [NSString stringWithFormat:@"%ld", (long)dataM.length];
    [request setValue:strLength forHTTPHeaderField:@"Content-Length"];
    
    // 4> 设置Content-Type
    NSString *strContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", randomIDStr];
    [request setValue:strContentType forHTTPHeaderField:@"Content-Type"];
    
    // 3> 连接服务器发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self.delegate uploadResult:result withType:fileType];
    }];
}
/**
 *  dataArray中每个元素类型应该为NSData，上传三次仍然失败的状况没有处理
 */
- (void)uploadFileArray:(NSArray *)dataArray lastIsAudio:(BOOL)isAudio
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger index = 0; index < dataArray.count; ++index) {
        NSData *data = [dataArray objectAtIndex:index];
        // 1> 数据体
        NSString *topStr = [self topStringWithMimeType:@"image/png" uploadFile:@"头像1.png"];
        if (isAudio && index == dataArray.count-1) {
            topStr = [self topStringWithMimeType:@"audio/amr" uploadFile:@"1.amr"];
        }
        NSString *bottomStr = [self bottomString];
        
        NSMutableData *dataM = [NSMutableData data];
        [dataM appendData:[topStr dataUsingEncoding:NSUTF8StringEncoding]];
        [dataM appendData:data];
        [dataM appendData:[bottomStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURL *url=[NSURL URLWithString:[JZCommon fileUploadPath]];
        // 1. Request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:2.0f];
        
        // dataM出了作用域就会被释放,因此不用copy
        request.HTTPBody = dataM;
        
        // 2> 设置Request的头属性
        request.HTTPMethod = @"POST";
        
        // 3> 设置Content-Length
        NSString *strLength = [NSString stringWithFormat:@"%ld", (long)dataM.length];
        [request setValue:strLength forHTTPHeaderField:@"Content-Length"];
        
        // 4> 设置Content-Type
        NSString *strContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", randomIDStr];
        [request setValue:strContentType forHTTPHeaderField:@"Content-Type"];
        
        __block NSInteger retryTimes = 0;
        __block NSData *retData = nil;
        // 5> 连接服务器发送请求
        dispatch_group_async(group, queue, ^{
            do {
                NSError *err = nil;
                retData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
                if (retData != nil) {
                    NSString *result = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
                    [resultArray addObject:result];
                } else {
                    retryTimes += 1;
                    NSLog(@"uploadFileError--%ld  %@",(long)retryTimes,err.localizedDescription);
                }
            }while (retData==nil && retryTimes<3);
        });
    }

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(uploadResultByArray:)]) {
            [self.delegate performSelector:@selector(uploadResultByArray:) withObject:resultArray];
        }
    });
}

- (void)uplaodChatMessage:(ChatMsgDTO *)message{
    Reachability *r = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if ([r currentReachabilityStatus] == NotReachable){
        //更新消息发送状态
        message.success=0;
        //        [self reloadCell:msg.msgid];
        //子线程保存数据
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[ChatMsgListManage shareInstance] saveSendMsgSuccess:message];
        });
    }
    // 1> 数据体
    NSString *topStr = [self topStringWithMimeType:@"image/png" uploadFile:@"头像1.png"];
    if (message.filetype == 1) {
        topStr = [self topStringWithMimeType:@"audio/amr" uploadFile:@"1.amr"];
    }
    if (message.filetype == 3) {
         topStr = [self topStringWithMimeType:@"video/mp4" uploadFile:@"1.mp4"];
    }
    NSString *bottomStr = [self bottomString];
    NSMutableData *dataM = [NSMutableData data];
    [dataM appendData:[topStr dataUsingEncoding:NSUTF8StringEncoding]];
    if (message.filetype == 3) {
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSString * toMp4Path = [cachPath stringByAppendingFormat:@"/output-%@.mp4", message.msgid];
        [dataM appendData:[NSData dataWithContentsOfFile:toMp4Path]];
    }else {
        [dataM appendData:[NSData dataWithContentsOfFile:message.localpath]];
    }
    [dataM appendData:[bottomStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURL *url=[NSURL URLWithString:[JZCommon fileUploadPath]];
    // 1. Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10.0f];
    
    // dataM出了作用域就会被释放,因此不用copy
    request.HTTPBody = dataM;
    
    // 2> 设置Request的头属性
    request.HTTPMethod = @"POST";
    
    // 3> 设置Content-Length
    NSString *strLength = [NSString stringWithFormat:@"%ld", (long)dataM.length];
    [request setValue:strLength forHTTPHeaderField:@"Content-Length"];
    
    // 4> 设置Content-Type
    NSString *strContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", randomIDStr];
    [request setValue:strContentType forHTTPHeaderField:@"Content-Type"];
    
    // 3> 连接服务器发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        message.url = result;
        if (connectionError) {
            // 刷新cell，显示失败按钮
            [self.delegate refreshMessageWithID:message.msgid isSuccess:NO];
        } else {
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            message.url = result;
            [[ChatMsgListManage shareInstance] updateMsgurl:message];// 更新图片url
            if (message.success == 1) {
                
            }else{
                [[XMPPManager sharedManager] sendMessage:message];
            }
        }

    }];
}
@end
