//
//  LectureRootGroupModel.h
//  study
//
//  Created by mijibao on 16/2/16.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LectureRootGroupModel : NSObject

//@property (nonatomic, strong) NSArray *leafArray;        //二级评论
//@property (nonatomic, strong) NSString *commentId;       //评论人ID
//@property (nonatomic, strong) NSString *commentImageUrl; //评论人头像
//@property (nonatomic, strong) NSString *beCommentId;     //被评论人ID
//@property (nonatomic, strong) NSString *commentTime;     //评论时间
//@property (nonatomic, strong) NSString *commentName;     //评论人名字
//@property (nonatomic, strong) NSString *commentContent;  //评论内容

@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger online;
@property (nonatomic, assign) CGFloat headHeight;


@property (nonatomic, assign, getter = isOpened) BOOL opened;

+ (instancetype)cellLeafWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
