//
//  MineBuySubjectViewController.m
//  study
//
//  Created by mijibao on 16/2/2.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "MineBuySubjectViewController.h"
#import "CollectionCore.h"
#import "CollectionManager.h"
#import "MineCollectionViewCell.h"
#import "ImageRequestCore.h"

@interface MineBuySubjectViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, CollectionCoreDelegate, UIAlertViewDelegate>

@end

static NSString * _sectionIdentifier = @"sectionIdentifier";

@implementation MineBuySubjectViewController
{
    NSMutableArray *_buyArray;//购买数据
    NSMutableArray *_showArray;//页面展示的收藏数据
    UICollectionView *_collectionView;
    UISearchBar *_searchBar;//搜索框
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买课程";
    _buyArray = [[NSMutableArray alloc] initWithArray:[[CollectionManager shareInstance] gainDataArray]];
    _showArray = [NSMutableArray arrayWithArray:_buyArray];
    if (_buyArray.count == 0) {
        [self creatHudWithText:@"加载中..."];
    }
    [self creatUI];
    [self getBuyData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)creatUI
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, Main_Width, 40)];
    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setItemSize:CGSizeMake(widget_width(344), widget_width(190))];//设置cell的尺寸
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
    flowLayout.sectionInset = UIEdgeInsetsMake(widget_height(22), widget_width(22), widget_height(22), widget_width(22));//设置其边界
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setMinimumLineSpacing:widget_height(30)];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, MaxY(_searchBar), Main_Width, Main_Height - 64) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [_collectionView registerClass:[MineCollectionViewCell class] forCellWithReuseIdentifier:_sectionIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
}
#pragma mark 网路请求
- (void)getBuyData{
    CollectionCore *core = [[CollectionCore alloc] init];
    core.delegate = self;
    [core requestMyCollectionByUserId:[UserInfoList loginUserId]];
}

#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _showArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MineCollectionViewCell *cell = (MineCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:_sectionIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 6;
    CollectionModel *model = _showArray[indexPath.row];
    cell.titleLabel.text = model.title;
    [cell.subImageView setImage:[UIImage imageNamed:model.subject]];
    [ImageRequestCore requestImageWithPath:model.picurl withImageView:cell.videoImageView placeholderImage:nil];
    cell.textView.text = @"这是一个很寂寞的夜，下着有些伤心的雨";
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击课程，进入课程详情页面");
}

#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _showArray = [[NSMutableArray alloc] init];
    if ([JZCommon isBlankString:searchText]) {
        _showArray = _buyArray;
    }else{
        for (CollectionModel *model in _buyArray) {
            NSString *spelling = [JZCommon getChineseSpelling:model.title];
            if ([spelling containsString:searchText] || [model.title containsString:searchText]) {
                [_showArray addObject:model];
            }
        }
    }
    [_collectionView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

#pragma mark CollectionCoreDelegate(收藏网络请求回调)
- (void)passSearchResult:(BOOL)isSuccess resultInfomation:(NSMutableArray *)infomation
{
    [self stopHud];
    [self delaySeconds:0.3f perform:^{
        if (isSuccess) {
            _buyArray = infomation;
            if (_buyArray.count == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有关注任何老师，赶紧去关注您喜爱的老师吧" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
                [alert show];
            }else{
                _showArray = [NSMutableArray arrayWithArray:_buyArray];
                [_collectionView reloadData];
            }
        }else{
            [self showMessage:@"请求失败"];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)delaySeconds:(float)seconds perform:(dispatch_block_t)block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
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
