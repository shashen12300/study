//
//  HJAlertView.h
//  study
//
//  Created by jzkj on 16/1/26.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectIndex) (NSInteger index);
@interface HJAlertView : UIView

/**
 *  底部alert
 *
 *  @param titles      title数组
 *  @param selectIndex 回调block 从0开始
 */
- (void)showBottomAlertViewWithTitles:(NSArray *)titles ClickBtn:(SelectIndex)selectIndex;
/**
 *  alert提示框
 *
 *  @param content     内容
 *  @param cancel      取消按钮
 *  @param other       确定按钮
 *  @param hidden      自动消失
 *  @param selectIndex 回调block  取消0 从0开始
 */
- (void)showAlertViewWithContent:(NSString *)content
                  cancelBtnTitle:(NSString *)cancel
                   otherBtnTitle:(NSString *)other
                    isAutoHidden:(BOOL)hidden
                     selectBlock:(SelectIndex)selectIndex;
@end
