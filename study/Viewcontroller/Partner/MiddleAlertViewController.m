//
//  MiddleAlertViewController.m
//  study
//
//  Created by yang on 16/1/26.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "MiddleAlertViewController.h"

@interface MiddleAlertViewController ()

@property (nonatomic, strong) UIView *backGroundView;   // 覆盖底图
@property (nonatomic, strong) UIView *backView;         // 提示框底图
@property (nonatomic, strong) UILabel *titleLabel;      // 标题
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIView *horizontalLine;   // 横线
@property (nonatomic, strong) UIView *verticalLine;     // 竖线

@end

@implementation MiddleAlertViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTitle:(NSString *)title leftMessage:(NSString *)leftMessage rightMessage:(NSString *)rightMessage {
    self.titleLabel.text = title;
    [self.leftButton setTitle:leftMessage forState:UIControlStateNormal];
    [self.rightButton setTitle:rightMessage forState:UIControlStateNormal];
}

- (void)setupSubviews {
    self.backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.backImageView];
    
    self.backGroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.backGroundView];
    self.backGroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.backGroundView addGestureRecognizer:tap];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)/2 - 110, CGRectGetHeight(self.view.frame)/2 - 50, 220, 100)];
    [self.view addSubview:self.backView];
    [self.backView.layer setMasksToBounds:YES];
    [self.backView.layer setCornerRadius:widget_width(20)];
    self.backView.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 220, 50 - 0.25*kScreenScale)];
    self.titleLabel.textColor = UIColorFromRGB(0x3b3b3b);
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.backView addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.backView.frame), 0.5*kScreenScale)];
    self.horizontalLine.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [self.backView addSubview:self.horizontalLine];
    
    self.leftButton = [[self class] buttonWithFrame:CGRectMake(0, CGRectGetMaxY(self.horizontalLine.frame), 110 - 0.25*kScreenScale, 50 - 0.25*kScreenScale) textColor:UIColorFromRGB(0x3b3b3b) textFont:[UIFont systemFontOfSize:13]];
    [self.backView addSubview:self.leftButton];
    [self.leftButton addTarget:self action:@selector(handleLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.verticalLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftButton.frame), CGRectGetMinY(self.leftButton.frame), 1*kScreenScale, CGRectGetHeight(self.leftButton.frame))];
    self.verticalLine.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [self.backView addSubview:self.verticalLine];
    
    self.rightButton = [[self class] buttonWithFrame:CGRectMake(CGRectGetMaxX(self.verticalLine.frame), CGRectGetMinY(self.leftButton.frame),  110 - 0.5*kScreenScale, 50 - 0.25*kScreenScale) textColor:UIColorFromRGB(0x3b3b3b) textFont:[UIFont systemFontOfSize:13]];
    [self.backView addSubview:self.rightButton];
    [self.rightButton addTarget:self action:@selector(handleRightButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleLeftButton:(UIButton *)button {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)handleRightButton:(UIButton *)button {
    self.tapBlock();
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
}

+ (UIButton *)buttonWithFrame:(CGRect)frame
                    textColor:(UIColor *)color
                     textFont:(UIFont *)font
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitleColor:color forState:UIControlStateNormal];
    
    return button;
}


@end
