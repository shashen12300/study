//
//  CollectionModel.h
//  study
//
//  Created by mijibao on 16/1/26.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionModel : NSObject

@property (nonatomic, assign) NSInteger userId;//用户id
@property (nonatomic, assign) NSInteger lecrureid;//课程id
@property (nonatomic, copy) NSString *grade;//年级
@property (nonatomic, copy) NSString *subject;//数学
@property (nonatomic, copy) NSString *title;//标题
@property (nonatomic, copy) NSString *duration;//时长
@property (nonatomic, copy) NSString *picurl;//图片
@property (nonatomic, copy) NSString *addtime;//收藏时间
@property (nonatomic, copy) NSString *expriretime;//失效时间

@end
