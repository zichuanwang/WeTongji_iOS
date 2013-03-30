//
//  WTEventDetailViewController.h
//  WeTongji
//
//  Created by 王 紫川 on 12-12-19.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;

@interface WTActivityDetailViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *organizerAvatarContainerView;
@property (nonatomic, weak) IBOutlet UIImageView *organizerAvatarImageView;

+ (WTActivityDetailViewController *)createActivityDetailViewControllerWithActivity:(Activity *)activity
                                                                 backBarButtonText:(NSString *)backBarButtonText;

@end
