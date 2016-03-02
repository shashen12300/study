//
//  SearchViewController.h
//  study
//
//  Created by mijibao on 16/1/18.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewControllerDelegate <NSObject>

- (void)searchLectureTitle:(NSString *)title;

@end

@interface SearchViewController : BaseViewController

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, weak)id<SearchViewControllerDelegate>delegate;
@end
