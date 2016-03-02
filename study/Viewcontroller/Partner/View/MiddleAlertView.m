//
//  MiddleAlertView.m
//  study
//
//  Created by yang on 16/1/19.
//  Copyright © 2016年 mijibao. All rights reserved.
//

#import "MiddleAlertView.h"

@implementation MiddleAlertView


- (void)setupSubviews {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"1" message:@"1" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ac = [UIAlertAction actionWithTitle:@"2" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
//    UIAlertAction *bac = [UIAlertAction actionWithTitle:<#(nullable NSString *)#> style:<#(UIAlertActionStyle)#> handler:<#^(UIAlertAction * _Nonnull action)handler#>]
}

@end
