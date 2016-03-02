//
//  ImageRequestCore.m
//  study
//
//  Created by mijibao on 15/10/15.
//  Copyright © 2015年 jzkj. All rights reserved.
//

#import "ImageRequestCore.h"
#import "UIImageView+MJWebCache.h"

@implementation ImageRequestCore

+ (void)requestImageWithPath:(NSString *)path withImageView:(UIImageView *)imageView placeholderImage:(UIImage *)image
{
    if (path && ![JZCommon isBlankString:path]) {
        NSRange range = NSMakeRange(0, 4);
        NSString *fromString = [path substringWithRange:range];
        NSString *imageStr = [[NSString alloc] init];
        if ([fromString isEqualToString:@"http"]) {
            imageStr = path;
        }else{
            imageStr =[JZCommon getFileDownloadPath:path];
        }
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:image];
    }else{
       [imageView setImage:image];
    }
    
}

+ (void)setLoginuserHeadImageWithPath:(NSString *)path withImageView:(UIImageView *)imageView placeholderImage:(UIImage *)image{
    if (path) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:image];
    }else{
        [imageView setImage:image];
    }
}

//+ (UIImage *)requestImageWithPath:(NSString *)path{
//    if (path && ![JZCommon isBlankString:path]) {
//        NSRange range = NSMakeRange(0, 4);
//        NSString *fromString = [path substringWithRange:range];
//        NSString *imageStr = [[NSString alloc] init];
//        if ([fromString isEqualToString:@"http"]) {
//            imageStr = path;
//        }else{
//            imageStr =[JZCommon getFileDownloadPath:path];
//        }
//        
//        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:image];
//    }else{
//        [imageView setImage:image];
//    }
//}
+ (UIImage*)imageWithUrl:(NSString *)path
{
    if (path && ![JZCommon isBlankString:path]) {
        NSRange range = NSMakeRange(0, 4);
        NSString *fromString = [path substringWithRange:range];
        NSString *imageStr = [[NSString alloc] init];
        if ([fromString isEqualToString:@"http"]) {
            imageStr = path;
        }else{
            imageStr =[JZCommon getFileDownloadPath:path];
        }
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageStr];
        return cachedImage;
    }else{
        return nil;
    }
}

@end
