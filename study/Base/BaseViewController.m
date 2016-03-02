//
//  BaseViewController.m
//  vms
//
//  Created by jzkj on 15/11/18.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import "BaseViewController.h"

#import <MBProgressHUD.h>

@interface BaseViewController ()
// 遮挡层
@property (nonatomic, strong) UIButton *shadowView;

@property (nonatomic, strong) MBProgressHUD *hud;   // 菊花

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarColor:[UIColor blackColor]];
    [self.view setBackgroundColor:UIColorFromRGB(0xe2e2e2)];
    [self setBackBarButtonItemTitle:@""];
    [self setnaviGAtionTitltColorAndFont];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    [self setStateColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setStateColor:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -20, Main_Width, 20)];
    [view setBackgroundColor:color];
    [self.navigationController.navigationBar addSubview:view];
}

#pragma mark - NavigationContorller
//设置导航条的状态（显示或隐藏）
- (void)setNavigationState:(BOOL)isHidden
{
    self.navigationController.navigationBarHidden = isHidden;
}

//颜色
- (void)setNavigationBarColor:(UIColor *)color
{
    [self.navigationController.navigationBar setBarTintColor:color];
}
//图片
- (void)setNavigationBarBgImg:(NSString *)imgName
{
    //self.navigationController.navigationBar == [UINavigationBar appearance]
    //导航条的颜色64 128像素
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:imgName] forBarMetrics:UIBarMetricsDefault];
}

- (void)setNavigationBarBgImgWithImg:(UIImage *)img
{
    //self.navigationController.navigationBar == [UINavigationBar appearance]
    //导航条的颜色64 128像素
    [[UINavigationBar appearance] setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
}

- (void)setNavigationBarBgImgWithColor:(UIColor *)color
{
    [[UINavigationBar appearance] setBackgroundImage:[self createImageWithColor:color withSize:CGSizeMake(Main_Width, 64)] forBarMetrics:UIBarMetricsDefault];
}

- (void)setNavigationBarTitle:(NSString *)string withColor:(UIColor *)color
{
    [self setNavigationBarTitle:string withColor:color WithFontSize:17];
}

- (void)setNavigationBarTitle:(NSString *)string withColor:(UIColor *)color WithFontSize:(CGFloat)size;
{
    [self setNavigationBarTitle:string withColor:color WithFontName:@"Heiti SC" WithFontSize:size];
}

//@"HelveticaNeue-CondensedBlack"
//文字
- (void)setNavigationBarTitle:(NSString *)string withColor:(UIColor *)color WithFontName:(NSString *)fontName WithFontSize:(CGFloat)size
{
    //    UITextAttributeFont - 字体
    //    UITextAttributeTextColor - 文字颜色
    //    UITextAttributeTextShadowColor - 文字阴影颜色
    //    UITextAttributeTextShadowOffset - 偏移用于文本阴影
    self.navigationItem.title = string;
//    NSShadow *shadow = [[NSShadow alloc] init];
    //    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    //    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           color, NSForegroundColorAttributeName,
//                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:fontName size:size], NSFontAttributeName,nil,nil]];
}

- (void)setnaviGAtionTitltColorAndFont
{
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                      [UIFont systemFontOfSize:17], NSFontAttributeName,nil,nil]];
}
- (void)setNavigationTitle:(NSString *)string
{
    self.navigationItem.title = string;
}

//返回按钮
- (void)setBackBarButtonItemTitle:(NSString *)string
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:string style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem = item;
}

//没有图图片的 按钮
- (UIButton *)createBtnWithFrame:(CGRect)frame withTitle:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:frame];
    //    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    ViewBorderRadius(btn, 4, 1, [UIColor greenColor]);
    return btn;
}
//图片上文字下 按钮
- (UIButton *)createBtnWithFrame:(CGRect)frame withTitle:(NSString *)title withImageName:(NSString *)image
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:frame];
    //    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setTopImageSize:CGSizeMake(60, 60) imageTopHeight:0 titleBottomHeight:0];
    
    return btn;
}

//UIStatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


- (UIImage *)createImageWithColor:(UIColor *)color withSize:(CGSize)imagesize
{
    // 使用颜色创建UIImage
    UIGraphicsBeginImageContext(imagesize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, imagesize.width, imagesize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIBarButtonItem *)addItemWithTitle:(NSString *)name imageName:(NSString *)imageName target:(id)target action:(SEL)selector
{
    UIButton * btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = CGRectMake(5, 0, 18, 26);
    [btn setTitle:name forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return item;
    
}

- (UIBarButtonItem *)addItemWithTitle:(NSString *)name titleColor:(UIColor *)color target:(id)target action:(SEL)selector
{
    UIButton * btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = CGRectMake(5, 0, 30, 26);
    [btn setTitleFont:[UIFont systemFontOfSize:15]];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return item;
    
}

// 截取当前屏幕图片
- (UIImage*)screenView:(UIView *)view{
    CGRect rect = view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//检查网络
- (NetworkStatus)checkCurrentNetWork
{
    NetworkStatus status = [Reachability reachabilityWithHostname:@"www.baidu.com"].currentReachabilityStatus;
    if (status == NotReachable) {
        [self showMessage:@"请检测网络状况..."];
    }else if (status == ReachableViaWWAN)
    {
        [self showMessgaseWithString:@"提示" Message:@"当前网络为蜂窝数据,请注意流量!"];
    }
    return status;
}

- (void)showMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)showMessgaseWithString:(NSString *)title Message:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.detailsLabelText = message;
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    [hud hide:YES afterDelay:2];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//非空判断
- (BOOL)isBlankString:(NSString *)string
{
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

#pragma mark - 弱提示
- (void)promptMessage:(NSString *)message
{
    //    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    //    hud.labelText = message;
    //    hud.mode = MBProgressHUDModeText;
    //    hud.labelColor = [UIColor whiteColor];
    //    [hud showAnimated:YES whileExecutingBlock:^{
    //        sleep(2.0f);
    //    } completionBlock:^{
    //        [hud removeFromSuperview];
    //    }];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = message;
    hud.mode = MBProgressHUDModeText;
    hud.labelColor = [UIColor whiteColor];
    [hud hide:YES afterDelay:2];
}

- (void)creatHudWithText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.labelText = text;
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.labelColor = [UIColor whiteColor];
    });
}

- (void)stopHud {
    [self.hud hide:YES];
}

- (void)showHud {
    [self.hud hide:NO];
}
@end
