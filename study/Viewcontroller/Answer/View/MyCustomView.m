//
//  MyCustomView.m
//  jinherIU
//
//  Created by weicaiyan on 14-7-7.
//  Copyright (c) 2014年 hoho108. All rights reserved.
//

#import "MyCustomView.h"

@implementation MyCustomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
#pragma mark - 封装一个方法 创建不同的label
+ (UILabel *)creatLabelWithFrame:(CGRect)frame
                            text:(NSString *)text
                       alignment:(NSTextAlignment)textAlignment{
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textAlignment = textAlignment;
    label.backgroundColor = [UIColor clearColor];
    label.font=[UIFont systemFontOfSize:14];
    return label;
}
#pragma mark 创建button
+ (UIButton *)creatButtonFrame:(CGRect)frame
                         title:(NSString *)string
                          Type:(UIButtonType)type
                        target:(id)target
                        action:(SEL)sel
                           tag:(NSInteger)tag{
    
    UIButton *button = [UIButton buttonWithType:type];
    //roundrect
    button.frame = frame;
    [button setTitle:string forState:UIControlStateNormal];
    //[button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.tag = tag;
    //[button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}
#pragma mark------------创建View
+(UIView*)creatViewFrame:(CGRect)frame {
    UIView *view=[[UIView alloc]initWithFrame:frame];
    return view;
}
+(UIImageView*)creatImageFrame:(CGRect)frame image:(NSString*)imageName :(BOOL)userInteractionEnabled {
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    imageView.image=[UIImage imageNamed:imageName];
    imageView.userInteractionEnabled=userInteractionEnabled;
    return imageView;
}

@end
