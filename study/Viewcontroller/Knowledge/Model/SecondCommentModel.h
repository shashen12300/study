//
//  SecondCommentModel.h
//  study
//
//  Created by mijibao on 16/2/17.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecondCommentModel : NSObject

@property (nonatomic, copy) NSString *image;      //照片
@property (nonatomic, copy) NSString *name;       //名字
@property (nonatomic, copy) NSString *time;       //时间
@property (nonatomic, copy) NSString *content;    //内容
@property (nonatomic, assign) CGFloat height;     //高度
@property (nonatomic, assign, getter = isOpened) BOOL opened;  //是否关闭部分评论


+ (instancetype)commentWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
