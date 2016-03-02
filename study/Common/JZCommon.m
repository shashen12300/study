//
//  CommonCore.m
//  CommonCore
//
//  Created by jzkj on 15/9/24.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import "JZCommon.h"
#import <objc/runtime.h>
#import "OperatePlist.h"

@implementation JZCommon

//获取登陆用户id
+ (NSString *)queryLoginUserId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[AccountManeger loginUserId]];
}
//获取用户密码
+ (NSString *)getLoginUserPwd{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[AccountManeger loginUserPhone]];
}
//获取用户手机号
+ (NSString *)getUserPhone{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[AccountManeger loginUserPhone]];
}
//非空判断
+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    return NO;
}

//生产GUID
+ (NSString *)GUID {
    CFUUIDRef uuidObj=CFUUIDCreate(NULL);
    CFStringRef strguid=CFUUIDCreateString(NULL, uuidObj);
    NSString *guid=(__bridge_transfer NSString *)strguid;
    CFRelease(uuidObj);
    guid=[guid lowercaseString];
    return  guid;
}

//时间显示
+ (NSString *)showTimeString:(NSString *)time
{
    NSString *result=@"";
    NSDate *today=[NSDate date];
    NSDate *date=[self stringToDate:time format:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *datecomps=[calendar components:unitFlags fromDate:date];
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *beforeyesterday, *yesterday;
    
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    beforeyesterday = [today dateByAddingTimeInterval: -secondsPerDay*2];
    
    NSString *todayString = [[self dateToString:today format:@"yyyy-MM-dd HH:mm:ss.SSS"] substringToIndex:10];
    NSString *yesterdayString = [[self dateToString:yesterday format:@"yyyy-MM-dd HH:mm:ss.SSS"] substringToIndex:10];
    NSString *beforeyesterdayString = [[self dateToString:beforeyesterday format:@"yyyy-MM-dd HH:mm:ss.SSS"] substringToIndex:10];
    
    NSString *year=[self dateToString:today format:@"yyyy"];
    NSString *timeyear=[time substringToIndex:4];
    NSString *dateString = [time substringToIndex:10];
    
    //获取时间,如果是英文的,放在时间的后面
    NSString *timeShow=[self timeQuantum:[datecomps hour]];
    timeShow = @"";
    NSString *dateShow=[self dateToString:date format:@"HH:mm"];
    NSString *timeAndDate=@"";
    if ([timeShow isEqualToString:@"AM"]) {
        
        timeAndDate=[NSString stringWithFormat:@" %@%@",dateShow,timeShow];
        
    }
    else if([timeShow isEqualToString:@"PM"]) {
        timeAndDate=[NSString stringWithFormat:@" %@%@",dateShow,timeShow];
    }
    else
    {
        timeAndDate=[NSString stringWithFormat:@"%@ %@",timeShow,dateShow];
    }
    
    if ([dateString isEqualToString:todayString]){
        //今天
        result=[NSString stringWithFormat:@"%@",result];
        
        result=[NSString stringWithFormat:@"%@%@",result,timeAndDate];
        
        
    }
    else if ([dateString isEqualToString:yesterdayString]){
        
        //昨天
        result=[NSString stringWithFormat:@"%@%@",result,@"昨天"];
        
        result=[NSString stringWithFormat:@"%@%@",result,timeAndDate];
        
    }
    else if ([dateString isEqualToString:beforeyesterdayString]){
        //前天
        NSString *beforeYesterday=@"前天";
        if ([beforeYesterday isEqualToString:@"前天"]) {
            result=beforeYesterday;
            result=[NSString stringWithFormat:@"%@%@",result,timeAndDate];
        }
        else
        {
            result=[NSString stringWithFormat:@"%@ %@",[self dateToString:date format:@"MM-dd"],[self dateToString:date format:@"HH:mm"]];
        }
        
    }
    else if ([year isEqualToString:timeyear]){
        result=[NSString stringWithFormat:@"%@ %@",[self dateToString:date format:@"MM-dd"],[self dateToString:date format:@"HH:mm"]];
    }
    else
    {
        return [NSString stringWithFormat:@"%@ %@",dateString,[self dateToString:date format:@"HH:mm"]];
    }
    
    return result;
    
}

//时间输出
+ (NSString *)timeQuantum:(NSInteger) hour{
    
    if(hour>=1 && hour<6){
        //凌晨
        return @"凌晨";
    }else if (hour>=6 && hour<9){
        //早上
        return @"早上";
    }else if (hour>=9 && hour<12){
        //上午
        return @"上午";
    }else if(hour>=12 && hour<18){
        //下午
        return @"下午";
    }else{
        //晚上
        return @"晚上";
    }
    
}

//字符串转时间
+ (NSDate *)stringToDate:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: format];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

//时间转字符串
+ (NSString *)dateToString:(NSDate *)date format:(NSString *)format {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
    
}

//时间差
+ (NSTimeInterval)timeIntervalBetween:(NSDate *)beginDate and:(NSDate *)endDate
{
    NSTimeInterval begin = [beginDate timeIntervalSince1970];
    NSTimeInterval end = [endDate timeIntervalSince1970];
    NSTimeInterval sub = end - begin;
    return sub;
}

//图片压缩
+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size compressionQuality:(CGFloat)quality {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *ImageData = UIImageJPEGRepresentation(scaledImage, quality);
    scaledImage=[UIImage imageWithData:ImageData];
    return scaledImage;
}

//返回文件路径
+ (NSString *)filePath:(NSString *)fileId extension:(NSString *)fileExtension inSearchPathDirectory:(NSSearchPathDirectory)directory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    NSString *filePath = [dir stringByAppendingPathComponent:fileId];
    if (fileExtension != nil) {
        filePath = [dir stringByAppendingPathExtension:fileExtension];
    }
    return filePath;
    
}

//生成时间戳
+(NSString *)createTimestamp
{
    NSDate *datenow=[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    return [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
}

//时间转时间戳
+ (NSString *)parseParamDate:(NSDate *)date
{
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"\\/Date(%lld+0800)\\/", (long long)time];
}

//时间戳转时间
+ (NSDate *)getDate:(NSString *)jsonValue
{
    NSRange range = [jsonValue rangeOfString:@"\\d{13}" options:NSRegularExpressionSearch];
    if (range.location == NSNotFound) {
        return nil;
    }
    NSString *value = [jsonValue substringWithRange:range];
    NSDate *result = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]/1000];
    return result;
}
//时间差
+ (NSTimeInterval)timeDifference:(NSDate *)beginDate :(NSDate *)endDate {
    NSTimeInterval begin=[beginDate timeIntervalSince1970]*1;
    NSTimeInterval end=[endDate timeIntervalSince1970]*1;
    NSTimeInterval cha=end-begin;
    return cha;
}


//颜色图片
+ (UIImage *)ImageWithColor:(UIColor *)color frame:(CGRect)aFrame
{
    aFrame = CGRectMake(0, 0, aFrame.size.width, aFrame.size.height);
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, aFrame);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
//图片大小
+ (CGSize)imgScaleSize:(CGSize)size :(CGSize)maxSize{
    
    CGSize scaleSize={maxSize.width,maxSize.height};
    if(size.width>maxSize.width||size.height>maxSize.height)
    {
        if(size.width<=size.height)
        {
            scaleSize.width=size.width*maxSize.height/size.height;
            scaleSize.height=maxSize.height;
        }
        else
        {
            scaleSize.height=size.height*maxSize.width/size.width;
            scaleSize.width=maxSize.width;
        }
    }
    return scaleSize;
}
//获取文本大小
+ (CGSize)getTextSize:(NSString *)message textFont:(NSInteger)fontSize textMaxWidth:(NSInteger)maxChatWidth{
    CGSize size=[message boundingRectWithSize:CGSizeMake(maxChatWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}

+(BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

+ (NSDictionary *)dictionaryWithModel:(id)model {
    if (model == nil) {
        return nil;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    // 获取类名/根据类名获取类对象
    NSString *className = NSStringFromClass([model class]);
    id classObject = objc_getClass([className UTF8String]);
    
    // 获取所有属性
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(classObject, &count);
    
    // 遍历所有属性
    for (int i = 0; i < count; i++) {
        // 取得属性
        objc_property_t property = properties[i];
        // 取得属性名
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                          encoding:NSUTF8StringEncoding];
        // 取得属性值
        id propertyValue = nil;
        id valueObject = [model valueForKey:propertyName];
        
        if ([valueObject isKindOfClass:[NSDictionary class]]) {
            propertyValue = [NSDictionary dictionaryWithDictionary:valueObject];
        } else if ([valueObject isKindOfClass:[NSArray class]]) {
            propertyValue = [NSArray arrayWithArray:valueObject];
        } else if ([valueObject isKindOfClass:[NSString class]]) {
            propertyValue = [NSString stringWithFormat:@"%@", [model valueForKey:propertyName]];
        } else {
            propertyValue = [model valueForKey:propertyName];
        }
        if(propertyValue==nil){
            propertyValue=@"";
        }
        
        [dict setObject:propertyValue forKey:propertyName];
    }
    return [dict copy];
}

/**
 *  计算文本size
 *
 *  @param str  需要计算size的字符串
 *  @param font str的字体
 *  @param size str最大的size限制
 *
 * @return str实际的size
 */
+ (CGSize)sizeOfText:(NSString *)str withFont:(UIFont *)font consstrainSize:(CGSize)size
{
    CGSize returnSize = CGSizeZero;
    if ([[UIDevice currentDevice].systemVersion floatValue]-7.0 > 0) {
        NSDictionary *attribute = @{NSFontAttributeName:font};
        returnSize = [str boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        returnSize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
    }
    return returnSize;
}

+ (UIViewController *)viewControllerOfView:(UIView *)view
{
    for (UIView *next = [view superview]; next; next = [next superview]) {
        UIResponder *responder = [next nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

#pragma mark -- 文件缓存
//获取用户沙盒路径
+ (NSString *)getUserPathWithUserid:(NSString *)userid fileType:(UserFilePathType)fileType {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //三种文件分别放在不同目录内
    NSArray *fileTypeList = @[@"image",@"audio",@"video"];
    //拼接文件路径
    NSString *docDir = [NSString stringWithFormat:@"%@/%@/%@/%@",[documentPaths objectAtIndex:0],@"Files",userid,[fileTypeList objectAtIndex:fileType]];
    //判断路径是否存在，若不存在则创建
    NSFileManager *filesManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [filesManager fileExistsAtPath:docDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [filesManager createDirectoryAtPath:docDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return docDir;
}
//保存大图并返回路径
+ (NSString *)saveImage:(UIImage *)image imageName:(NSString *)imageName userid:(NSString *)userid
{
    //获取图片路径
    NSString *userPath = [self getUserPathWithUserid:userid fileType:UserFilePathTypeImage];
    NSString *imagePath = [userPath stringByAppendingPathComponent:imageName];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:imagePath]) {
        [fm removeItemAtPath:imagePath error:nil];
    }
    NSData *imgData = UIImageJPEGRepresentation(image, 0.2);
    [fm createFileAtPath:imagePath contents:imgData attributes:nil];
    //缓存图片到沙盒
    return imagePath;
}

+ (NSString *)imageCachePath:(NSString *)imageName forUID:(NSString *)uid
{
    NSString *path = [NSString stringWithFormat:@"Files/%@/image/%@",uid,imageName];
    return path;
}

//文件是否存在
+ (BOOL)isExistFile:(NSString *)filePath
{
    if (!filePath || [filePath isEqualToString:@""]) {
        return NO;
    }
    
    NSString *pathTarget = [[self systemDocumentFolder] lastPathComponent];
    NSRange targetRange = [filePath rangeOfString:pathTarget];
    if (targetRange.location != NSNotFound) {
        NSString *relativePath = [filePath substringFromIndex:targetRange.location + targetRange.length];
        return [[NSFileManager defaultManager] fileExistsAtPath:[self relativePathToAbsolutePath:relativePath]];
    }
    
    return NO;
}

//获取文件下载路径

+(NSString *)getFileDownloadPath:(NSString *)file{
    NSString *result =[NSString stringWithFormat:@"http://%@:%@/studyManager/%@", [OperatePlist HTTPServerAddress],[OperatePlist HTTPServerPort], file];
    return  result;
}


//返回文件下载路径

//+ (NSString *)imageDownloadPath:(NSString *)path width:(NSInteger)width
//{
//    NSString *result =[NSString stringWithFormat:@"http://%@/studyManager/%@", SERVER_ADDRESS, file];
//    if (width != 0) {
//        return [NSString stringWithFormat:@"http://%@:%@/EnnewManager_V2/fileDownload?path=%@&fileType=image&width=%ld",[OperatePlist HTTPServerAddress],[OperatePlist HTTPServerPort],path,width * 2];
//    } else {
//        return [NSString stringWithFormat:@"http://%@:%@/EnnewManager_V2/fileDownload?path=%@&fileType=image",[OperatePlist HTTPServerAddress],[OperatePlist HTTPServerPort],path];
//    }
//}
//
//+ (NSString *)audioDownloadPath:(NSString *)path
//{
//    return [NSString stringWithFormat:@"http://%@:%@/EnnewManager_V2/fileDownload?path=%@",[OperatePlist HTTPServerAddress],[OperatePlist HTTPServerPort],path];
//}

//文件上传路径
+ (NSString *)fileUploadPath
{
    return [NSString stringWithFormat:@"http://%@:%@/studyManager/UploadServlet",[OperatePlist HTTPServerAddress],[OperatePlist HTTPServerPort]];
}

+ (NSString *)systemDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString *)relativePathToAbsolutePath:(NSString *)filePath
{
    return [[self systemDocumentFolder] stringByAppendingPathComponent:filePath];
}

+ (NSString *)showTime:(NSString *)time {
    NSString *result=@"";
    NSDate *today=[NSDate date];
    NSDate *date=[self stringToDate:time :@"yyyy-MM-dd HH:mm:ss"];
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *beforeyesterday, *yesterday;
    
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    beforeyesterday = [today dateByAddingTimeInterval: -secondsPerDay*2];
    
    NSString *todayString = [[self dateToString:today :@"yyyy-MM-dd HH:mm:ss.SSS"] substringToIndex:10];
    NSString *yesterdayString = [[self dateToString:yesterday :@"yyyy-MM-dd HH:mm:ss.SSS"] substringToIndex:10];
    NSString *beforeyesterdayString = [[self dateToString:beforeyesterday :@"yyyy-MM-dd HH:mm:ss.SSS"] substringToIndex:10];
    
    NSString *dateString = [time substringToIndex:10];
    
    //获取时间,如果是英文的,放在时间的后面
    NSString *dateShow=[self dateToString:date :@"HH:mm"];
    
    if ([dateString isEqualToString:todayString]){
        //今天
        result=dateShow;
    }
    else if ([dateString isEqualToString:yesterdayString]){
        //昨天
        result=@"昨天";
    }
    else if ([dateString isEqualToString:beforeyesterdayString]){
        //前天
        result=@"前天";
        
    }
    else
    {
        result=dateString;
    }
    
    return result;
}

//字符串转时间
+ (NSDate *)stringToDate:(NSString *)dateString :(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: format];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

//时间转字符串
+ (NSString *)dateToString:(NSDate *)date :(NSString *)format {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *dateString = [dateFormat stringFromDate:date];
    return dateString;
}


//分段显示字体颜色
+ (NSMutableAttributedString *)settingString:(NSString *)string
                                  withLength:(NSInteger)length
                                  firstColor:(UIColor *)color
                                 secondColor:(UIColor *)otherColor
{
    NSMutableAttributedString *showString=[[NSMutableAttributedString alloc] initWithString:string];
    [showString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, length)];
    [showString addAttribute:NSForegroundColorAttributeName value:otherColor range:NSMakeRange(length, [string length] - length)];
    return showString;
}

//获取中文拼音
+ (NSString *)getChineseSpelling:(NSString *)string
{
    NSMutableString *str = [NSMutableString stringWithString:string];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *spelling = [str capitalizedString];
    return spelling;
}

//utc时间转换
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)date
{
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
    return destinationDateNow;
}
@end


@implementation JZCommon (UITool)

+ (UIButton *)buttonWithTitle:(NSString *)title backgroundColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor frame:(CGRect)frame target:(id)target selector:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (bgColor == nil) {
        bgColor = [UIColor whiteColor];
    }
    [btn setBackgroundColor:bgColor];
    if (titleColor == nil) {
        titleColor = [UIColor blackColor];
    }
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end