//
//  UploadViewController.m
//  study
//
//  Created by mijibao on 16/1/27.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "UploadViewController.h"
#import "LXActionSheet.h"
#import "JZLSegmentControl.h"
#import "GradeAndSubjectModel.h"
#import "PopMenuView.h"
#import <Masonry.h>
#import <AVFoundation/AVFoundation.h>
#import "UploadFileCore.h"

@interface UploadViewController ()<LXActionSheetDelegate,JZLSegmentControlDelegate,PopMenuViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UploadDelegate>
{
    NSString *_tempGrade;//年级
    NSString *_tempObject;//课程
}
@property (nonatomic, strong) UITextField *titleField;            //标题
@property (nonatomic, strong) UITextView *contentTextView;        //内容
@property (nonatomic, strong) JZLSegmentControl *segmentControl;  //分栏选择
@property (nonatomic, strong) PopMenuView *popMenuView;           //二级控制器
@property (nonatomic, strong) NSMutableArray *gradeList;          // 年级列表
@property (nonatomic, strong) NSMutableDictionary *subjectList;   // 课程列表
@property (nonatomic, strong) UIButton *addBtn;                   //添加
@property (nonatomic, strong) NSData *videoData;


@end

@implementation UploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBVCOLOR(0xdcdcdc);
    [self creatViewUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self creatNavigationUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (instancetype)init
{
    if (self = [super init]) {
        // 获取年级和课程列表
        for (GradeAndSubjectModel *model in [[SharedObject sharedObject] GradeAndSubjectList]) {
            [self.gradeList addObject:model.gradeStr];
            [self.subjectList setObject:model forKey:model.gradeStr];
        }
    }
    return self;
}

//导航栏设置
- (void)creatNavigationUI {
    //设置导航栏字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    //设置导航栏按钮颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置导航栏背景
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    //设置导航栏左按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 50, 30);
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    //设置导航栏右按钮
    UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadBtn.frame = CGRectMake(0, 0, 50, 30);
    uploadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [uploadBtn setTitle:@"上传" forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(uploadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *uploadButtonItem = [[UIBarButtonItem alloc] initWithCustomView:uploadBtn];
    self.navigationItem.rightBarButtonItem = uploadButtonItem;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, cancelButtonItem, nil];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,uploadButtonItem, nil];
}
//设置界面
- (void)creatViewUI {
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, Main_Width, 40)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    _titleField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, Main_Width - 2 * 10, 40)];
    _titleField.backgroundColor = [UIColor whiteColor];
    _titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _titleField.placeholder = @"标题";
    _titleField.font = [UIFont systemFontOfSize:13];
    _titleField.textColor = RGBVCOLOR(0xc2c2c2);
    [whiteView addSubview:_titleField];
    UIView *addView = [[UIView alloc] initWithFrame:CGRectMake(0, MaxY(whiteView) + 10, Main_Width, 144)];
    addView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addView];
    //内容
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, Main_Width - 10 * 2, 84)];
    [addView addSubview:_contentTextView];
    //添加
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(10, MaxY(_contentTextView), 45, 45);
    [addBtn setImage:[UIImage imageNamed:@"tianjia"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [addView addSubview:addBtn];
    _addBtn = addBtn;
    //分栏选择器
    JZLSegmentControl *segmentControl = [[JZLSegmentControl alloc] initWithUploadFrame:CGRectMake(0, MaxY(addView)+10, Main_Width, 42) titles:@[@"请选择年级和班级",@"年级",@"学科"]];
    segmentControl.segmentDelegate = self;
    [self.view addSubview:segmentControl];
    _segmentControl = segmentControl;
}

#pragma mark - JZLSegmentControlDelegate Methods
- (void)segmentControl:(JZLSegmentControl *)segmentControl didselected:(NSString *)title isSelected:(BOOL)selected{
    NSArray *popList = self.gradeList;
    NSString *gradeName = _tempGrade;
    if ([title isEqualToString:@"学科"]) {
        if (gradeName) { // 年级
            popList = [[self.subjectList objectForKey:gradeName] subjects];
        } else {
            segmentControl.selectedButton.selected = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先选择\n年级" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    
    //弹出列表菜单
    if (!_popMenuView) {
        PopMenuView *popMenuView = [[PopMenuView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentControl.frame) + 1, Main_Width,148)];
        popMenuView.delegate = self;
        [self.view addSubview:popMenuView];
        _popMenuView = popMenuView;
        
    }
    [_popMenuView popMenuViewWithTitle:title popList:popList];
    if (selected) {
        _popMenuView.hidden = NO;

    }else {
        _popMenuView.hidden = YES;

    }
}


// 添加
- (void)addBtnClick {
    NSLog(@"添加");
    LXActionSheet *actionSheet = [[LXActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"上传视频",@"上传文档"]];
    [actionSheet showInView:self.view];
}

#pragma -mark PopMenuViewDelegate
- (void)popMenuView:(PopMenuView *)popMenuView didSelected:(NSString *)title popTitle:(NSString *)popTitle {
    if ([popTitle isEqualToString:@"年级"]) {
        _tempGrade = title;
    }
    else if ([popTitle isEqualToString:@"学科"]) {
        _tempObject = title;
    }
}

#pragma -mark LXActionSheetDelegate 
- (void)actionSheet:(LXActionSheet *)lxactionSheet didClickOnButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"上传视频");
        UIImagePickerController *imagePickerController1 = [[UIImagePickerController alloc] init];
        imagePickerController1.delegate = self;
        imagePickerController1.allowsEditing = NO;

        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES) {
            imagePickerController1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController1.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
            [self presentViewController:imagePickerController1 animated:YES completion:^{}];
        }
        else
        {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不支持视频库" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [av show];
        }
    }else if (buttonIndex == 1) {
        NSLog(@"上传文档");
    }
}

// 上传
- (void)uploadBtnClick {
    NSLog(@"上传");
    UploadFileCore *uploadFileCore = [[UploadFileCore alloc]init];
    uploadFileCore.delegate = self;
    [uploadFileCore uploadFile:_videoData fileType:@"video"];
}

// 取消
- (void)cancelBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

//获取视频的缩略图
- (UIImage *)getImage:(NSURL *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
    
}

#pragma -mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSString *mediaType = [picker.mediaTypes objectAtIndex:0];
    if ([mediaType isEqualToString:@"public.movie"]) {
        NSURL *videoUrl = [info valueForKey:UIImagePickerControllerMediaURL];
        _videoData = [NSData dataWithContentsOfURL:videoUrl];
//        _addBtn.imageView.image = [self getImage:videoUrl];
        [_addBtn setImage:[self getImage:videoUrl] forState:UIControlStateNormal];
    }
}

#pragma -mark upl
- (void)uploadResult:(NSString *)result withType:(NSInteger)type {
    NSLog(@"上传路径 : %@",result);
}

#pragma mark - getter
- (NSMutableArray *)gradeList
{
    if (!_gradeList) {
        _gradeList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _gradeList;
}
- (NSMutableDictionary *)subjectList
{
    if (!_subjectList) {
        _subjectList = [[NSMutableDictionary alloc] init];
    }
    return _subjectList;
}

- (NSData *)videoData {
    if (!_videoData) {
        _videoData = [[NSData alloc] init];
    }
    return _videoData;
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
