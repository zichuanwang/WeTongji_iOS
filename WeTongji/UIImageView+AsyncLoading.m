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
    [self loadImageWithImageURLString:imageURLString success:nil failure:nil];
}

- (void)loadImageWithImageURLString:(NSString *)imageURLString
                            success:(void (^)(UIImage *image))success
                            failure:(void (^)(void))failure {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageURLString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    [request setHTTPShouldHandleCookies:NO];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    BlockARCWeakSelf weakSelf = self;
    [weakSelf setImageWithURLRequest:request
                    placeholderImage:nil
                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                 // NSLog(@"request:%@", [request allHTTPHeaderFields]);
                                 // NSLog(@"response:%@", [response allHeaderFields]);
                                 weakSelf.image = image;
                                 [self fadeIn];
                                 
                                 if (success)
                                     success(image);
                             }
                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                 if (failure)
                                     failure();
                             }];
}

@end
