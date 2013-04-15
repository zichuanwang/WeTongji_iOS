//
//  WTErrorHandler.m
//  WeTongji
//
//  Created by 王 紫川 on 13-4-13.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import "WTErrorHandler.h"
#import <WeTongjiSDK/NSError+WTSDKClientErrorGenerator.h>
#import "UIApplication+WTAddition.h"
#import "WTLoginViewController.h"

@implementation WTErrorHandler

+ (void)handleError:(NSError *)error {
    
    if (error.code == ErrorCodeUserSessionExpired || error.code == ErrorCodeNeedUserLogin) {
        [WTLoginViewController show:NO];
    }
}

@end