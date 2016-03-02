//
//  SearchViewController.m
//  study
//
//  Created by mijibao on 16/1/18.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "SearchViewController.h"
#import "LectureModel.h"
#import <UIImageView+AFNetworking.h>

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *sourceArray;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUI];
}

- (void)creatUI {
    //
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Main_Width - 70, 30)];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索";
    _searchBar = searchBar;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    UIButton *rightBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 35, 30);
    [rightBtn setTitleColor:lightColor forState:UIControlStateNormal];
    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置导航栏背景
    self.navigationController.navigationBar.barTintColor = RGBCOLOR(219, 219, 219);
    self.tabBarController.tabBar.hidden = YES;
    [_searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //设置导航栏背景
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.tabBarController.tabBar.hidden = NO;
}

// 取消
- (void)cancelBtnClick {
    NSLog(@"取消");
    [self.navigationController popViewControllerAnimated:YES];
}

//判断是否包含字符串
- (void)lectureModel:(LectureModel *)model containString:(NSString *)string {
    if ([self isBlankString:model.title] ) {
        return;
    }
    if([model.title rangeOfString:string].location !=NSNotFound)
    {
        NSLog(@"yes");
        [self.sourceArray addObject:model];
        
    }
    else
    {
        NSLog(@"no");
    }
    
}

//搜索课程
- (void)searchLecture:(NSString *)title {
    [_sourceArray removeAllObjects];

        for (NSInteger i = 0; i < _dataArray.count; i ++) {
            LectureModel *model = _dataArray[i];
            //判断roadTitleLab.text 是否含有qingjoin
            [self lectureModel:model containString:title];
        }
    [_myTableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if ([self isBlankString:searchBar.text]) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(searchLectureTitle:)]) {
        [self.delegate searchLectureTitle:searchBar.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma -mark search
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [searchBar resignFirstResponder];
    }

    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchLecture:searchText];
}

#pragma -mark UITableViewDataDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _searchBar.text = cell.textLabel.text;
    [_searchBar resignFirstResponder];
}

#pragma -mark  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    LectureModel *model = [_sourceArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = model.title;
    return cell;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = [NSArray arrayWithArray:dataArray];
}

- (NSMutableArray *)sourceArray {
    if (!_sourceArray) {
        _sourceArray = [[NSMutableArray alloc] init];
    }
    return _sourceArray;
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
