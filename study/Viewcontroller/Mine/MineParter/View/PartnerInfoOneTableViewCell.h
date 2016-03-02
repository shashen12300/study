//
//  PartnerInfoOneTableViewCell.h
//  study
//
//  Created by mijibao on 16/1/28.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartnerInfoOneTableViewCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UILabel *signLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UITextView *contentText;
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, copy) NSArray *colletionArray;
@property (nonatomic, strong) UILabel *choseLabel;

- (void)drawLabelFrame:(NSString *)string cellHeight:(CGFloat)cellHeight contentHeight:(CGFloat)honorsHeight;
- (void)reloadDataofCollectionView:(NSArray *)array;
- (void)drawSignLabelFrame;

@end
