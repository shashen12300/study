//
//  CommentViewController.m
//  study
//
//  Created by jzkj on 16/2/16.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController (){
    UITextView *_inputView;
}

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNavigation];
    [self layoutSubViews];
}
- (void)layoutNavigation{
    self.navigationItem.title = @"评价";
    self.navigationItem.leftBarButtonItem = [self addItemWithTitle:@"取消" titleColor:[UIColor whiteColor] target:self action:@selector(cancleComment)];
    self.navigationItem.rightBarButtonItem = [self addItemWithTitle:@"完成" titleColor:UIColorFromRGB(0xff7949) target:self action:@selector(commitComment)];
}
- (void)layoutSubViews{
    self.view.backgroundColor = RGBCOLOR(226, 226, 226);
    NSArray *imagepArr = @[@"goodpraise",@"mediumpraise",@"badpraise"];
    NSArray *selectimagepArr = @[@"goodpraiseselect",@"mediumpraiseselect",@"badpraiseselect"];
    NSArray *praiseArr = @[@"好评",@"中评",@"差评"];
    for (int i = 0; i<3 ; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.frame = CGRectMake(Main_Width / 3 * i, 5, Main_Width / 3, 50);
        [btn setImage:[UIImage imageNamed:imagepArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectimagepArr[i]] forState:UIControlStateSelected];
        [btn setTitle:praiseArr[i]];
        [btn setTitleColor:UIColorFromRGB(0x606060) forState:UIControlStateNormal];
        if (i == 0) {
            btn.selected = YES;
            [btn setTitleColor:UIColorFromRGB(0xff7949) forState:UIControlStateSelected];
        }else if (i == 1){
            [btn setTitleColor:UIColorFromRGB(0xffc149) forState:UIControlStateSelected];
        }else {
            [btn setTitleColor:UIColorFromRGB(0x6d6d6d) forState:UIControlStateSelected];
        }
        btn.tag = 200 + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.imageEdgeInsets = UIEdgeInsetsMake(13, Main_Width / 6 - 30, 13, Main_Width / 6 + 5);
//        btn.titleEdgeInsets = UIEdgeInsetsMake(13, 20, 13, 20);
        [self.view addSubview:btn];
    }
    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, 60, Main_Width, 195)];
    backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backview];
    _inputView = [[UITextView alloc] initWithFrame:CGRectMake(20, 5, Main_Width - 40, 100)];
    _inputView.textColor = UIColorFromRGB(0x464444);
    _inputView.font = [UIFont systemFontOfSize:14];
    [backview addSubview:_inputView];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 105, Main_Width - 40, 1)];
    lineView.backgroundColor = RGBCOLOR(226, 226, 226);
    [backview addSubview:lineView];
    NSArray *titleArr = @[@"耐心负责",@"解题详细",@"思路清晰",@"方法独到",@"赞"];
    [titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:obj forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.tag = 100 + idx;
        [btn setTitleColor:UIColorFromRGB(0x6d6d6d) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xff7949) forState:UIControlStateSelected];
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 5;
        btn.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
        btn.frame = CGRectMake(20 + (idx % 4 ) * ((Main_Width - 30) / 4), 115 + (idx / 4) * 40, ((Main_Width - 40) / 4) - 10, 30);
        [btn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.selected = NO;
        [backview addSubview:btn];
    }];
   
}
- (void)cancleComment{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)commitComment{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//评价
- (void)commentBtnClick:(UIButton *)btn{
    if (btn.selected) {
        btn.selected = NO;
        btn.layer.borderColor = UIColorFromRGB(0xdcdcdc).CGColor;
    }else{
        btn.selected = YES;
        btn.layer.borderColor = UIColorFromRGB(0xff7949).CGColor;
    }
}
//好评
-(void)praiseBtnClick:(UIButton *)btn{
    for (int i =0 ; i < 3; i++) {
        UIButton *butn = (UIButton *)[self.view viewWithTag:200+i];
        butn.selected = NO;
    }
    btn.selected = YES;
}
- (void)submitComment{
    AFHTTPRequestOperationManager *manage = [AFHTTPRequestOperationManager manager];
    [manage GET:[NSString stringWithFormat:@"http://%@:%@/studyManager/instantAnswerAction/satisfiedOrNO.action",[OperatePlist HTTPServerAddress],[OperatePlist HTTPServerPort]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
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
