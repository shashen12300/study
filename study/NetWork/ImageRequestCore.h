//
//  ImageRequestCore.h
//  study
//
//  Created by mijibao on 15/10/15.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageRequestCore : NSObject

+ (UIImage*)imageWithUrl:(NSString *)path;
+ (void)requestImageWithPath:(NSString *)path withImageView:(UIImageView *)imageView placeholderImage:(UIImage *)image;

@end
