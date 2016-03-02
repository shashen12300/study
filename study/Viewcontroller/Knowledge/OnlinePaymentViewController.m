//
//  OnlinePaymentViewController.m
//  study
//
//  Created by mijibao on 16/1/28.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "OnlinePaymentViewController.h"
#import "PayTableViewCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AliPayOrder.h"
#import "WXApi.h"

@interface OnlinePaymentViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *payArray;  
@property (nonatomic, strong) PayTableViewCell *lastCell;

@end

@implementation OnlinePaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线支付";
    _payArray = @[@"余额支付",@"微信支付",@"支付宝支付",@"QQ钱包支付"];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, Main_Width, 40)];
    contentLabel.text = [NSString stringWithFormat:@"      此课件将收取您¥%@元的费用",self.costMoney];
    contentLabel.textColor = lightColor;
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentLabel];
    
    UITableView *payTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MaxY(contentLabel)+20, Main_Width, 190) style:UITableViewStylePlain];
    payTableView.delegate = self;
    payTableView.dataSource = self;
    payTableView.scrollEnabled = NO;
    payTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:payTableView];
    UILabel *payView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Width, 30)];
    payView.text = @"       支付方式";
    payView.font = [UIFont systemFontOfSize:11];
    payView.textColor = RGBVCOLOR(0x656565);
    payView.backgroundColor = [UIColor whiteColor];
    [payTableView beginUpdates];
    payTableView.tableHeaderView = payView;
    [payTableView endUpdates];
    //支付按钮
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(0, MaxY(payTableView)+10, Main_Width, 40);
    [payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    payBtn.backgroundColor = lightColor;
    [payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payBtn];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
// 支付按钮
- (void)payBtnClick {
    if ([_lastCell.pay isEqualToString:@"余额支付"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂不支持余额支付" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else if ([_lastCell.pay isEqualToString:@"微信支付"]) {
        [self weixinPay];
    }else if ([_lastCell.pay isEqualToString:@"支付宝支付"]) {
        [self aliPay];
    }else if ([_lastCell.pay isEqualToString:@"QQ钱包支付"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂不支持QQ钱包支付" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择支付类型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSLog(@"%@",_lastCell.pay);
}

- (void)weixinPay {
    
    if (![WXApi isWXAppInstalled]) {
        NSLog(@"没有安装微信");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有安装微信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else if (![WXApi isWXAppSupportApi]) {
        NSLog(@"不支持微信支付");
    }

    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            }else{
//                return [dict objectForKey:@"retmsg"];
                NSLog(@"%@",[dict objectForKey:@"retmsg"]);
            }
        }else{
            NSLog(@"服务器返回错误，未获取到json对象");
        }
    }else{
        NSLog(@"服务器返回错误");
    }

}

//支付宝支付
- (void)aliPay {
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"";
    NSString *seller = @"";
    NSString *privateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    AliPayOrder *order = [[AliPayOrder alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = @"123456789"; //订单ID（由商家自行制定）
    order.productName = @"测试商品标题"; //商品标题
    order.productDescription = @"测试商品描述"; //商品描述
    order.amount = @"商品价格"; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8"; //商户网站使用的编码方式，默认的是utf-8
    order.itBPay = @"30m"; //未付款交易的超时时间
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //签名值由服务器进行处理并返回客户端
    NSString *signedString = @"xxxxxxx_sign";
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
    
    
}

#pragma -mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *Cell = @"Cell";
    PayTableViewCell *payCell = [tableView dequeueReusableCellWithIdentifier:Cell];
    if (!payCell) {
        payCell = [[PayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell];
        payCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    payCell.pay = _payArray[indexPath.row];
    return payCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _payArray.count;
}

#pragma -mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSIndexPath *lastIndexPath = nil;

    PayTableViewCell *payCell = [tableView cellForRowAtIndexPath:indexPath];
    if (_lastCell) {
        _lastCell.select = NO;
    }
    payCell.select = YES;
    lastIndexPath = indexPath;
    _lastCell = payCell;

}

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
