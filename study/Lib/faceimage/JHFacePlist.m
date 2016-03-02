//
//  JHFacePlist.m
//  jinherIU
//
//  Created by zhangshuaibing on 14-6-26.
//  Copyright (c) 2014年 bing. All rights reserved.
//

#import "JHFacePlist.h"

static NSString * const kFileToImage = @"expressionImage_custom";
static NSString * const kBEGIN_FLAG = @"[";
static NSString * const kEND_FLAG = @"]";

static JHFacePlist *_instance;

@interface JHFacePlist() {
    NSMutableDictionary *_fileToImageDic;
    NSMutableDictionary *_imageToFileDic;
}

//init infodic
- (void)initInfoDic;
//遍历替换表情符号为文件名称
-(void)getImageRange:(NSString*)message formateText: (NSMutableString *)formateText isImageToFile:(BOOL)isImageToFile;

@end

@implementation JHFacePlist
#pragma mark - init
//外部接口
+ (JHFacePlist *)sharedInstance {
    @synchronized(self) {
        if (!_instance) {
            _instance = [[JHFacePlist alloc]init];
        }
    }
    return _instance;
}
//init
- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}
//init infodic
- (void)initInfoDic
{
    _fileToImageDic = [[NSMutableDictionary alloc]init];
    _imageToFileDic = [[NSMutableDictionary alloc]init];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *plistPath=[[NSBundle mainBundle] pathForResource:kFileToImage ofType:@"plist"];
    if([fileManager fileExistsAtPath:plistPath]){
        _fileToImageDic = [[NSMutableDictionary alloc]initWithContentsOfFile: plistPath];
        _imageToFileDic = [[NSMutableDictionary alloc]init];
        //将key-value互换
        
        for (id key in [_fileToImageDic allKeys]) {
            NSString *value = [_fileToImageDic objectForKey:key];
            [_imageToFileDic setObject:key forKey:value];
        }
    }
}
#pragma mark - 
//通过表情文件名找到表情代码
- (NSString *)getImageNameWithFileName:(NSString *)fileName
{
    if (!_fileToImageDic) {
        [self initInfoDic];
    }
    NSString *result = [_fileToImageDic objectForKey:fileName]?[NSString stringWithFormat:@"%@",[_fileToImageDic objectForKey:fileName]]:[NSString stringWithFormat:@"%@",fileName];
    return result;
}
//通过表情代码找到表情文件名
- (NSString *)getFileNameWithImageName:(NSString *)imageName
{
    if (!_imageToFileDic) {
        [self initInfoDic];
    }
//    NSString *result = [NSString stringWithFormat:@"[%@]",[_imageToFileDic objectForKey:imageName]];
    NSString *result = [_imageToFileDic objectForKey:imageName]?[NSString stringWithFormat:@"%@",[_imageToFileDic objectForKey:imageName]]:[NSString stringWithFormat:@"[%@]",imageName];
    return result;
}
//格式化发送的文本消息
- (NSString *)formatMsgText:(NSString *)text
{
    NSMutableString *formateText = [[NSMutableString alloc]init];
    [self getImageRange:text formateText:formateText isImageToFile:YES];
    return formateText;
}
//遍历替换表情符号为文件名称
-(void)getImageRange:(NSString*)message formateText: (NSMutableString *)formateText isImageToFile:(BOOL)isImageToFile {
    NSRange range=[message rangeOfString: kBEGIN_FLAG];
    NSRange range1=[message rangeOfString: kEND_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0) {
        if (range.location > 0) {
            [formateText appendFormat:@"%@",[message substringToIndex:range.location]];
            //讲表情符号转换成表情文件名称
            NSString *faceName = [message substringWithRange:NSMakeRange(range.location+1, range1.location-range.location-1)];
            //            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            if (isImageToFile) {
                [formateText appendFormat:@"%@",[self getFileNameWithImageName:faceName]];
            }
            else {
                [formateText appendFormat:@"%@",[self getImageNameWithFileName:faceName]];
            }
            
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str formateText:formateText isImageToFile:isImageToFile];
        }else {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""]) {
                //讲表情符号转换成表情文件名称
                NSString *faceName = [message substringWithRange:NSMakeRange(range.location+1, range1.location-range.location-1)];
                //                [array addObject:nextstr];
                if (isImageToFile) {
                    [formateText appendFormat:@"%@",[self getFileNameWithImageName:faceName]];
                }
                else {
                    [formateText appendFormat:@"%@",[self getImageNameWithFileName:faceName]];
                }
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str formateText:formateText isImageToFile:isImageToFile];
            }else {
                return;
            }
        }
        
    } else if (message != nil) {
        [formateText appendFormat:@"%@",message];
    }
}

//格式化发送的文本消息,把文件名更改为表情符号名
- (NSString *)formatMsgTextToImageName:(NSString *)text
{
    NSMutableString *formateText = [[NSMutableString alloc]init];
    [self getImageRange:text formateText:formateText isImageToFile:NO];
    return formateText;
}

@end
