//
//  BottomAlertViewController.m
//  study
//
//  Created by yang on 16/1/26.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "BottomAlertViewController.h"

@interface BottomAlertViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *backGroundView;   // 覆盖底图
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation BottomAlertViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataArray = [[NSMutableArray alloc] initWithObjects:@"取消", nil];
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

- (void)setupSubviews {
    self.backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.backImageView];
    
    self.backGroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.backGroundView];
    self.backGroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self.backGroundView addGestureRecognizer:tap];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Main_Height - widget_width(100), Main_Width, widget_width(100)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.scrollEnabled = NO;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
    self.view = nil;
}

- (void)addActionWithString:(NSString *)string {
    [self.dataArray insertObject:string atIndex:(self.dataArray.count - 1)];
    
    self.tableView.frame = CGRectMake(0, Main_Height - widget_width(100) - (self.dataArray.count - 1)*widget_width(90), Main_Width, widget_width(100) + (self.dataArray.count - 1)*widget_width(90));
}

#pragma mark - UITableViewDataSource / UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableCell = @"tableviewcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableCell];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, widget_width(90))];
    view.backgroundColor = UIColorFromRGB(0xffffff);
    
    UILabel *label = [[UILabel alloc] initWithFrame:view.frame];
    label.text = self.dataArray[section];
    label.userInteractionEnabled = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColorFromRGB(0x3b3b3b);
    [view addSubview:label];
    label.tag = 100 + section;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [label addGestureRecognizer:tap];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return widget_width(90);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    int height = 0;
    if (self.dataArray.count - 1 == section) {
        height = 0;
    }else if (self.dataArray.count - 2 == section) {
        height = widget_width(10);
    }else
        height = widget_width(1);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, height)];
    view.backgroundColor = UIColorFromRGB(0xe2e2e2);
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.dataArray.count - 1 == section) {
        return 0;
    }else if (self.dataArray.count - 2 == section) {
        return widget_width(10);
    }
    
    return widget_width(1);
}


- (void)tapGesture:(UITapGestureRecognizer *)gesture {
    [self dismissViewControllerAnimated:NO completion:nil];

    NSInteger section = gesture.view.tag;
    if (self.tapBlock) {
        self.tapBlock(section);
    }
}

@end
