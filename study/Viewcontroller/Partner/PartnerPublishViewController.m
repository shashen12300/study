//
//  PartnerPublishViewController.m
//  study
//
//  Created by yang on 15/11/11.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import "PartnerPublishViewController.h"
#import "PublishTableViewCell.h"
#import "PublishKeyboardView.h"
#import "PublishHeaderView.h"
#import "FaceView.h"
#import "SeletPicViewController.h"
#import "SeletPlaceViewController.h"
#import "AlertFriendViewController.h"
#import "PartnerCore.h"
#import "UploadFileCore.h"
#import "BottomAlertViewController.h"

@interface PartnerPublishViewController () <UITableViewDataSource, UITableViewDelegate, PublishKeyboardViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SeletPicViewControllerDelegate, SeletPlaceViewControllerDelegate, AlertFriendViewControllerDelegate, PartnerCoreDelegate, UploadDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FaceView *faceView;                 // 表情
@property (nonatomic, strong) PublishKeyboardView *keyboardView;  // 键盘
@property (nonatomic, strong) PublishHeaderView *headerView;      // textview及图片view

@property (nonatomic, strong) NSMutableArray *textArray;          // cell上的文字

@property (nonatomic, copy)   NSString *selectPlace;              // 选择的地点

@property (nonatomic, strong) NSArray *logArray;                  // 提醒界面记录数组
@property (nonatomic, strong) NSArray *alertPhotosArray;          // 提醒的人的数据数组

@end

@implementation PartnerPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textArray = [[NSMutableArray alloc] initWithObjects:@"我的位置",@"提醒朋友", nil];
    self.alertPhotosArray = [[NSArray alloc] init];
    self.logArray = [NSArray new];
    self.selectPlace = @"";
    
    [self setupSubviews];
    [self setupNav];
    [self setupKeyboard];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - inner methods
- (void)setupSubviews {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, -64, Main_Width, 20)];
    v.backgroundColor = [UIColor blackColor];
    [self.view addSubview:v];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    
    self.faceView = [[FaceView alloc] initWithFrame:CGRectMake(0, Main_Height - 64, Main_Width, 110)];
    [self.view addSubview:self.faceView];
}

- (void)setupKeyboard {
    self.keyboardView = [[PublishKeyboardView alloc] initWithFrame:CGRectMake(0, Main_Height - 64, Main_Width, widget_width(100))];
    self.keyboardView.delegate = self;
    self.keyboardView.isShowKeyboard = YES;
    [self.view addSubview:self.keyboardView];
}

- (void)setupNav {
    [self setNavigationTitle:@""];
    self.navigationItem.leftBarButtonItem = [self addItemWithTitle:@"取消" titleColor:UIColorFromRGB(0xffffff) target:self action:@selector(popToPresentationController)];
    self.navigationItem.rightBarButtonItem = [self addItemWithTitle:@"发送" titleColor:UIColorFromRGB(0xff7949) target:self action:@selector(send)];
}

- (void)popToPresentationController {
    [self.navigationController popViewControllerAnimated:NO];
}

// 截取当前屏幕图片
- (UIImage*)screenView:(UIView *)view{
    CGRect rect = view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)send {
    if(self.headerView.textView.text.length == 0 && self.imageArray.count == 0) {
        PromptMessage(@"发表内容不可为空");
        return;
    }
    
    [self creatHudWithText:@"发布中..."];
    
    UploadFileCore *uploadFileCore = [[UploadFileCore alloc] init];
    uploadFileCore.delegate = self;

    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *tempDic in self.imageArray) {
        UIImage *image = tempDic[@"image"];
        NSData *imageData = UIImageJPEGRepresentation(image,0.5);
        [array addObject:imageData];
    }
    
    [uploadFileCore uploadFileArray:array lastIsAudio:NO];
}

#pragma mark - UploadDelegate
- (void)uploadResultByArray:(NSArray *)returnPath {
    NSMutableString *string = [[NSMutableString alloc] init];
    if (returnPath.count == self.imageArray.count) {
        for(NSInteger index = 0; index < returnPath.count; index++) {
            [string appendFormat:@"%@;",returnPath[index]];
        }
        [string deleteCharactersInRange:NSMakeRange(string.length-1, 1)];
        
        [self publishWithString:string];
    }else {
        [self stopHud];
        [self promptMessage:@"文件上传失败"];
    }
}

- (void)publishWithString:(NSString *)string {
    PartnerCore *core = [[PartnerCore alloc] init];
    core.delegate = self;
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:self.headerView.textView.text forKey:@"content"];
    [dic setObject:[UserInfoList loginUserId] forKey:@"userId"];
    [dic setObject:@"G" forKey:@"visibleRange"];
    [dic setObject:string forKey:@"photourl"];
    [dic setObject:self.selectPlace forKey:@"location"];
    
    [core publishWithParam:dic];
}

#pragma mark - PartnerCoreDelegate
- (void)publishResult:(BOOL)result {
    [self stopHud];
    if (result) {
        [self promptMessage:@"发布成功"];
        
        if ([self.delegate respondsToSelector:@selector(writeDynamic)]) {
            [self.delegate writeDynamic];
        }
        
        [self.navigationController popViewControllerAnimated:NO];
    }else
        [self promptMessage:@"发布失败"];
}

#pragma mark - UITableViewDataSource / UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *PublishCell = @"PublishCellIdentifier";
    PublishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PublishCell];
    if(cell == nil) {
        cell = [[PublishTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PublishCell];
    }
    
    // 获取cell高度
    NSInteger cellHieght;
    if (indexPath.row == 0) {
        cellHieght = widget_height(80);
    }else {
        if (self.alertPhotosArray.count > 5) {
            cellHieght = widget_width(125);
        }else
            cellHieght = widget_width(80);
    }
    
    cell.cellHeight = cellHieght;
    [cell reloadFrame];
    cell.alertArray = self.alertPhotosArray;
    
    NSArray *showImageArray = @[@"partner_publish_location",@"partner_publish_warm"];
    
    cell.showImage.image = [UIImage imageNamed:showImageArray[indexPath.row]];
    cell.showLabel.text = self.textArray[indexPath.row];
    
    if (indexPath.row == 0) {
        cell.showImageView.hidden = YES;
    }else {
        cell.showImageView.hidden = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return widget_width(80);
    }
    if (self.alertPhotosArray.count > 5) {
        return widget_width(125);
    }
    return widget_width(80);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideKeyboard];
    
    if (indexPath.row == 0) {
        SeletPlaceViewController *placeVC = [[SeletPlaceViewController alloc] init];
        placeVC.delegate = self;
        [self.navigationController pushViewController:placeVC animated:YES];
    }else {
        AlertFriendViewController *friendVC = [[AlertFriendViewController alloc] init];
        friendVC.infoArray = self.logArray;
        friendVC.delegate = self;
        [self.navigationController pushViewController:friendVC animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    int imageHeight;
    if (self.imageArray.count > 5) {
        imageHeight = widget_width(204);
    }else
        imageHeight = widget_width(92);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, imageHeight + widget_width(230))];
    view.backgroundColor = UIColorFromRGB(0xe2e2e2);
    
    self.headerView = [[PublishHeaderView alloc] initWithFrame:CGRectMake(0, widget_width(20), CGRectGetWidth(view.frame), CGRectGetHeight(view.frame) - widget_width(40))];
    [view addSubview:self.headerView];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.imageArray];
    if (array.count < 9) {
        [array addObject:[NSDictionary dictionaryWithObject:[UIImage imageNamed:@"partner_publish_addImage"] forKey:@"image"]];
    }
    for (UIView *v in self.headerView.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            [v removeFromSuperview];
        }
    }
    for (int i = 0; i < array.count; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(widget_width(112 * (i%5)), widget_width(112 * (i/5)), widget_width(92), widget_width(92))];
        image.userInteractionEnabled = YES;
        [self.headerView.pictureView addSubview:image];
        image.image = array[i][@"image"];
        
        if (i == self.imageArray.count) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPicture)];
            [image addGestureRecognizer:tap];
        }
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    int imageHeight;
    if (self.imageArray.count > 5) {
        imageHeight = widget_width(204);
    }else
        imageHeight = widget_width(92);
    
    return imageHeight + widget_width(230);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, widget_width(2))];
    view.backgroundColor = UIColorFromRGB(0xe2e2e2);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return widget_width(2);
}

// 添加图片
- (void)addPicture {
    [self hideKeyboard];
    
    BottomAlertViewController *alert = [[BottomAlertViewController alloc] init];
    alert.backImageView.image = [self screenView:self.navigationController.view];
    [alert addActionWithString:@"拍照"];
    [alert addActionWithString:@"从本地相册选择"];
    [self presentViewController:alert animated:NO completion:NULL];
    
    __weak PartnerPublishViewController *partnerVC = self;
    alert.tapBlock = ^(NSInteger section){
        switch (section) {
            case 100:
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    imagePicker.allowsEditing = YES;
                    imagePicker.delegate = partnerVC;
                    [partnerVC presentViewController:imagePicker animated:YES completion:NULL];
                }else {
                    PromptMessage(@"相机不能用");
                }
            }
                break;
            case 101:
            {
                SeletPicViewController *picVC = [[SeletPicViewController alloc] init];
                picVC.delegate = partnerVC;
                picVC.maxSelext = 9 - partnerVC.imageArray.count;
                [partnerVC.navigationController pushViewController:picVC animated:YES];
            }
                break;
            
            default:
                
                break;
        }
    };
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:image,@"image", nil];
    [dic setValue:@"photo" forKey:@"photo"];
    
    [self.imageArray addObject:dic];
    [self.tableView reloadData];
}

#pragma mark - SeletPicViewControllerDelegate
- (void)selectPicWithImages:(NSArray *)imageArr {
    [self.imageArray addObjectsFromArray:imageArr];
    [self.tableView reloadData];
}

#pragma mark - SeletPlaceViewControllerDelegate
- (void)selectPlace:(NSDictionary *)place {
    [self.textArray replaceObjectAtIndex:0 withObject:place[@"name"]];
    self.selectPlace = place[@"name"];
    [self.tableView reloadData];
}

#pragma mark - AlertFriendViewControllerDelegate
- (void)alertFriendWithDataArray:(NSArray *)dataArray logArray:(NSArray *)logArray {
    self.alertPhotosArray = [NSArray arrayWithArray:dataArray];
    self.logArray = [NSArray arrayWithArray:logArray];
    [self.tableView reloadData];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideKeyboard];
}

#pragma mark - KeyboardNotification
- (void)keyboardWillShow:(NSNotification *)notification {
    self.keyboardView.frame = CGRectMake(0, Main_Height - 64, Main_Width, widget_width(100));
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    CGRect toolViewRect = self.keyboardView.frame;
    toolViewRect.origin.y -= widget_width(100);
    toolViewRect.origin.y -= keyboardEndFrame.size.height;
    
    __weak PartnerPublishViewController *selfWeak = self;
    [UIView animateWithDuration:animationDuration animations:^{
        if (selfWeak) {
            [selfWeak.keyboardView setFrame:toolViewRect];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardView.frame = CGRectMake(0, Main_Height - widget_width(100) - 64, Main_Width, widget_width(100));
}

#pragma mark - PublishKeyboardViewDelegate
- (void)showKeyboard:(BOOL)isKeyboard {
    if (isKeyboard) {
        [self showFaceView];
    }else
        [self hideFaceView];
}

- (void)showFaceView {
    [self.headerView.textView resignFirstResponder];
    self.faceView.frame = CGRectMake(0, Main_Height - 110 - 64, Main_Width, 110);
    self.keyboardView.frame = CGRectMake(0, Main_Height - widget_width(100) - 110 - 64, Main_Width, widget_width(100));
    self.keyboardView.isShowKeyboard = NO;
}

- (void)hideFaceView {
    self.faceView.frame = CGRectMake(0, Main_Height - 64, Main_Width, 110);
    self.keyboardView.frame = CGRectMake(0, Main_Height - 64, Main_Width, widget_width(100));
    self.keyboardView.isShowKeyboard = YES;
    [self.headerView.textView becomeFirstResponder];
}

- (void)hideKeyboard {
    self.faceView.frame = CGRectMake(0, Main_Height - 64, Main_Width, 110);
    self.keyboardView.frame = CGRectMake(0, Main_Height - 64, Main_Width, widget_width(100));
    self.keyboardView.isShowKeyboard = YES;
    [self.headerView.textView resignFirstResponder];
}

@end