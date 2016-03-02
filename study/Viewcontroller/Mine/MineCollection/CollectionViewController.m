//
//  CollectionViewController.m
//  study
//
//  Created by mijibao on 16/1/26.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "CollectionViewController.h"
#import  "CollectionCore.h"
#import "CollectionManager.h"
#import "MineCollectionViewCell.h"
#import "ImageRequestCore.h"

static NSString * _sectionIdentifier = @"sectionIdentifier";

@interface CollectionViewController ()<CollectionCoreDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>

@end

@implementation CollectionViewController
{
    NSMutableArray *_collectionArray;//收藏数据
    NSMutableArray *_showCollectionArray;//页面展示的收藏数据
    UICollectionView *_collectionView;
    UIView *_moreView;//长按后点击更多后视图
    UIImageView *_longPressView;//长按后的视图
    NSIndexPath *_indexPath;//记录当前长按的cell
    UIImageView *_editView;//点击更多后出现在cell上的编辑图
    MineCollectionViewCell *_cell;
    UISearchBar *_searchBar;//搜索框
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    _collectionArray = [[NSMutableArray alloc] initWithArray:[[CollectionManager shareInstance] gainDataArray]];
    _showCollectionArray = [NSMutableArray arrayWithArray:_collectionArray];
    if (_collectionArray.count == 0) {
        [self creatHudWithText:@"加载中..."];
    }
    [self creatUI];
    [self getCollectionData];
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
- (void)getCollectionData{
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
    return _showCollectionArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MineCollectionViewCell *cell = (MineCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:_sectionIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 6;
    CollectionModel *model = _showCollectionArray[indexPath.row];
    cell.titleLabel.text = model.title;
    [cell.subImageView setImage:[UIImage imageNamed:model.subject]];
    [ImageRequestCore requestImageWithPath:model.picurl withImageView:cell.videoImageView placeholderImage:nil];
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressCollection:)];
    [cell addGestureRecognizer:gesture];
    cell.textView.text = @"这是一个很寂寞的夜，下着有些伤心的雨";
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击收藏，进入课程详情页面");
}

#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _showCollectionArray = [[NSMutableArray alloc] init];
    if ([JZCommon isBlankString:searchText]) {
        _showCollectionArray = _collectionArray;
    }else{
        for (CollectionModel *model in _collectionArray) {
            NSString *spelling = [JZCommon getChineseSpelling:model.title];
            if ([spelling containsString:searchText] || [model.title containsString:searchText]) {
                [_showCollectionArray addObject:model];
            }
        }
    }
    [_collectionView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

#pragma mark 长按手势进入收藏编辑页面
- (void)longPressCollection:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint p = [gesture locationInView:_collectionView];
        _indexPath = [_collectionView indexPathForItemAtPoint:p];
        _cell = (MineCollectionViewCell *)[_collectionView cellForItemAtIndexPath:_indexPath];
        _cell.backgroundColor = UIColorFromRGB(0x737373);
        _collectionView.userInteractionEnabled = NO;
        _searchBar.userInteractionEnabled = NO;
        if (_indexPath.row % 2 != 0) {
            [self addLongPressViewWithFrame:CGRectMake(MinX(_cell), MaxY(_cell) + widget_height(76),  widget_width(305), widget_height(76))];
        }else{
            [self addLongPressViewWithFrame:CGRectMake(MinX(_cell) + widget_width(130), MaxY(_cell) + widget_height(76),  widget_width(305), widget_height(76))];
        }
    }
}

- (void)longPressEvent:(UIButton *)btn
{
    [_longPressView removeFromSuperview];
    switch (btn.tag) {
        case 100:
        {//点击转发按钮
            _collectionView.userInteractionEnabled = YES;
            _searchBar.userInteractionEnabled = YES;
            _cell.backgroundColor = [UIColor whiteColor];
            NSLog(@"点击了转发按钮");
        }
            break;
        case 101:
        {//点击删除按钮
            [self deleteCollection];
        }
            break;
        case 102:
        {//点击更多按钮
            NSLog(@"点击了更多按钮");
            [self creatMoreView];
        }
            break;
        default:
            break;
    }
}

- (void)creatMoreView
{
    _cell = (MineCollectionViewCell *)[_collectionView cellForItemAtIndexPath:_indexPath];
    _editView = [[UIImageView alloc]initWithFrame:CGRectMake(widget_width(304) * 0.5, widget_width(156) * 0.5, widget_width(40), widget_width(40))];
    [_editView setImage:[UIImage imageNamed:@"Collection_More"]];
    [_cell addSubview:_editView];
    _moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, 45)];
    _moreView.backgroundColor = [UIColor whiteColor];
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Main_Width * 0.5 - 0.5, 40)];
    [self setImage:@"Collection_Cancel" forBtn:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelDelete) forControlEvents:UIControlEventTouchUpInside];
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(MaxX(cancelBtn) + 1, 0, Main_Width * 0.5 - 0.5, 40)];
    [deleteBtn addTarget:self action:@selector(makeSureDelete) forControlEvents:UIControlEventTouchUpInside];
    [self setImage:@"Collection_Delete" forBtn:deleteBtn];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(Main_Width * 0.5 - 0.5, 5, 1, 35)];
    lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [_moreView addSubview:lineView];
    [self.view addSubview:_moreView];
}

- (void)cancelDelete
{
    [_moreView removeFromSuperview];
    [_editView removeFromSuperview];
    _cell.backgroundColor = [UIColor whiteColor];
    _collectionView.userInteractionEnabled = YES;
    _searchBar.userInteractionEnabled = YES;
}

- (void)makeSureDelete
{
    NSLog(@"删除收藏,请求删除收藏接口");
    [_moreView removeFromSuperview];
    [_editView removeFromSuperview];
    [self deleteCollection];
}

- (void)deleteCollection
{
    _cell.backgroundColor = [UIColor whiteColor];
    _collectionView.userInteractionEnabled = YES;
    _searchBar.userInteractionEnabled = YES;
}

#pragma mark CollectionCoreDelegate(收藏网络请求回调)
- (void)passSearchResult:(BOOL)isSuccess resultInfomation:(NSMutableArray *)infomation
{
    _collectionArray = infomation;
    _showCollectionArray = [NSMutableArray arrayWithArray:_collectionArray];
    [_collectionView reloadData];
    [self stopHud];
}

- (void)addLongPressViewWithFrame:(CGRect)frame
{
    _longPressView = [[UIImageView alloc]initWithFrame:frame];
    [_longPressView setImage:[UIImage imageNamed:@"Collection_LongPress"]];
    NSArray *array = @[@"转发", @"删除", @"更多..."];
    for (int i = 0; i < 3; i ++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * widget_width(305)/3, widget_height(15), widget_width(305)/3 , widget_height(76) - widget_height(15))];
        [self setBtnStatus:btn WithTitle:array[i] withTag:i + 100];
        [_longPressView addSubview:btn];
        if (i < 2) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake((i + 1) *widget_width(305)/3, widget_height(25), 1, widget_height(76) -widget_height(40))];
            line.backgroundColor = UIColorFromRGB(0xe2e2e2);
            [_longPressView addSubview:line];
        }
    }
    _longPressView.userInteractionEnabled = YES;
    [self.view addSubview:_longPressView];
}

- (void)setImage:(NSString *)imagename forBtn:(UIButton *)btn
{
    UIView *imageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, btn.size.width, btn.size.height)];
    UIImage *image = [UIImage imageNamed:imagename];
    imageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    [btn setImage:image forState:UIControlStateNormal];
    [_moreView addSubview:btn];
}

- (void)setBtnStatus:(UIButton *)btn WithTitle:(NSString *)title withTag:(NSInteger)tag
{
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleFont:[UIFont systemFontOfSize:13]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self action:@selector(longPressEvent:) forControlEvents:UIControlEventTouchUpInside];
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
