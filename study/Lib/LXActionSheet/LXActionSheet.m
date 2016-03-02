//
//  LXActionSheet.m
//  LXActionSheetDemo
//
//  Created by lixiang on 14-3-10.
//  Copyright (c) 2014年 lcolco. All rights reserved.
//

#import "LXActionSheet.h"

#define CANCEL_BUTTON_COLOR                     [UIColor whiteColor]//[UIColor colorWithRed:53/255.00f green:53/255.00f blue:53/255.00f alpha:1]
#define DESTRUCTIVE_BUTTON_COLOR                [UIColor colorWithRed:185/255.00f green:45/255.00f blue:39/255.00f alpha:1]
#define OTHER_BUTTON_COLOR                      [UIColor whiteColor]
#define ACTIONSHEET_BACKGROUNDCOLOR             [UIColor colorWithRed:210/255.00f green:210/255.00f blue:210/255.00f alpha:1]
#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define CORNER_RADIUS                           0//5

#define BUTTON_INTERVAL_HEIGHT                  3//20
#define BUTTON_HEIGHT                           45//55//40
#define BUTTON_INTERVAL_WIDTH                   0//30
#define BUTTON_WIDTH                            Main_Screen_Width//260
#define BUTTONTITLE_FONT                        [UIFont systemFontOfSize:13]//[UIFont fontWithName:@"Arial Rounded MT Bold" size:13]
#define BUTTON_BORDER_WIDTH                     0.3f
#define BUTTON_BORDER_COLOR                     [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1].CGColor


#define TITLE_INTERVAL_HEIGHT                  15//15
#define TITLE_HEIGHT                            35
#define TITLE_INTERVAL_WIDTH                    30
#define TITLE_WIDTH                             Main_Screen_Width  //260
#define TITLE_FONT                              [UIFont systemFontOfSize:13]//[UIFont fontWithName:@"Helvetica-Bold" size:13]
#define SHADOW_OFFSET                           CGSizeMake(0, 0.8f)
#define TITLE_NUMBER_LINES                      2

#define ANIMATE_DURATION                        0.25f

@interface LXActionSheet ()
@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,strong) NSString *actionTitle;
@property (nonatomic,assign) NSInteger postionIndexNumber;
@property (nonatomic,assign) BOOL isHadTitle;
@property (nonatomic,assign) BOOL isHadDestructionButton;
@property (nonatomic,assign) BOOL isHadOtherButton;
@property (nonatomic,assign) BOOL isHadCancelButton;
@property (nonatomic,assign) CGFloat LXActionSheetHeight;
@property (nonatomic,assign) id<LXActionSheetDelegate>delegate;

@end
@implementation LXActionSheet

#pragma mark - Public method

- (id)initWithTitle:(NSString *)title delegate:(id<LXActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray;
{
    self = [super init];
    if (self) {
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
    
        if (delegate) {
            self.delegate = delegate;
        }
    
        [self creatButtonsWithTitle:title cancelButtonTitle:cancelButtonTitle destructionButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitlesArray];

    }
    return self;
}

- (void)showInView:(UIView *)view
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

#pragma mark - CreatButtonAndTitle method

- (void)creatButtonsWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructionButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray
{
    //初始化
    self.isHadTitle = NO;
    self.isHadDestructionButton = NO;
    self.isHadOtherButton = NO;
    self.isHadCancelButton = NO;

    //初始化LXACtionView的高度为0
    self.LXActionSheetHeight = 0;

    //初始化IndexNumber为0;
    self.postionIndexNumber = 0;
    
    //生成LXActionSheetView
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
    self.backGroundView.backgroundColor = ACTIONSHEET_BACKGROUNDCOLOR;
    
    //给LXActionSheetView添加响应事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackGroundView)];
    [self.backGroundView addGestureRecognizer:tapGesture];
    
    [self addSubview:self.backGroundView];
    
    if (title) {  //nil
        self.isHadTitle = YES;
        UILabel *titleLabel = [self creatTitleLabelWith:title];
        self.LXActionSheetHeight = self.LXActionSheetHeight + 2*TITLE_INTERVAL_HEIGHT+TITLE_HEIGHT;
        [self.backGroundView addSubview:titleLabel];
    }

    if (destructiveButtonTitle) {
        self.isHadDestructionButton = YES;
        
        UIButton *destructiveButton = [self creatDestructiveButtonWith:destructiveButtonTitle];
        destructiveButton.tag = self.postionIndexNumber;
        [destructiveButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.isHadTitle == YES) {
            //当有title时
            [destructiveButton setFrame:CGRectMake(destructiveButton.frame.origin.x, self.LXActionSheetHeight, destructiveButton.frame.size.width, destructiveButton.frame.size.height)];
            
            if (otherButtonTitlesArray && otherButtonTitlesArray.count > 0) {
                self.LXActionSheetHeight = self.LXActionSheetHeight + destructiveButton.frame.size.height+BUTTON_INTERVAL_HEIGHT/2;
            }
            else{
                self.LXActionSheetHeight = self.LXActionSheetHeight + destructiveButton.frame.size.height+BUTTON_INTERVAL_HEIGHT;
            }
        }
        else{
            //当无title时
            if (otherButtonTitlesArray && otherButtonTitlesArray.count > 0) {
                self.LXActionSheetHeight = self.LXActionSheetHeight + destructiveButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT+(BUTTON_INTERVAL_HEIGHT/2));
            }
            else{
                self.LXActionSheetHeight = self.LXActionSheetHeight + destructiveButton.frame.size.height+(2*BUTTON_INTERVAL_HEIGHT);
            }
        }
        [self.backGroundView addSubview:destructiveButton];
        
        self.postionIndexNumber++;
    }
    
    if (otherButtonTitlesArray) {
        if (otherButtonTitlesArray.count > 0) {
            self.isHadOtherButton = YES;
            //当无title与destructionButton时
            if (self.isHadTitle == NO && self.isHadDestructionButton == NO) {
                for (int i = 0; i<otherButtonTitlesArray.count; i++) {
                    UIButton *otherButton = [self creatOtherButtonWith:[otherButtonTitlesArray objectAtIndex:i] withPostion:i];
                    
                    otherButton.tag = self.postionIndexNumber;
                    [otherButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (i != otherButtonTitlesArray.count - 1) {
                        self.LXActionSheetHeight = self.LXActionSheetHeight + otherButton.frame.size.height+0;//(BUTTON_INTERVAL_HEIGHT/2);
                    }
                    else{
                        self.LXActionSheetHeight = self.LXActionSheetHeight + otherButton.frame.size.height+(2*BUTTON_INTERVAL_HEIGHT);
                    }
                    
                    [self.backGroundView addSubview:otherButton];
                
                    self.postionIndexNumber++;
                }
            }
            
            //当有title或destructionButton时
            if (self.isHadTitle == YES || self.isHadDestructionButton == YES) {
                for (int i = 0; i<otherButtonTitlesArray.count; i++) {
                    UIButton *otherButton = [self creatOtherButtonWith:[otherButtonTitlesArray objectAtIndex:i] withPostion:i];
            
                    otherButton.tag = self.postionIndexNumber;
                    [otherButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
                    [otherButton setFrame:CGRectMake(otherButton.frame.origin.x, self.LXActionSheetHeight, otherButton.frame.size.width, otherButton.frame.size.height)];
                    
                    if (i != otherButtonTitlesArray.count - 1) {
                        self.LXActionSheetHeight = self.LXActionSheetHeight + otherButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT/2);
                    }
                    else{
                        self.LXActionSheetHeight = self.LXActionSheetHeight + otherButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT);
                    }
                    
                    [self.backGroundView addSubview:otherButton];
                    
                    self.postionIndexNumber++;
                }
            }
        }
    }
    
    if (cancelButtonTitle) {
        self.isHadCancelButton = YES;
        
        UIButton *cancelButton = [self creatCancelButtonWith:cancelButtonTitle];
        
        cancelButton.tag = self.postionIndexNumber;
        [cancelButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
        
        //当没title destructionButton otherbuttons时
        if (self.isHadTitle == NO && self.isHadDestructionButton == NO && self.isHadOtherButton == NO) {
            self.LXActionSheetHeight = self.LXActionSheetHeight + cancelButton.frame.size.height+0;//(2*BUTTON_INTERVAL_HEIGHT);
        }
        
        //当有title或destructionButton或otherbuttons时
        if (self.isHadTitle == YES || self.isHadDestructionButton == YES || self.isHadOtherButton == YES) {
            [cancelButton setFrame:CGRectMake(cancelButton.frame.origin.x, self.LXActionSheetHeight, cancelButton.frame.size.width, cancelButton.frame.size.height)];
            self.LXActionSheetHeight = self.LXActionSheetHeight + cancelButton.frame.size.height+0;//BUTTON_INTERVAL_HEIGHT;
        }
        
        [self.backGroundView addSubview:cancelButton];
        
        self.postionIndexNumber++;
    }
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.LXActionSheetHeight, [UIScreen mainScreen].bounds.size.width, self.LXActionSheetHeight)];
    } completion:^(BOOL finished) {
    }];
}

- (UILabel *)creatTitleLabelWith:(NSString *)title
{
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_INTERVAL_WIDTH, TITLE_INTERVAL_HEIGHT, TITLE_WIDTH, TITLE_HEIGHT)];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.shadowColor = [UIColor blackColor];
    titlelabel.shadowOffset = SHADOW_OFFSET;
    titlelabel.font = TITLE_FONT;
    titlelabel.text = title;
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.numberOfLines = TITLE_NUMBER_LINES;
    return titlelabel;
}

- (UIButton *)creatDestructiveButtonWith:(NSString *)destructiveButtonTitle
{
    UIButton *destructiveButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_INTERVAL_WIDTH, BUTTON_INTERVAL_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT)];
    destructiveButton.layer.masksToBounds = YES;
    destructiveButton.layer.cornerRadius = CORNER_RADIUS;
    
    destructiveButton.layer.borderWidth = BUTTON_BORDER_WIDTH;
    destructiveButton.layer.borderColor = BUTTON_BORDER_COLOR;
    
    destructiveButton.backgroundColor = DESTRUCTIVE_BUTTON_COLOR;
    [destructiveButton setTitle:destructiveButtonTitle forState:UIControlStateNormal];
    destructiveButton.titleLabel.font = BUTTONTITLE_FONT;
    
    [destructiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [destructiveButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    return destructiveButton;
}

- (UIButton *)creatOtherButtonWith:(NSString *)otherButtonTitle withPostion:(NSInteger )postionIndex
{
  //  UIButton *otherButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_INTERVAL_WIDTH, BUTTON_INTERVAL_HEIGHT + (postionIndex*(BUTTON_HEIGHT+(BUTTON_INTERVAL_HEIGHT/2))), BUTTON_WIDTH, BUTTON_HEIGHT)];
    UIButton *otherButton = [[UIButton alloc]initWithFrame:CGRectMake(BUTTON_INTERVAL_WIDTH, postionIndex*(BUTTON_HEIGHT+0.8), BUTTON_WIDTH, BUTTON_HEIGHT)];
//    otherButton.layer.masksToBounds = YES;
//    otherButton.layer.cornerRadius = CORNER_RADIUS;
//    
//    otherButton.layer.borderWidth = BUTTON_BORDER_WIDTH;
//    otherButton.layer.borderColor = BUTTON_BORDER_COLOR;
//    
    otherButton.backgroundColor = OTHER_BUTTON_COLOR;
    [otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
    otherButton.titleLabel.font = BUTTONTITLE_FONT;
    [otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [otherButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    return otherButton;
}

- (UIButton *)creatCancelButtonWith:(NSString *)cancelButtonTitle
{
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_INTERVAL_WIDTH, BUTTON_INTERVAL_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT)];
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = CORNER_RADIUS;
    
    cancelButton.layer.borderWidth = BUTTON_BORDER_WIDTH;
    cancelButton.layer.borderColor = BUTTON_BORDER_COLOR;
    
    cancelButton.backgroundColor = CANCEL_BUTTON_COLOR;
    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    cancelButton.titleLabel.font = BUTTONTITLE_FONT;
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    return cancelButton;
}

- (void)clickOnButtonWith:(UIButton *)button
{
    if (self.isHadDestructionButton == YES) {
        if (self.delegate) {
            if (button.tag == 0) {
                if ([self.delegate respondsToSelector:@selector(didClickOnDestructiveButton)] == YES){
                    [self.delegate didClickOnDestructiveButton];
                }
            }
        }
    }
    
    if (self.isHadCancelButton == YES) {
        if (self.delegate) {
            if (button.tag == self.postionIndexNumber-1) {
                if ([self.delegate respondsToSelector:@selector(didClickOnCancelButton)] == YES) {
                    [self.delegate didClickOnCancelButton];
                }
            }
        }
    }
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(actionSheet:didClickOnButtonIndex:)] == YES) {
         //   [self.delegate LXActionSheet:self  didClickOnButtonIndex:(NSInteger *)button.tag];
            [self.delegate actionSheet:self didClickOnButtonIndex:(NSInteger)button.tag];
        }
    }
    
    [self tappedCancel];
}

- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)tappedBackGroundView
{
    //
}

@end
