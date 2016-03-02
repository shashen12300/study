//
//  RootViewController.m
//  study
//
//  Created by mijibao on 16/1/15.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "RootViewController.h"
#import "PartnerViewController.h"
#import "AnswerViewController.h"
#import "KnowledgeViewController.h"
#import "MineViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backNavBtn = [[UIBarButtonItem alloc]init];
    backNavBtn.title = @"返回";
    backNavBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backNavBtn;
    
    PartnerViewController *partnerVC = [[PartnerViewController alloc] init];
    partnerVC.title = @"伙伴圈";
    partnerVC.tabBarItem.image = [[UIImage imageNamed:@"partner_tabBar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    partnerVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"partner_tabBarSelect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    AnswerViewController *answerVC = [[AnswerViewController alloc] init];
    answerVC.title = @"即时答";
    answerVC.tabBarItem.image = [[UIImage imageNamed:@"menu_tabbar_immediate"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    answerVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"menu_tabbar_immediate_hl"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    KnowledgeViewController *knowVC = [[KnowledgeViewController alloc] init];
    knowVC.title = @"重点知识";
    knowVC.tabBarItem.image = [[UIImage imageNamed:@"zhongdianzhishi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    knowVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"selectzhongdianzhishi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    MineViewController *mineVC = [[MineViewController alloc]init];
    mineVC.tabBarItem.title = @"我的";
    mineVC.tabBarItem.image = [[UIImage imageNamed:@"Mine_TabBar"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"Mine_TabBarSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UINavigationController *partnerNC = [[UINavigationController alloc] initWithRootViewController:partnerVC];
    UINavigationController *instantAnswerNC = [[UINavigationController alloc] initWithRootViewController:answerVC];
    UINavigationController *lectureNC = [[UINavigationController alloc] initWithRootViewController:knowVC];
    UINavigationController *mineNC = [[UINavigationController alloc] initWithRootViewController:mineVC];
    
    NSArray *array = [NSArray arrayWithObjects:partnerNC,instantAnswerNC,lectureNC,mineNC, nil];
    
    self.viewControllers = array;
    self.tabBar.tintColor = UIColorFromRGB(0xff7949);
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.selectedIndex = 0;

    // Do any additional setup after loading the view.
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
