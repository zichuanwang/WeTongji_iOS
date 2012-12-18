//
//  WTResourceFactory.m
//  WeTongji
//
//  Created by 王 紫川 on 12-12-18.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTResourceFactory.h"

@implementation WTResourceFactory

+ (UIButton *)createNavigationBarButtonWithText:(NSString *)text {
    UIButton *button = [[UIButton alloc] init];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0);
    UIImage *normalImage = [[UIImage imageNamed:@"WTNavigationBarButton"] resizableImageWithCapInsets:insets];
    
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    button.titleLabel.shadowOffset = CGSizeMake(0, 1);
    CGFloat titleLabelWidth = [text sizeWithFont:button.titleLabel.font].width;
    
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button resetSize:CGSizeMake(titleLabelWidth + 30, normalImage.size.height)];
    
    return button;
}

@end
