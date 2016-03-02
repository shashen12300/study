//
//  PackageAPI.m
//  BankCardScanDemo
//
//  Created by mac on 15-1-7.
//
//

#import "PackageAPI.h"
#import "Config.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/sysctl.h>

@interface PackageAPI ()

@end

@implementation PackageAPI

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//将小写转换为大写
-(NSString*)lower2Uppercase:(NSString*)str
{
    char *strP;
    strP = [str UTF8String];
    const char *conStrP = strP;
    
    while (*strP != '\0') {
        if (*strP >= 'a' && *strP <= 'z') {
            *strP-=32;
        }
        strP++;
    }
    NSString *uppercase = [[NSString alloc] initWithUTF8String:conStrP];
    return uppercase;
}

//获取手机uuid，作为rand
-(NSString*)rand_uuid
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    
    CFRelease(uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    
    CFRelease(uuid_string_ref);
    
    return uuid;
    
}

#pragma mark -- md5
- (NSString *)md5:(NSString *)str
{
    if (str == nil) {
        return nil;
    }
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//获取当前时间戳
-(NSString*)currentTimestamp
{
    NSString *sTime = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] *1000];
    NSLog(@"%@", sTime);
    return  [sTime substringToIndex:13];
}

-(NSString *)getPhoneModel
{
    size_t size;
    // get the length of machine name
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    // get machine name
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2(WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2(GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2(CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air(WiFi)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"x64Simulator";
    else
        return platform;
}


#pragma mark -- package
/*##################################################################################
 上传 需要上传的数据包格式：
 
 <action>idcard</action>
 <client>%username%</client>
 <system>系统描述：包括硬件型号和操作系统型号等</system><!--不能为空-->
 <key>随机数UUID</key><!--不能为空，也永远不能重复，长度没有限制-->
 <time>当前时间</time><!--long型13位数字，时间误差不能超过2天-->
 <verify>MD5(action+client+key+time+%password%)</verify>
 <file>二进制文件，文件最大5M</file><!--要进行识别的文件-->
 <ext>文件扩展名</ext><!--只能为下面的之一：jpg/jpeg/bmp/tif/tiff-->
 
 上传包说明：
 1）%%表示为变量，值在文档的前面有交代。
 2）verify为32位大写的MD5值
 3）<!-- -->内包含的是注释，所以上传包时，不要传注释
 
 返回：
 
 ####################################################################################*/
-(NSString *)uploadPackage:(NSData*)imageData andindexPath:(NSInteger)indexPath
{
    NSString *upAction;
    NSString *username = @"51e6d4d0-3f84-4099-99a3-982b83553692";
    NSString *psd = @"HzNUJZWHItCUhkVkREKykslFgNFhKp";
    NSString *md5Psd = [self md5:psd];
    NSString *deviceType = [self getPhoneModel];
    NSString *currentTime = [[NSString alloc] initWithString:[self currentTimestamp]];
    NSString *rand = [[NSString alloc] initWithString:[self rand_uuid]];
    if (indexPath == 0) {
        upAction = @"bankcard.scan";
    }
    NSString *verify = [[NSString alloc] initWithFormat:@"%@%@%@%@%@", upAction, username, rand, currentTime, psd];
    verify = [self md5:verify];
    //    verify = [self lower2Uppercase:verify];
    NSString *fileExt = [self typeForImageData:imageData];
    
    NSString *imageStr = [imageData base64Encoding];
    
    NSMutableString *upPackageString = [[NSMutableString alloc] init];

    upPackageString = [[NSMutableString alloc] initWithFormat:@"<action>%@</action><client>%@</client><system>%@</system><password>%@</password><key>%@</key><time>%@</time><verify>%@</verify><ext>%@</ext><type>%@</type><file>%@</file>", upAction, username, deviceType, md5Psd, rand, currentTime, verify, fileExt,@"1", imageStr];
    
    NSMutableData *postData = (NSMutableData *)[upPackageString dataUsingEncoding:NSUTF8StringEncoding];
    
    [self doASIHttpWithData:postData];
    return [self analyResult];
}

//ASIHttp获取数据
-(void) doASIHttpWithData:(NSMutableData*)postData
{
    NSURL *url = [[NSURL alloc] initWithString:serverUrl];
    ASIHTTPRequest *urlRequest = [ASIHTTPRequest requestWithURL:url];
    [urlRequest setPostBody:postData];
    [urlRequest setDelegate:self];
    [urlRequest setRequestMethod:@"POST"];
    [urlRequest startSynchronous];
    NSError *error = [urlRequest error];
    if (!error) {
        NSData * nsData = [urlRequest responseData];
        self.result = [[NSString alloc]initWithBytes:[nsData bytes]length:[nsData length]encoding:NSUTF8StringEncoding];
    }
    else
    {
        self.result = ERROR_SERVER;
    }
}

-(NSString *)analyResult
{
    return self.result;
}

-(NSString *)typeForImageData:(NSData *)data
{
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
            
        case 0x89:
            return @"png";
            
        case 0x47:
            return @"gif";
            
        case 0x49:
            
        case 0x4D:
            return @"tiff";
    }
    return nil;
}

#pragma mark - ASIHTTPRequestDelegate

//- (void)requestDone:(ASIHTTPRequest *)request
//{
//    self.result = [request responseString];
//    self.receiveData = [request responseData];
//}
//
//- (void)requestWentWrong:(ASIHTTPRequest *)request
//{
//    NSError *error = [request error];
//    //[self.delegate httpBaseModelCallBack:self withError:error];
//    NSLog(@"服务器请求错误，错误为：%@",error);
//    self.result = ERROR_SERVER;
//    
//}

////请求并接收响应头文件
//- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
//{
//    [receiveData setLength:0];
//}
//
////请求并接收数据
//- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
//{
//    if (!receiveData)
//    {
//        receiveData=[[NSMutableData alloc]init];
//    }
//    [receiveData appendData:data];
//}
//
////请求完成
//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    //中文转码
//    NSString * str = [[NSString alloc]initWithData:receiveData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",str);
//    
//
//}
//
////请求失败
//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    NSLog(@"请求失败error:%@",[request error]);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
