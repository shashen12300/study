//
//  PackageAPI.h
//  BankCardScanDemo
//
//  Created by mac on 15-1-7.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

//#define serverUrl @"http://eng.ccyunmai.com:5008/SrvEngine"
#define serverUrl @"http://www.yunmaiocr.com/SrvXMLAPI"
@interface PackageAPI : UIViewController<ASIHTTPRequestDelegate>

@property (nonatomic, copy) NSString *statusStr;
@property (nonatomic, copy) NSData *receiveData;
@property (nonatomic, copy) NSString *result;

-(NSString *)uploadPackage:(NSData*)imageData andindexPath:(NSInteger)indexPath;
@end
