//
//  CircularClipView.h
//  MasonryDemo
//
//  Created by 杨淑园 on 15/11/17.
//  Copyright © 2015年 yangshuyaun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSHYClipViewController;
typedef enum{
    CIRCULARCLIP   = 0,   //圆形裁剪
    SQUARECLIP            //方形裁剪
    
}ClipType;

@protocol ClipViewControllerDelegate <NSObject>

-(void)ClipViewController:(YSHYClipViewController *)clipViewController FinishClipImage:(UIImage *)editImage;

@end



@interface YSHYClipViewController : BaseViewController<UIGestureRecognizerDelegate>
{
    UIImageView *_imageView;
    UIImage *_image;
    UIView * _overView;
}
@property (nonatomic, assign) CGFloat scaleRation;//图片缩放的最大倍数
@property (nonatomic, assign) CGFloat circulWidht;//裁剪框宽度一半
@property (nonatomic, assign) CGFloat circulHeight;//裁剪框高度一半
@property (nonatomic, assign) CGFloat radius; //圆形裁剪框的半径
@property (nonatomic, assign) CGRect circularFrame;//裁剪框的frame
@property (nonatomic, assign) CGRect OriginalFrame;
@property (nonatomic, assign) CGRect currentFrame;
@property (nonatomic, strong) UIButton *clipBtn;
@property (nonatomic, assign)ClipType clipType;  //裁剪的形状
@property (nonatomic, assign) NSString *passBtnString;
@property (nonatomic, strong)id<ClipViewControllerDelegate>delegate;

-(instancetype)initWithImage:(UIImage *)image;
@end
