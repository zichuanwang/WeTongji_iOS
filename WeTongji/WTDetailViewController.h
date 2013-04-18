//
//  WTDetailViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 13-4-18.
//  Copyright (c) 2013年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  WTLikeButtonView;

@interface WTDetailViewController : UIViewController

@property (nonatomic, copy) NSString *backBarButtonText;

@property (nonatomic, weak) WTLikeButtonView *likeButtonContainerView;

@end
