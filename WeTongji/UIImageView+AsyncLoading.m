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
    
    WTLOG(@"image URL:%@", imageURLString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageURLString] cachePolicy:NSURLRequestReturnCacheDataDontLoad timeoutInterval:60];
    
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
                                 
                                 WTLOG(@"Current disk cache usage:%d", [[NSURLCache sharedURLCache] currentDiskUsage] / 1024);
                                 WTLOG(@"Current memory cache usage:%d", [[NSURLCache sharedURLCache] currentMemoryUsage] / 1024);
                             }
                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                 WTLOGERROR(@"Load image:%@", error.localizedDescription);
                                 if (failure)
                                     failure();
                             }];
}

@end
