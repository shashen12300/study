//
//  MyCustomView.h
//  jinherIU
//
//  Created by weicaiyan on 14-7-7.
//  Copyright (c) 2014年 hoho108. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCustomView : UIView
+ (UILabel *)creatLabelWithFrame:(CGRect)frame
                            text:(NSString *)text
                       alignment:(NSTextAlignment)textAlignment;

+ (UIButton *)creatButtonFrame:(CGRect)frame
                         title:(NSString *)string
                          Type:(UIButtonType)type
                        target:(id)target
                        action:(SEL)sel
                           tag:(NSInteger)tag;

+(UIImageView*)creatImageFrame:(CGRect)frame image:(NSString*)imageName :(BOOL)userInteractionEnabled;
+(UIView*)creatViewFrame:(CGRect)frame ;
@end
