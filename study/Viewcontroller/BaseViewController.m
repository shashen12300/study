//
//  BaseViewController.m
//  vms
//
//  Created by jzkj on 15/11/18.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import "BaseViewController.h"
#import "MenuViewController.h"
#import "ShipInfoViewController.h"
#import "CombineViewController.h"
#import "RootViewController.h"

#import <MBProgressHUD.h>

@interface BaseViewController ()
// 遮挡层
@property (nonatomic, strong) UIButton *shadowView;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarColor:UIColorFromRGB(0x0e96df)];
    [self.view setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
    
    self.shadowView = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.shadowView addTarget:self action:@selector(hideLeftView:) forControlEvents:UIControlEventTouchUpInside];
    self.shadowView.alpha = 0.3;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self setStateColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setStateColor:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -20, Main_W, 20)];
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
    [[UINavigationBar appearance] setBackgroundImage:[self createImageWithColor:color withSize:CGSizeMake(Main_W, 64)] forBarMetrics:UIBarMetricsDefault];
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
- (void)setNavigationTitle:(NSString *)string
{
    self.navigationItem.title = string;
}

//返回按钮
- (void)setBackBarButtonItemTitle:(NSString *)string
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:string style:UIBarButtonItemStylePlain target:nil action:nil];
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

#pragma mark - 

- (void)autoLayFrontViewController:(BOOL)animated withCurrentXoffset:(CGFloat)xoffset rightOrLeft:(BOOL)rightOrLeft
{
    NSTimeInterval animatedTime=0;
    if (animated) {
        animatedTime = ABS(KswipeWidth - xoffset) / KswipeWidth * SwipeDuration;
    }
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:animatedTime animations:^{
        [self layoutFrontViewWithOffset:(rightOrLeft == YES) ? KswipeWidth : 0];
    } completion:^(BOOL finished) {
        if (rightOrLeft == YES) {
            [self.tabBarController.view addSubview:self.shadowView];
        } else if (rightOrLeft == NO) {
            if (self.shadowView && self.shadowView.superview) {
                [self.shadowView removeFromSuperview];
            }
        }
    }];
}


- (void)layoutFrontViewWithOffset:(CGFloat)xoffset
{
    
    static CGFloat h2w = 0;
    if (h2w == 0) {
        h2w = KScreenHeight / KScreenWidth;
    }
    
    CGFloat scale = KWipeScale(xoffset);
    self.tabBarController.view.transform = CGAffineTransformMakeScale(scale, scale);
    self.tabBarController.view.left = xoffset;
    CGFloat menuScale = KSwipeMenuScale(xoffset);

    UINavigationController *rootNVC = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    for (UIViewController *_rootVC in rootNVC.viewControllers) {
        if ([_rootVC isKindOfClass:[CombineViewController class]]) {
            MenuViewController *_menuViewController = [(CombineViewController *)_rootVC menuViewController];
            _menuViewController.view.transform = CGAffineTransformMakeScale(menuScale, menuScale);
            _menuViewController.view.alpha = KSwipeMenuAlpha(xoffset);
            _menuViewController.view.left = KSwipeMenuLeft(xoffset);
        }
    }
}

- (void)hideLeftView:(UIButton *)shadowView{
    
    [self autoLayFrontViewController:YES withCurrentXoffset:0 rightOrLeft:NO];
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

//检查网络
- (NetworkStatus)checkCurrentNetWork
{
    NetworkStatus status = [Reachability reachabilityWithHostName:@"www.baidu.com"].currentReachabilityStatus;
    
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

@end
