//
//  CommentModel.h
//  study
//
//  Created by mijibao on 16/1/25.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic, copy) NSString *image;      //照片
@property (nonatomic, copy) NSString *name;       //名字
@property (nonatomic, copy) NSString *time;       //时间
@property (nonatomic, copy) NSString *content;    //内容
@property (nonatomic, assign) CGFloat height;     //高度
@property (nonatomic, strong) NSArray *commentArray; //二级评论
@property (nonatomic, assign, getter = isOpened) BOOL opened;
@property (nonatomic, strong) NSIndexPath *indexPath;

+ (instancetype)commentWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
