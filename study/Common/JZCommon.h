//
//  CommonCore.h
//  CommonCore
//
//  Created by jzkj on 15/9/24.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import "UIKit/UIKit.h"
typedef NS_ENUM(NSInteger, UserFilePathType)
{
    UserFilePathTypeImage = 0,
    UserFilePathTypeAudio,
    UserFilePathTypeVideo
};


@interface JZCommon : NSObject

//获取登陆用户id
+ (NSString *)queryLoginUserId;
//获取用户密码
+ (NSString *)getLoginUserPwd;
//获取用户手机号
+ (NSString *)getUserPhone;
//非空判断
+ (BOOL)isBlankString:(NSString *)string;

/**
 *  获取GUID
 *
 *  @return GUID
 */
+ (NSString *)GUID;

/**
 *  图片压缩
 *
 *  @param image   要压缩的图像
 *  @param size    压缩后图片的size
 *  @param quality 压缩质量，值从0.0~1.0，0.0压缩最厉害，质量最差；1.0质量最好
 *
 *  @return 压缩后的图片对象
 */
+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size compressionQuality:(CGFloat)quality;

//转换时间格式
+ (NSString *)showTimeString:(NSString *)time;

//转换时间格式
+ (NSDate *)stringToDate:(NSString *)dateString format:(NSString *)format;

/**
 *  将NSDate转为字符串
 *
 *  @param date   要转化的日期
 *  @param format 要转化的格式
 *
 *  @return 表示日期的字符串
 */
+ (NSString *)dateToString:(NSDate *)date format:(NSString *)format;

/**
 *  计算两个日期之间的秒数
 *
 *  @param beginDate 开始日期
 *  @param endDate   结束日期
 *
 *  @return 相差的秒数
 */
+ (NSTimeInterval)timeIntervalBetween:(NSDate *)beginDate and:(NSDate *)endDate;

/**
 *  返回文件路径
 *
 *  @param fileId        主文件名
 *  @param fileExtension 文件扩展名，可以传nil
 *
 *  @return 返回文件绝对路径
 *  @note   该方法返回的路径在沙盒中不一定存在对应的文件或目录
 */
+ (NSString *)filePath:(NSString *)fileId extension:(NSString *)fileExtension inSearchPathDirectory:(NSSearchPathDirectory)directory;

/**
 *  根据当前时间生成时间戳
 *
 *  @return 表示时间戳的字符串
 */
+(NSString *)createTimestamp;

/**
 *  根据NSDate生成时间戳
 *
 *  @param date 依据的NSDate
 *  @return 时间戳字符串
 */
+ (NSString *)parseParamDate:(NSDate *)date;

/**
 *  时间戳转字符串
 *
 *  @param jsonValue 时间戳字符串
 *
 *  @return 转化后的NSDate
 */
+ (NSDate *)getDate:(NSString *)jsonValue;

//时间差
+ (NSTimeInterval)timeDifference:(NSDate *)beginDate :(NSDate *)endDate;
/**
 *  生成纯色的图片
 *
 *  @param color  要生成的图片的颜色
 *  @param aFrame 生成的图片大小
 *
 *  @return 生成的UIImage对象
 */
+ (UIImage *)ImageWithColor:(UIColor *)color frame:(CGRect)aFrame;

/**
 *  根据model生成字典对象
 */
+ (NSDictionary *)dictionaryWithModel:(id)model;

/**
 *  判断字符串包含的信息是否为只有一个整数
 *
 *  @return 如果只包含一个整数，返回YES；否则，返回NO。
 */
+(BOOL)isPureInt:(NSString*)string;

/**
 *  计算字符串的size
 *
 *  @param str  要计算的字符串对象
 *  @param font 字符串使用的字体
 *  @param size 字符串size被限制的最大值
 *
 *  @return 字符串的size
 */
+ (CGSize)sizeOfText:(NSString *)str withFont:(UIFont *)font consstrainSize:(CGSize)size;

/**
 *  得到view所属的viewController
 */
+ (UIViewController *)viewControllerOfView:(UIView *)view;

//图片大小
+ (CGSize)imgScaleSize:(CGSize)size :(CGSize)maxSize;

//获取文本大小
+ (CGSize)getTextSize:(NSString *)message textFont:(NSInteger)fontSize textMaxWidth:(NSInteger)maxChatWidth;

// 保存大图并返回路径
+ (NSString *)saveImage:(UIImage *)image imageName:(NSString *)imageName userid:(NSString *)userid;

+ (NSString *)imageCachePath:(NSString *)imageName forUID:(NSString *)uid;
// 判断文件是否存在
+ (BOOL)isExistFile:(NSString *)filePath;
//返回文件下载路径
//+ (NSString *)imageDownloadPath:(NSString *)path width:(NSInteger)width;

//+ (NSString *)audioDownloadPath:(NSString *)path;

//获取文件下载路径
+(NSString *)getFileDownloadPath:(NSString *)file;

//文件上传路径
+ (NSString *)fileUploadPath;

//时间显示
+ (NSString *)showTime:(NSString *)time;

/**
 *  分段显示字体颜色（两段）
 *
 *  @param string  要分段显示颜色的字符串
 *  @param length  第一段的长度
 *  @param color   第一段的颜色
 *  @param otherColor 第二段的颜色
 *
 *  @return 字符串的size
 */
+ (NSMutableAttributedString *)settingString:(NSString *)string
                                  withLength:(NSInteger)length
                                  firstColor:(UIColor *)color
                                 secondColor:(UIColor *)otherColor;
//获取中文拼音
+ (NSString *)getChineseSpelling:(NSString *)string;

//将UTC时间转换成系统时区时间
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)Date;

@end

@interface JZCommon (UITool)

+ (UIButton *)buttonWithTitle:(NSString *)title backgroundColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor frame:(CGRect)frame target:(id)target selector:(SEL)selector;

@end
