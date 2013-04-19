//
//  UIImageView+AsyncLoading.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-19.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "UIImageView+AsyncLoading.h"
#import <WeTongjiSDK/AFNetworking/UIImageView+AFNetworking.h>

@implementation UIImageView (AsyncLoading)

- (void)loadImageWithImageURLString:(NSString *)imageURLString {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURLString]];
    
    BlockARCWeakSelf weakSelf = self;
    [weakSelf setImageWithURLRequest:request
                placeholderImage:nil
                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                             weakSelf.image = image;
                             [self fadeIn];
                         }
                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                             
                         }];
}

@end
