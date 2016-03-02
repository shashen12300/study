 //
//  UserInfoViewController.m
//  study
//
//  Created by mijibao on 15/9/20.
//  Copyright (c) 2015年 jzkj. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoList.h"
#import "UserInfoTableViewCell.h"
#import "YSHYClipViewController.h"
#import "UploadFileCore.h"
#import "UserInfoCore.h"
#import "NicknameViewController.h"
#import "ChangeAccountViewController.h"
#import "LocationViewController.h"
#import "SignatureViewController.h"
#import "HonorsViewController.h"
#import "SchoolViewController.h"
#import "BottomAlertViewController.h"

#import "ImageRequestCore.h"

@interface UserInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ClipViewControllerDelegate>

@end

@implementation UserInfoViewController
{
    UserInfoCore *_core;
    NSString *_sectionIdentifier;
    NSArray *_firstSectionSignArr;
    NSArray *_firstSectionTextArr;
    NSArray *_secondSectionSignArr;
    NSArray *_secondSectionTextArr;
    UITableView *_userInfoTabelView;
    UIImagePickerController * _imagePicker;
    UIButton * _btn;
    ClipType _clipType;//裁剪类型
    UIButton * _circleBtn;
    UIButton * _squareBtn;
    CGFloat _radius;
    UIActionSheet *_sheet;
    UIImagePickerController * _picker;
    UIPickerView *_agePickView;//教龄选择器
    UIView *_shadowView;//黑色透明背景
    NSMutableArray *_selectedSubArray;//选中的课程列表
    NSArray *_subArray;//课程列表
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人信息";
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = YES;
    _sectionIdentifier = @"sectionIdentify";
    _core = [[UserInfoCore alloc]init];
    _core.delegate = self;
    [self creatUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self getUserInfomation];
    [_userInfoTabelView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)creatUI
{
    _userInfoTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height - 64)style:UITableViewStyleGrouped];
    _userInfoTabelView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [_userInfoTabelView registerClass:[UserInfoTableViewCell class] forCellReuseIdentifier:_sectionIdentifier];
    _userInfoTabelView.delegate = self;
    _userInfoTabelView.dataSource = self;
    _userInfoTabelView.scrollEnabled = YES;
    [_userInfoTabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_userInfoTabelView];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_firstSectionSignArr count];
    }else{
        return [_secondSectionSignArr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoTableViewCell *cell = (UserInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:_sectionIdentifier];
    if (cell == nil)
    {
        cell = [[UserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:_sectionIdentifier];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [ImageRequestCore requestImageWithPath:[UserInfoList loginUserPhoto] withImageView:cell.headView placeholderImage:nil];
            cell.headView.tag = 10001;
        }
        cell.signLabel.text = _firstSectionSignArr[indexPath.row];
        cell.infoLabel.text = _firstSectionTextArr[indexPath.row];
        if ([UserInfoList loginSfStatus]) {
            if (indexPath.row == 2) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.userInteractionEnabled = NO;
                cell.infoLabel.textColor = UIColorFromRGB(0xff6949);
            }else{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        cell.signLabel.text = _secondSectionSignArr[indexPath.row];
        cell.infoLabel.text = _secondSectionTextArr[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
            {
               //点击的是用户头像一栏
                [self clickedUserHeadCell:indexPath];
            }
                break;
            case 1:
            {//点击的是用户昵称一栏
                NicknameViewController *nameView = [[NicknameViewController alloc] init];
                [self.navigationController pushViewController:nameView animated:YES];
                
            }
                break;
            case 2:
            {//点击的是用户账号一栏
                ChangeAccountViewController *account = [[ChangeAccountViewController alloc] init];
                [self.navigationController pushViewController:account animated:YES];
            }
            default:
                break;
        }
    }else
    {
            switch (indexPath.row)
            {
                case 0:
                {//点击的是性别
                    [self creatGenderView];
                }
                    break;
                case 1:
                {
                    if ([[UserInfoList loginUserType] isEqualToString:@"S"])
                    {
                       [self creatGradeView];//点击的是年级
                    }else{//点击的是教龄
                        [self creatAgeView];
                    }
                }
                    break;
                case 2:
                {//点击的是地区
                    LocationViewController *location = [[LocationViewController alloc] init];
                    [self.navigationController pushViewController:location animated:YES];
                }
                    break;
                case 3:
                {//点击的是个人签名
                    if ([[UserInfoList loginUserType] isEqualToString:@"S"]) {
                        SignatureViewController *sig = [[SignatureViewController alloc] init];
                        [self.navigationController pushViewController:sig animated:YES];
                    }else{
                        [self creatSubjectView];
                    }
                }
                    break;
                case 4:
                {//点击的是学校
                    SchoolViewController *school = [[SchoolViewController alloc] init];
                    [self.navigationController pushViewController:school animated:YES];
                }
                    break;
                case 5:
                {//点击的是荣誉
                    HonorsViewController *honors = [[HonorsViewController alloc] init];
                    [self.navigationController pushViewController:honors animated:YES];
                
                }
                    break;
                case 6:
                {//点击的是地个人签名
                    SignatureViewController *sig = [[SignatureViewController alloc] init];
                    [self.navigationController pushViewController:sig animated:YES];
                }
                default:
                    break;
            }
    }
}

#pragma mark 点击头像
-(void)clickedUserHeadCell:(NSIndexPath *)indexpath {
    BottomAlertViewController *alert = [[BottomAlertViewController alloc] init];
    alert.backImageView.image = [self screenView:self.tabBarController.view];
    [alert addActionWithString:@"拍照"];
    [alert addActionWithString:@"本地上传"];
    [self presentViewController:alert animated:NO completion:NULL];
    alert.tapBlock = ^(NSInteger section){
        switch (section) {
            case 100:
            {//点击的是拍照
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    imagePicker.allowsEditing = YES;
                    imagePicker.delegate = self;
                    [self presentViewController:imagePicker animated:YES completion:NULL];
                }else {
                    PromptMessage(@"相机不能用");
                }
            }
                break;
            case 101:
            {//点击的是相册
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                [self presentViewController:picker animated:YES completion:nil];

            }
                break;
            default:
                break;
        }
    };
}

#pragma mark 图片拾取器代理事件
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //点击相机的使用照片和相册中的某一张图片，执行以下代理事件
    UIImage * image = info[@"UIImagePickerControllerOriginalImage"];
    NSLog(@"%ld",(long)image.imageOrientation);
    YSHYClipViewController * clipView = [[YSHYClipViewController alloc] initWithImage:image];
    clipView.delegate = self;
    clipView.clipType = CIRCULARCLIP; //支持圆形:CIRCULARCLIP 方形裁剪:SQUARECLIP   默认:圆形裁剪
    clipView.circulWidht = 120;
    clipView.circulHeight = 120;
    [picker pushViewController:clipView animated:YES];
}

#pragma mark ClipViewControllerDelegate（图片裁剪回调）
-(void)ClipViewController:(YSHYClipViewController *)clipViewController FinishClipImage:(UIImage *)editImage
{
    [clipViewController dismissViewControllerAnimated:YES completion:^{
        UploadFileCore *uploadFileCore = [[UploadFileCore alloc] init];
        uploadFileCore.delegate = self;
        NSData *imageData = UIImageJPEGRepresentation(editImage,1.0);
        [uploadFileCore uploadFileArray:@[imageData] lastIsAudio:NO];
    }];
}

#pragma mark 点击性别
- (void)creatGenderView
{
    [self addShadowView];
    UITapGestureRecognizer *cancelGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelShadowView)];
    [_shadowView addGestureRecognizer:cancelGesture];
    UIView *choseView = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Height - 90, Main_Width, 90)];
    choseView.backgroundColor = [UIColor whiteColor];
    NSArray *genArr = @[@"男", @"女"];
    for (int i = 0;  i < 2; i ++) {
        UIButton *genderBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, i * 45, Main_Width, 45)];
        [genderBtn setTitle:genArr[i] forState:UIControlStateNormal];
        [genderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [genderBtn setTitleFont:[UIFont systemFontOfSize:14]];
        [genderBtn addTarget:self action:@selector(changeGender:) forControlEvents:UIControlEventTouchUpInside];
        genderBtn.tag = 1000 + i;
        [choseView addSubview:genderBtn];
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44, Main_Width, 2)];
    line.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [choseView addSubview:line];
    [_shadowView addSubview:choseView];
    [_shadowView bringSubviewToFront:choseView];
}

- (void)changeGender:(UIButton *)btn
{
    NSString *newGender = [[NSString alloc] init];
    if (btn.tag == 1000) {//点击的是男
        newGender = @"M";
    }else if (btn.tag == 1001){//点击的是女
        newGender = @"F";
    }
    [self cancelShadowView];
    [_core changeUserInfomationWithUserId:[UserInfoList loginUserId] newInfomation:newGender infoKey:@"gender" saveKey:[AccountManeger loginUserGender]];
}

#pragma mark 点击年级
- (void)creatGradeView
{
    [self addShadowView];
    UIView *choseView = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Height - 197.5, Main_Width, 197.5)];
    choseView.backgroundColor = [UIColor whiteColor];
    NSArray *gradeArr = @[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级", @"初一", @"初二", @"初三", @"高一", @"高二", @"高三"];
    for (int i = 0;  i < 12; i ++) {
        UIButton *gradeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i < 4) {
            gradeBtn.frame = CGRectMake(20 + i * (50 + (Main_Width - 240)/3), 23.75, 50, 17.5);
        }else if (i < 8 && i > 3){
            gradeBtn.frame = CGRectMake(20 + (i - 4) * (50 + (Main_Width - 240)/3), 65, 50, 17.5);
        }else{
            gradeBtn.frame = CGRectMake(20 + (i - 8) * (50 + (Main_Width - 240)/3), 106.25, 50, 17.5);
        }
        [gradeBtn setTitle:gradeArr[i] forState:UIControlStateNormal];
        if ([gradeArr[i] isEqualToString:[UserInfoList loginUserGrade]]) {
            [gradeBtn setTitleColor:UIColorFromRGB(0xff6949) forState:UIControlStateNormal];
            gradeBtn.layer.borderColor = [UIColorFromRGB(0xff6949)CGColor];
        }else{
            [gradeBtn setTitleColor:UIColorFromRGB(0x494949) forState:UIControlStateNormal];
            gradeBtn.layer.borderColor = [UIColorFromRGB(0xe2e2e2)CGColor];
        }
        [gradeBtn setTitleFont:[UIFont systemFontOfSize:12]];
        [gradeBtn addTarget:self action:@selector(changeGrade:) forControlEvents:UIControlEventTouchUpInside];
        gradeBtn.layer.borderWidth = 1;
        gradeBtn.layer.cornerRadius = 2;
        gradeBtn.tag = 10000 + i;
        [choseView addSubview:gradeBtn];
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 147.5, Main_Width, 5)];
    line.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [choseView addSubview:line];
    [_shadowView addSubview:choseView];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, MaxY(line), Main_Width, 45)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitleFont:[UIFont systemFontOfSize:14]];
    [cancelBtn addTarget:self action:@selector(cancelShadowView) forControlEvents:UIControlEventTouchUpInside];
    [choseView addSubview:cancelBtn];
}

- (void)changeGrade:(UIButton *)btn
{
    [self cancelShadowView];
    NSString *grade = btn.titleLabel.text;
    [_core changeUserInfomationWithUserId:[UserInfoList loginUserId] newInfomation:grade infoKey:@"grade" saveKey:[AccountManeger loginUserGrade]];
}
#pragma mark UploadDelegate(文件上传回调)
- (void)uploadResultByArray:(NSArray *)returnPath
{
    if (!returnPath || ![returnPath count] || [returnPath count] == 0) {
        [self showMessage:@"服务器请求失败"];
    }else{
        [_core changeUserInfomationWithUserId:[UserInfoList loginUserId] newInfomation:returnPath[0] infoKey:@"photo" saveKey:[AccountManeger loginUserPhoto]];
    }
}

#pragma mark 点击的是教龄
- (void)creatAgeView{
    [self addShadowView];
    UIView *ageView = [[UIView alloc] initWithFrame:CGRectMake((Main_Width - 200) * 0.5, widget_height(504), 200, 150)];
    ageView.backgroundColor = [UIColor whiteColor];
    ageView.layer.cornerRadius = 12;
    [_shadowView addSubview:ageView];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 109, 200, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [ageView addSubview:lineView];
    UIView *shortLine = [[UIView alloc] initWithFrame:CGRectMake(99.5, 110, 1, 40)];
    shortLine.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [ageView addSubview:shortLine];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 110, 99.5, 40)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleFont:[UIFont systemFontOfSize:13]];
    [cancelBtn setTitleColor:UIColorFromRGB(0x525252) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelShadowView) forControlEvents:UIControlEventTouchUpInside];
    [ageView addSubview:cancelBtn];
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(100.5, 110, 99.5, 40)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleFont:[UIFont systemFontOfSize:13]];
    [sureBtn setTitleColor:UIColorFromRGB(0x525252) forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(makeSureChangeAge) forControlEvents:UIControlEventTouchUpInside];
    [ageView addSubview:sureBtn];
    _agePickView = [[UIPickerView alloc] initWithFrame:CGRectMake(50, 0, 60, 109)];
    _agePickView.backgroundColor = [UIColor whiteColor];
    _agePickView.dataSource = self;
    _agePickView.delegate = self;
    [ageView addSubview:_agePickView];
    UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaxX(_agePickView) + 20, 40, 20, 40)];
    yearLabel.text = @"年";
    yearLabel.font = [UIFont systemFontOfSize:13];
    yearLabel.textColor = UIColorFromRGB(0x585858);
    yearLabel.textAlignment  = NSTextAlignmentCenter;
    [ageView addSubview:yearLabel];
}

#pragma mark UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 100;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 60;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view) {
        view = [[UIView alloc]init];
    }
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
    leftLabel.text = [NSString stringWithFormat:@"%ld", (long)row];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.font = [UIFont systemFontOfSize:13];
    leftLabel.textColor = UIColorFromRGB(0x525252);
    leftLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [view addSubview:leftLabel];
    return view;
}

- (void)makeSureChangeAge{
    [_shadowView removeFromSuperview];
    NSInteger row=[_agePickView selectedRowInComponent:0];
    NSString *value= [NSString stringWithFormat:@"%ld年", (long)row];
    [_core changeUserInfomationWithUserId:[UserInfoList loginUserId] newInfomation:value infoKey:@"age" saveKey:[AccountManeger loginUserAge]];
}

#pragma mark 点击的是修改擅长科目
- (void)creatSubjectView{
    [self addShadowView];
    _subArray = [[NSMutableArray alloc] init];
    _selectedSubArray = [[NSMutableArray alloc] init];
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Height - 195, Main_Width, 195)];
    subView.backgroundColor = [UIColor whiteColor];
    subView.userInteractionEnabled = YES;
    [_shadowView addSubview:subView];
    _subArray = @[@"语文", @"数学", @"英语", @"物理", @"化学", @"生物", @"地理", @"历史",@"政治"];
    for (int i = 0; i < 9; i ++) {
        UIButton *btn = [[UIButton alloc] init];
        if (i < 4) {
            btn.frame = CGRectMake(15 + i * ((Main_Width - 222) / 3 + 48), 22, 48, 18);
        }else if (i < 8){
            btn.frame = CGRectMake(15 + (i - 4) * ((Main_Width - 222) / 3 + 48), 62, 48, 18);
        }else{
            btn.frame = CGRectMake(15 + (i - 8) * ((Main_Width - 222) / 3 + 48), 102, 48, 18);
        }
        [btn setTitle:_subArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x494949) forState:UIControlStateNormal];
        [btn setTitleFont:[UIFont systemFontOfSize:12]];
        btn.selected = NO;
        btn.layer.borderColor = [UIColorFromRGB(0xe2e2e2)CGColor];
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 2;
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(choseFavoriteSub:) forControlEvents:UIControlEventTouchUpInside];
        [subView addSubview:btn];
    }
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 150, Main_Width, 5)];
    line.backgroundColor = UIColorFromRGB(0xe2e2e2);
    [subView addSubview:line];
    UIButton *subSureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 155, Main_Width, 40)];
    [subSureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [subSureBtn setTitleColor:UIColorFromRGB(0x3b3b3b) forState:UIControlStateNormal];
    [subSureBtn setTitleFont:[UIFont systemFontOfSize:13]];
    [subSureBtn addTarget:self action:@selector(makeSureChangeSub:) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:subSureBtn];
}

#pragma mark 点击擅长课程列表
- (void)choseFavoriteSub:(UIButton *)btn{
    if (!btn.selected) {
        [btn setTitleColor:UIColorFromRGB(0xff6949) forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColorFromRGB(0xff6949)CGColor];
        [_selectedSubArray addObject:_subArray[btn.tag - 100]];
    }else{
        [btn setTitleColor:UIColorFromRGB(0x494949) forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColorFromRGB(0xe2e2e2)CGColor];
        for (NSString *string in _selectedSubArray) {
            if ([string isEqualToString:_subArray[btn.tag - 100]]) {
                [_selectedSubArray removeObject:string];
            }
        }
    }
    btn.selected = !btn.selected;
}

#pragma mark 点击确认修改擅长课程按钮
- (void)makeSureChangeSub:(UIButton *)btn{
    [self cancelShadowView];
    NSString *subString = [[NSString alloc]init];
    if (!_selectedSubArray || _selectedSubArray.count == 0) {
        [self showMessage:@"请选择您擅长的课程"];
    }else{
        subString = _selectedSubArray[0];
        for (int i = 0; i < _selectedSubArray.count -1; i ++) {
            NSString *string = [NSString stringWithFormat:@"、%@", _selectedSubArray[i + 1]];
            subString = [subString stringByAppendingString:string];
        }
        [_core changeUserInfomationWithUserId:[UserInfoList loginUserId] newInfomation:subString infoKey:@"subject" saveKey:[AccountManeger loginUserSubject]];
    }
}

#pragma mark UserInfoCoreDelegate（修改信息回调）
- (void)passChangeResult:(NSString *)result
{
    NSString *message = [[NSString alloc] init];
    if ([result isEqualToString:@"success"]) {
        message = @"修改成功";
        [self getUserInfomation];
        [_userInfoTabelView reloadData];
    }else{
        message = @"修改失败";
    }
    [self showMessage:message];
}

- (void)getUserInfomation
{
    _firstSectionSignArr = @[@"头像", @"名字", @"账号"];
    NSString *accountString = [[NSString alloc] init];
    if ([UserInfoList loginSfStatus]) {//第三方登陆
        if ([[UserInfoList loginSfType] isEqualToString:@"QQ"]) {
            accountString = @"QQ账号登陆";
        }else if ([[UserInfoList loginSfType] isEqualToString:@"WeChat"]){
            accountString = @"微信账号登陆";
        }else if ([[UserInfoList loginSfType] isEqualToString:@"Sina"]){
            accountString = @"新浪微博账号登陆";
        }
    }else{//非第三方登陆
        accountString = [UserInfoList loginUserPhone];
    }
    _firstSectionTextArr = @[@"", [UserInfoList loginUserNickname], accountString];
    NSString *cityString = [NSString stringWithFormat:@"%@%@", [UserInfoList loginUserProvince], [UserInfoList loginUserCity]];
    NSString *sexString = ([[UserInfoList loginUserGender] isEqualToString: @"M"]) ? @"男": @"女";
    if ([[UserInfoList loginUserType] isEqualToString:@"S"] ) {
        //如果是学生
        _secondSectionSignArr = @[@"性别", @"年级", @"地区", @"个性签名"];
        _secondSectionTextArr = @[sexString, [UserInfoList loginUserGrade], cityString, [UserInfoList loginUserSignature]];
    }else{
        //如果是老师
        _secondSectionSignArr = @[@"性别", @"教龄", @"地区", @"擅长科目", @"在职院校", @"所获荣誉", @"个性签名"];
        _secondSectionTextArr = @[sexString, [UserInfoList loginUserAge], cityString, [UserInfoList loginUserSubject], [UserInfoList loginUserSchool], [UserInfoList loginUserHonors],[UserInfoList loginUserSignature]];
    }
}

- (void)addShadowView{
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Width, Main_Height)];
    _shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    _shadowView.userInteractionEnabled = YES;
    [self.view.window addSubview:_shadowView];
}

- (void)cancelShadowView
{
    [_shadowView removeFromSuperview];
}

@end
