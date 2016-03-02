//
//  SeletPicViewController.m
//  study
//
//  Created by mijibao on 15/8/29.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "SeletPicViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SelectPicCollectionViewCell.h"

@interface SeletPicViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    ALAssetsLibrary *_assetLibrary;
}

@property (nonatomic,strong) UICollectionView   *collectionView;
@property (nonatomic,strong) NSMutableArray     *imageArr;        // 相册图片数组

@end

@implementation SeletPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationTitle:@"相机胶卷"];
    self.navigationItem.rightBarButtonItem = [self addItemWithTitle:@"确定" titleColor:UIColorFromRGB(0xff7949) target:self action:@selector(didClickRightButton:)];
    [self setBackBarButtonItemTitle:@""];
    
    self.selectImages = [[NSMutableArray alloc] init];
    self.imageArr = [[NSMutableArray alloc] init];
    //获取相册图片
    [self reloadImagesFromLibrary];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(widget_width(180), widget_width(180));
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = widget_width(10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[SelectPicCollectionViewCell class] forCellWithReuseIdentifier:@"imageCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    CGSize imageSize = CGSizeMake(50, 50);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [[UIColor blackColor] set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.navigationController.navigationBar setBackgroundImage:pressedColorImg forBarMetrics:UIBarMetricsCompact];
    self.navigationController.navigationBar.shadowImage = pressedColorImg;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.clipsToBounds = YES;   // 去掉黑线方法
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didClickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectPicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    NSDictionary *dic = self.imageArr[indexPath.row];
    ALAsset *representation = dic[@"representation"];
    
    switch ([dic[@"select"] integerValue]) {
        case 0:
            cell.selectImageView.hidden = YES;
            cell.borderImageView.hidden = NO;

            break;
            
        default:
            cell.selectImageView.hidden = NO;
            cell.borderImageView.hidden = YES;
            
            break;
    }
    
    cell.photoImageView.image = [UIImage imageWithCGImage:representation.thumbnail];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(widget_width(10), 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectPicCollectionViewCell *cell = (SelectPicCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] initWithDictionary:self.imageArr[indexPath.row]];
    ALAsset *representation = mutableDic[@"representation"];
    
    if([mutableDic[@"select"] isEqualToString:@"0"]) {
        if (self.selectImages.count == self.maxSelext) {
            PromptMessage(@"不能再选了");
            return;
        }
        
        [mutableDic setValue:[UIImage imageWithCGImage:representation.defaultRepresentation.fullScreenImage] forKey:@"image"];
        [mutableDic setValue:@"1" forKey:@"select"];
        [self.imageArr replaceObjectAtIndex:indexPath.row withObject:mutableDic];
        [self.selectImages addObject:mutableDic];
        cell.selectImageView.hidden = NO;
        cell.borderImageView.hidden = YES;
    }else {
        [self.selectImages removeObject:mutableDic];
        [mutableDic setValue:@"0" forKey:@"select"];
        [self.imageArr replaceObjectAtIndex:indexPath.row withObject:mutableDic];
        cell.selectImageView.hidden = YES;
        cell.borderImageView.hidden = NO;
    }
}

#pragma mark - inner methods
// 点击完成
- (void)didClickRightButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
    
    if ([self.delegate respondsToSelector:@selector(selectPicWithImages:)]) {
        [self.delegate selectPicWithImages:self.selectImages];
    }
}

- (void)reloadImagesFromLibrary {
    NSMutableArray *images = [NSMutableArray arrayWithArray:self.selectImages];
    dispatch_async(dispatch_get_main_queue(), ^{
        @autoreleasepool {
            ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
                NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
                if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                    NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
                }else{
                    NSLog(@"相册访问失败.");
                }
            };
            
            ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
                if (result!=NULL) {
                    
                    if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                        NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                        
                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                        [dic setValue:urlstr forKey:@"photo"];
                        [dic setValue:@"0" forKey:@"select"];
                        [dic setValue:result forKey:@"representation"];

                        switch(images.count) {
                            case 0:
    
                                break;
                                
                            default:
                            {
                                for (NSDictionary *tempDic in images) {
                                    NSString *url = tempDic[@"photo"];
                                    if([urlstr isEqualToString:url] || [url isEqualToString:@"photo"]) {
                                        [dic setValue:@"1" forKey:@"select"];
                                        [images removeObject:tempDic];
                                        break;
                                    }
                                }
                            }
                                break;
                        }
                        [self.imageArr addObject:dic];
                    }
                }
                NSLog(@"获取图片-----%ld",(unsigned long)self.imageArr.count);
            };
            
            ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
                if (group == nil) {
                    NSLog(@"grount == nil");
                    [self.collectionView reloadData];
                }
                
                if (group!=nil) {
                    NSString *g=[NSString stringWithFormat:@"%@",group];//获取相簿的组
                    
                    NSString *g1=[g substringFromIndex:16 ] ;
                    NSArray *arr=[[NSArray alloc] init];
                    arr=[g1 componentsSeparatedByString:@","];
                    NSString *g2=[[arr objectAtIndex:0] substringFromIndex:5];
                    if ([g2 isEqualToString:@"Camera Roll"]) {
                        g2=@"相机胶卷";
                    }
//                    NSString *groupName=g2; //组的name
                    [group enumerateAssetsUsingBlock:groupEnumerAtion];
                }
            };

            _assetLibrary = [[ALAssetsLibrary alloc] init];
            [_assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                   usingBlock:libraryGroupsEnumeration
                                 failureBlock:failureblock];
        }
    });
}

@end
