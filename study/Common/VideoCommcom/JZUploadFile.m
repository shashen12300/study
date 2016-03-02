//
//  ViewController.m
//  JZUploadFileDemo
//
//  Created by mijibao on 15/10/8.
//  Copyright (c) 2015年 songcc. All rights reserved.
//

#import "JZUploadFile.h"
#import "FileHash.h"
#import "UIDevice+IdentifierAddition.h"
@interface JZUploadFile ()
@property (nonatomic, strong) AsyncSocket *tcpSocket1;
@property (nonatomic, strong) AsyncSocket *tcpSocket2;
@property (nonatomic, strong) AsyncSocket *tcpSocket3;
@property (nonatomic, strong) AsyncSocket *tcpSocket4;
@property (nonatomic, strong) NSMutableArray *socketNarray;

@property (nonatomic, strong) NSString *IP_Address;   //IP 地址
@property (nonatomic, assign) NSUInteger port;         //端口号

@property (nonatomic,assign) unsigned long long offset;   //偏移量
@property (nonatomic,assign) unsigned long long fileSize; //文件尺寸
@property (nonatomic,assign) BOOL  lastFileOffestStatus; //上次服务器存在的文件偏移量
@property (nonatomic, assign) NSUInteger packageSize;     //前3包的大小
@property (nonatomic, assign) NSUInteger lastPackageSize; //最后一包的大小
@property (nonatomic, assign) NSUInteger totalPackage;    //总包数
@property (nonatomic, strong) NSString *fileType;         //文件类型




@property (nonatomic, strong) NSString *fileName;     //文件名字
@property (nonatomic, strong) NSString *filePath;     //文件路径
@property (nonatomic, assign) NSUInteger fileNumber;  //文件数目
@property (nonatomic, assign) NSUInteger progress;    //文件上传进度

@property (nonatomic,strong) NSFileHandle *fileHandle;
@property (nonatomic, assign) NSInteger packageOrder; //包顺序
@property (nonatomic, assign) BOOL isExistFile;       //判断文件服务器是否存在

@property (nonatomic, assign) BOOL uploadBegin;  //开始
@property (nonatomic, assign) BOOL uploadEnd;    //结束
@property (nonatomic, assign) BOOL uploadPause;  //暂停
@property (nonatomic, assign) BOOL netWorkFale;  //连接断开




@end

@implementation JZUploadFile
//初始化端口
- (id)initHost:(NSString *)host port:(NSUInteger)port {
    if ([super init]) {
        _IP_Address = host;
        _port = port;
        _socketNarray = [NSMutableArray new];

    }
    return self;

}
//建立socket连接
- (void)buildConnectChannel {
    if (_fileSize) {
        [_socketNarray removeAllObjects];
        if (_totalPackage>1) {
            _tcpSocket1 = [[AsyncSocket alloc] initWithDelegate:self];
            [_tcpSocket1 setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            _tcpSocket2 = [[AsyncSocket alloc] initWithDelegate:self];
            [_tcpSocket2 setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            _tcpSocket3 = [[AsyncSocket alloc] initWithDelegate:self];
            [_tcpSocket3 setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            _tcpSocket4 = [[AsyncSocket alloc] initWithDelegate:self];
            [_tcpSocket4 setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            
            [_socketNarray insertObject:_tcpSocket1 atIndex:0];
            [_socketNarray insertObject:_tcpSocket2 atIndex:1];
            [_socketNarray insertObject:_tcpSocket3 atIndex:2];
            [_socketNarray insertObject:_tcpSocket4 atIndex:3];
        }
        else
        {
            _tcpSocket1 = [[AsyncSocket alloc] initWithDelegate:self];
            [_tcpSocket1 setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
            [_socketNarray insertObject:_tcpSocket1 atIndex:0];
        }
        [self socketConnectHost];
    }
    else
    {
        NSLog(@"文件路径不对");
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"提示" message:@"文件路径不对" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alt show];
        return;
    }
}

#pragma -mark 开始上传
- (void)startUpload
{
    NSLog(@"开始上传");
    if (_uploadBegin==YES) {
        return;
    }
    _progress = 0;
    _lastFileOffestStatus = NO;
    _uploadBegin = NO;
    _uploadEnd= NO;
    _uploadPause = NO;
    [self buildConnectChannel]; //开通socket建立链接
    NSData *data = [@"1\r\n" dataUsingEncoding:NSUTF8StringEncoding];
    [_tcpSocket1 writeData:data withTimeout:-1 tag:0];
    [_tcpSocket1 readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0];
}
#pragma -mark  暂停上传
- (void)pauseUpload
{
    _uploadPause = YES;
    _uploadBegin = NO;
    _uploadEnd = NO;
    
    [self socketDisconnect];

    NSLog(@"暂停上传");
}
//断开socket连接
- (void)socketDisconnect {
    for (int index=0; index<_socketNarray.count; ++index) {
        AsyncSocket *socket = _socketNarray[index];
        if (socket.isConnected==YES) {
            [socket disconnect];
        }
    }
}

#pragma -mark 配置文件信息
- (void)uploadFilePath:(NSString *)filePath fileName:(NSString *)fileName
{
    if (fileName) {
        _fileName = fileName;
    }
    else {
        NSArray *array = [filePath componentsSeparatedByString:@"/"];
        _fileName = [array lastObject];
    }
    _offset = 0;
    _progress = 0;
    _packageOrder = 0;
    _uploadBegin = NO;
    _filePath = filePath;
    [self getfileType:filePath];
    
//    if ([_fileType isEqualToString:@"5"]) {
//        _filePath = [self fileZip:filePath];
//    }
//    else {
//        //_filePath = filePath;
//        _filePath = [self fileZip:filePath];
//
//    }
    _fileSize = [self fileSizeAtPath:filePath];
    _fileHandle = [NSFileHandle fileHandleForReadingAtPath:_filePath];
//    if (_fileSize>10*pow(1024, 2)) {
//        _totalPackage = 4;
//    }
//    else {
        _totalPackage = 1;
//    }
    _packageSize = _fileSize/_totalPackage;
    _lastPackageSize = (_fileSize - _packageSize*(_totalPackage-1));


}
//获取文件类型
- (void)getfileType:(NSString *)filePath {
    if (filePath) {
        NSArray *array = [filePath componentsSeparatedByString:@"."];
        NSString *fileTypeStr = [array lastObject];
        if ([fileTypeStr isEqualToString:@"png"]||[fileTypeStr isEqualToString:@"jpg"]) {
            _fileType = @"1";
        }
        else if ([fileTypeStr isEqualToString:@"mp3"]||[fileTypeStr isEqualToString:@"wav"]) {
            _fileType = @"2";
        }
        else if ([fileTypeStr isEqualToString:@"mp4"]||[fileTypeStr isEqualToString:@"rmvb"]) {
            _fileType = @"3";
        }
        else if ([fileTypeStr isEqualToString:@"zip"]||[fileTypeStr isEqualToString:@"rar"]){
            _fileType = @"4";
            NSLog(@"类型不匹配");
        }
        else   //文档
        {
            _fileType = @"5";
//            [self fileZip:filePath];
        }
    }
}

////zip压缩文件
//- (NSString *)fileZip:(NSString *)filePath {
//    // 1. 获取Documents目录，新的zip文件要写入到这个目录里。
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docspath = [paths objectAtIndex:0];
//    NSArray *array = [_fileName componentsSeparatedByString:@"."];
//    NSString *newName = [array[0] stringByAppendingString:@".zip"];
//    NSString *zipFile = [docspath stringByAppendingPathComponent:newName];
//    NSLog(@"path======%@",zipFile);
//    ZipArchive *za = [[ZipArchive alloc] init];
//    [za CreateZipFile2:zipFile];  //创建zip文件
//    [za addFileToZip:filePath newname:_fileName];
//    // 把zip从内存中写入到磁盘中去。
//    BOOL success = [za CloseZipFile2];
//    NSLog(@"Zipped file with result %d",success);
//    if (success) {
//        return zipFile;
//    }
//    else
//    return 0;
//}


#pragma -mark 根据偏移量上传包文件
- (void)splitFileAndUpload:(unsigned long long)offset tag:(long)tag
{
    NSData *dataBody = [NSData new];
    if (tag<(_totalPackage-1)) {
        [_fileHandle seekToFileOffset:offset+tag*_packageSize];
        dataBody = [_fileHandle readDataOfLength:_packageSize];

    }
    else
    {
        [_fileHandle seekToFileOffset:offset+(_fileSize-_lastPackageSize)];
        dataBody = [_fileHandle readDataOfLength:_lastPackageSize];
    }
 
    NSString *info = [self generateStringForFileInfoOnServer:tag];  //文件包头信息
    NSMutableData *data = [[NSMutableData alloc] initWithData:[info dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:dataBody];
    [_socketNarray[tag] writeData:data withTimeout:-1 tag:tag];
    [_socketNarray[tag] readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:tag];
}

/**
 *  计算文件大小
 *  @return 文件大小（单位是byte）
 */
- (unsigned long long)fileSizeAtPath:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory;
    if (![manager fileExistsAtPath:path isDirectory:&isDirectory] || isDirectory) {
        NSLog(@"选择的文件不存在 或 选择了目录");
        return 0.0;
    }
    NSError *err;
    NSDictionary *attributes = [manager attributesOfItemAtPath:path error:&err];
    NSNumber *fileSize = [attributes objectForKey:NSFileSize];  //unsigned long long
    return [fileSize unsignedLongLongValue];
}

- (NSString *)generateStringForFileInfoOnServer:(long)tag
{
    _packageOrder = tag;
    NSUInteger currentPackageSize;
    //设置每包的实际长度
    if (tag<(_totalPackage-1)) {
        currentPackageSize = _packageSize;
    }
    else {
    currentPackageSize = _lastPackageSize;
    }
    
    NSString *mid = [[UIDevice currentDevice] machineType];
    NSString *uid = [JZCommon getUserPhone];
    NSString *did = [JZCommon GUID];
    if (!uid.length) {
        uid = @"0";
    }
    NSMutableString *resultString = [[NSMutableString alloc] init];
    [resultString appendString:@"200|"];          //appid
    [resultString appendString:@"1|"];           //versioncode
    [resultString appendString:@"1|"];     //otaVersion
//    [resultString appendString:@"567|"];          //uid
//        [resultString appendString:@"81|"];           //mid
//    [resultString appendString:@"4ea3d4c076164198aa3dbeb59fc8861c|"];   //did
    [resultString appendFormat:@"%@|",uid];
    [resultString appendFormat:@"%@|",mid];
    [resultString appendFormat:@"%@|",did];
    [resultString appendFormat:@"%@|",_fileType];              //1：头像 2：照片 3：音频 4：视频 5
    [resultString appendFormat:@"%f|",[self timeInterval]];             //time 时间戳
    [resultString appendFormat:@"%llu|",_fileSize];                     //fsize  文件大小
    [resultString appendFormat:@"%ld|",(long)_packageOrder];            //每包的顺序
    [resultString appendFormat:@"%ld|",(long)currentPackageSize];             //每包的实际上传尺寸
    [resultString appendFormat:@"%lu|",(unsigned long)_totalPackage];            //文件总包数
    [resultString appendFormat:@"%ld|",(long)_isExistFile];             //判断文件服务器是否已经上传成功
    [resultString appendFormat:@"%@|",[FileHash md5HashOfFileAtPath:_filePath]];  //digest 文件摘要
    NSString *filename = [[_filePath componentsSeparatedByString:@"/"] lastObject];
    [resultString appendFormat:@"%lu|",(unsigned long)filename.length];           //文件名长度
    [resultString appendFormat:@"%@\n",_filePath]; //filename   文件名，在客户端的全路径，string
    NSLog(@"%@",resultString);
    return resultString;
}
//时间戳
- (NSTimeInterval)timeInterval
{
    return [[NSDate date] timeIntervalSince1970];
}

#pragma -mark 上传包头文件信息
- (void)uploadPackageFileMessage {
    for (int index=0; index<_totalPackage; ++index) {
        AsyncSocket *socket = _socketNarray[index];
        _isExistFile = NO;
        NSString *info = [self generateStringForFileInfoOnServer:index];
        NSData *data = [[NSData alloc] initWithData:[info dataUsingEncoding:NSUTF8StringEncoding]];
        [socket writeData:data withTimeout:-1 tag:index];
        [socket readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:index];
    }
}
//获取服务器文件状态
- (void)uploadSinglePackageMessage:(long)tag {
    _isExistFile = YES;
    NSString *info = [self generateStringForFileInfoOnServer:tag];
    NSData *data = [[NSData alloc] initWithData:[info dataUsingEncoding:NSUTF8StringEncoding]];
    [_socketNarray[tag] writeData:data withTimeout:-1 tag:tag];
    [_socketNarray[tag] readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:tag];

}

//tcp连接服务
//连接server
- (void)socketConnectHost{
    
    NSError *err = nil;
    
    for (int index=0; index<_totalPackage; ++index) {
        AsyncSocket *socket = _socketNarray[index];
        if (socket.isDisconnected && _totalPackage>0) {
            if (![socket connectToHost:_IP_Address onPort:_port error:&err]) {
                NSLog(@"TCP建立连接错误%d :%ld %@",index, (long)[err code], [err localizedDescription]);
            } else {
                NSLog(@"[connectServer]TCP成功建立连接%d!",index);
            }
        }
    }
    
}
#pragma -mark  AsyncSocketDelegate
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{

    NSString *resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"接收到服务器的数据长度 ： %lu   内容 :  %@  tag: %ld\n",(unsigned long)[data length],resultStr,tag);
    
    if ([resultStr isEqualToString:@"-5\r\n"])  //询问服务器状态
    {
        _uploadBegin = YES;
        [self uploadSinglePackageMessage:0]; //询问服务器文件文件上传状态
        return;
    }
    else if ([resultStr isEqualToString:@"-1\r\n"] &&_uploadBegin==YES)
    {
        _uploadEnd = YES;
        NSLog(@"表示服务端出错\r\n");
        if ([self.delegate respondsToSelector:@selector(uploadFileStatus:)]) {
            [self.delegate uploadFileStatus:UploadFailure];
        }
    }
    else if ([resultStr isEqualToString:@"-3\r\n"])  //表示文件上传成功
    {
        _uploadEnd = YES;
        if ([self.delegate respondsToSelector:@selector(uploadFileProsess:msgid:)]) {
            [self.delegate uploadFileProsess:100.f msgid:_fileName];
        }
        if ([self.delegate respondsToSelector:@selector(uploadFileStatus:)]) {
            [self.delegate uploadFileStatus:UploadSuccess];
        }
        
        [sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:tag];
        NSLog(@"完整文件已上传成功!!");
    }
    else if (_uploadEnd==YES)
    {
        _uploadBegin = NO;
        [self socketDisconnect]; //断开socket连接
//        NSString *resulet = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if ([self.delegate respondsToSelector:@selector(uploadFileUrl:msgid:)]) {
            [self.delegate uploadFileUrl:resultStr msgid:_fileName];
        }
    }
    //当服务器不存在该文件时，给返回-4，当存在该文件且没有完全上传时，返回文件的负偏移量
    else if ([resultStr isEqualToString:@"-4\r\n"])   //上传断点前文件在服务器中存在的大小
    {   _lastFileOffestStatus = YES;
        NSLog(@"服务端不存在此文件\r\n");
        [self uploadPackageFileMessage];
    }
    else if ([resultStr integerValue]<-5)   //上传断点前文件在服务器中存在的大小
    {   _lastFileOffestStatus = YES;
        _progress = labs([resultStr integerValue]);
        NSLog(@"服务端存在此文件但文件没有上传成功offset: %lu\r\n",(unsigned long)_progress);
        [self uploadPackageFileMessage];
    }
    else if ([resultStr integerValue]>=0)
    {
        _offset = [resultStr integerValue];
        NSLog(@"offect : %llu  tag : %ld\r\n",_offset,tag);
        [self splitFileAndUpload:_offset tag:tag];
    }
    else if ([resultStr isEqualToString:@"-2\r\n"])
    {
        NSLog(@"包文件上传成功!!");
        return;
    }
    else
    {
        NSLog(@"未知错误信息 : %@ ",resultStr);
    }
    
}
#pragma -mark AsyncSocketDelegate
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    NSLog(@"socket连接成功");
    if (_netWorkFale==YES) {
        _netWorkFale = NO;
        for (int index=0; index<_socketNarray.count; ++index) {
            AsyncSocket *socket = _socketNarray[index];
            if (sock==socket) {
                [self uploadSinglePackageMessage:index];
            }
            
        }
    }
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"完成写入 tag : %ld",tag);
}

//当socket写数据但是没完成的时候会被调用，可适用于进度条更新的时候。
-(void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    if (_lastFileOffestStatus) {
        _progress +=partialLength;
        CGFloat uploadProgress = _progress*100.f/_fileSize;
        if (uploadProgress>99.99f) {
            uploadProgress = 99.99f;
        }
        // NSLog(@"写入长度 :%lu    tag: %ld ",(unsigned long)partialLength,tag);
        if ([self.delegate respondsToSelector:@selector(uploadFileProsess:msgid:)]) {
            [self.delegate uploadFileProsess:uploadProgress msgid:_fileName];
        }
    }


}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"连接发生错误:%@", [err localizedDescription]);

}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"连接失败 %ld",sock.userData);
    
    if(_uploadPause==YES||_uploadEnd==YES)
    {
        return;
    }
    else if(_uploadBegin==YES)
    {
        _netWorkFale = YES;

    }
    else
    {
        [self startUpload];
    }
    
    [self socketConnectHost];
}

@end

