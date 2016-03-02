//
//  LectureLeafModel.h
//  study
//
//  Created by mijibao on 16/2/16.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LectureLeafModel : NSObject

//@property (nonatomic, strong) NSString *commentId;       //评论人ID
//@property (nonatomic, strong) NSString *commentImageUrl; //评论人头像
//@property (nonatomic, strong) NSString *beCommentId;     //被评论人ID
//@property (nonatomic, strong) NSString *commentTime;     //评论时间
//@property (nonatomic, strong) NSString *commentName;     //评论人名字
//@property (nonatomic, strong) NSString *commentContent;  //评论内容

@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *vip;


+ (instancetype)insLeafWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
