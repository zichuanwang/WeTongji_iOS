//
//  WTTabBarButton.h
//  WeTongji
//
//  Created by 王 紫川 on 12-11-14.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTTabBarButton : UIButton

@property (nonatomic, strong) UIImageView *customSelectImageView;

- (void)showCustomSelectImage;
- (void)hideCustomSelectImage;

@end
