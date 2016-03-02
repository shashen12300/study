//
//  VideoPlayViewController.m
//  study
//
//  Created by jzkj on 16/2/1.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "VideoPlayViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface VideoPlayViewController ()
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器
@end

@implementation VideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"publemLeftBar"] style:UIBarButtonItemStylePlain target:self action:@selector(backTolistView)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.title = @"播放视频";
    NSString *url = [JZCommon getFileDownloadPath:self.msg.url];
    _moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:url]];
    _moviePlayer.view.frame = self.view.bounds;
    _moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_moviePlayer.view];
    //播放
    [self.moviePlayer play];
    // Do any additional setup after loading the view.
}
#pragma mark -跳转操作
- (void)backTolistView{
    [self.navigationController popViewControllerAnimated:YES];
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
